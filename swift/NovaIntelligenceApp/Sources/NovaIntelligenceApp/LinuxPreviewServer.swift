#if os(Linux)
import Foundation
import NIO
import NIOHTTP1
import NIOPosix

enum LinuxPreviewServer {
    static func run() throws {
        let arguments = CommandLine.arguments
        let port = Self.parsePort(from: arguments) ?? 4173
        let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        defer {
            try? group.syncShutdownGracefully()
        }

        let bootstrap = ServerBootstrap(group: group)
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .childChannelInitializer { channel in
                channel.pipeline.configureHTTPServerPipeline().flatMap {
                    channel.pipeline.addHandler(HTTPHandler())
                }
            }
            .childChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
            .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())

        let channel = try bootstrap.bind(host: "0.0.0.0", port: port).wait()
        print("Nova Intelligence (beta) Linux preview available at http://127.0.0.1:\(port)")
        print("Press CTRL+C to stop the server.")
        try channel.closeFuture.wait()
    }

    private static func parsePort(from arguments: [String]) -> Int? {
        guard let index = arguments.firstIndex(of: "--port"), index + 1 < arguments.count else {
            return nil
        }
        return Int(arguments[index + 1])
    }
}

private final class HTTPHandler: ChannelInboundHandler {
    typealias InboundIn = HTTPServerRequestPart
    typealias OutboundOut = HTTPServerResponsePart

    private var requestHead: HTTPRequestHead?

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        switch unwrapInboundIn(data) {
        case .head(let head):
            requestHead = head
        case .body:
            break
        case .end:
            if let head = requestHead {
                handleRequest(head, context: context)
            }
            requestHead = nil
        }
    }

    private func handleRequest(_ head: HTTPRequestHead, context: ChannelHandlerContext) {
        let response: (status: HTTPResponseStatus, headers: HTTPHeaders, body: ByteBuffer)
        switch head.uri {
        case "/", "/index.html":
            response = respond(with: LinuxPreviewAssets.indexHTML, contentType: "text/html; charset=utf-8", allocator: context.channel.allocator)
        case "/styles.css":
            response = respond(with: LinuxPreviewAssets.stylesCSS, contentType: "text/css; charset=utf-8", allocator: context.channel.allocator)
        case "/app.js":
            response = respond(with: LinuxPreviewAssets.appJS, contentType: "application/javascript; charset=utf-8", allocator: context.channel.allocator)
        case "/favicon.ico":
            let buffer = context.channel.allocator.buffer(capacity: 0)
            response = (.notFound, HTTPHeaders(), buffer)
        default:
            response = respond(status: .notFound, body: "Not Found", contentType: "text/plain; charset=utf-8", allocator: context.channel.allocator)
        }

        var head = HTTPResponseHead(version: head.version, status: response.status)
        head.headers = response.headers
        context.write(wrapOutboundOut(.head(head)), promise: nil)
        context.write(wrapOutboundOut(.body(.byteBuffer(response.body))), promise: nil)
        context.writeAndFlush(wrapOutboundOut(.end(nil)), promise: nil)
    }

    private func respond(with body: String, contentType: String, allocator: ByteBufferAllocator) -> (HTTPResponseStatus, HTTPHeaders, ByteBuffer) {
        respond(status: .ok, body: body, contentType: contentType, allocator: allocator)
    }

    private func respond(status: HTTPResponseStatus, body: String, contentType: String, allocator: ByteBufferAllocator) -> (HTTPResponseStatus, HTTPHeaders, ByteBuffer) {
        var buffer = allocator.buffer(capacity: body.utf8.count)
        buffer.writeString(body)
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: contentType)
        headers.add(name: "Content-Length", value: "\(buffer.readableBytes)")
        headers.add(name: "Cache-Control", value: "no-store")
        return (status, headers, buffer)
    }
}
#endif

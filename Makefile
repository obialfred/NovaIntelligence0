IMAGE_NAME ?= nova-intelligence

.PHONY: docker-build docker-run swift-build swift-run

docker-build:
	@docker build -t $(IMAGE_NAME) -f Dockerfile .

docker-run:
	@docker run --rm -p 3000:8080 $(IMAGE_NAME)

swift-build:
	@cd swift/NovaIntelligenceApp && swift build

swift-run:
	@cd swift/NovaIntelligenceApp && swift run

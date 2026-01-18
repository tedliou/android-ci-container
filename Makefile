IMAGE_NAME = tedliou/android-ci-container
REGISTRY = ghcr.io
JDK_VERSION = 17
ANDROID_API = 36
BUILD_TOOLS = 36.1.0
PLATFORMS = linux/amd64,linux/arm64

FULL_IMAGE_TAG = $(REGISTRY)/$(IMAGE_NAME):jdk$(JDK_VERSION)-api$(ANDROID_API)-$(BUILD_TOOLS)
LATEST_TAG = $(REGISTRY)/$(IMAGE_NAME):latest

.PHONY: build build-multi login setup-buildx

build:
	docker build -f src/jdk$(JDK_VERSION).Dockerfile \
		--build-arg ANDROID_API=$(ANDROID_API) \
		--build-arg BUILD_TOOLS=$(BUILD_TOOLS) \
		-t $(FULL_IMAGE_TAG) .

setup-buildx:
	@docker run --privileged --rm tonistiigi/binfmt --install all
	@docker buildx ls | grep -q multi-arch-builder || \
		(docker buildx create --name multi-arch-builder --use && \
		 docker buildx inspect --bootstrap)

build-multi: setup-buildx
	docker buildx build --platform $(PLATFORMS) \
		-f src/jdk$(JDK_VERSION).Dockerfile \
		--build-arg ANDROID_API=$(ANDROID_API) \
		--build-arg BUILD_TOOLS=$(BUILD_TOOLS) \
		-t $(FULL_IMAGE_TAG) \
		-t $(LATEST_TAG) \
		--push .

login:
	@echo $${GITHUB_TOKEN} | docker login $(REGISTRY) -u tedliou --password-stdin

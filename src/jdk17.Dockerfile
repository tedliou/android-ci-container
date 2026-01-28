FROM eclipse-temurin:17-jdk-jammy

ENV ANDROID_SDK_TOOLS="14742923" \
    GRADLE_VERSION="9.3.0" \
    ANDROID_SDK_ROOT="/opt/android-sdk" \
    GRADLE_HOME="/opt/gradle" \
    GRADLE_USER_HOME="/opt/gradle-home"

ENV PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$GRADLE_HOME/bin"

ARG ANDROID_API=36
ARG BUILD_TOOLS=36.1.0

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/* \
    && curl -L -o gradle.zip https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip \
    && unzip gradle.zip -d /opt \
    && mv /opt/gradle-${GRADLE_VERSION} ${GRADLE_HOME} \
    && rm gradle.zip \
    && mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && curl -o sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip \
    && unzip sdk.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
    && mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && rm sdk.zip \
    && yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" \
    "platforms;android-${ANDROID_API}" \
    "build-tools;${BUILD_TOOLS}" \
    && mkdir -p /project ${GRADLE_USER_HOME} \
    && chmod -R 777 /project ${ANDROID_SDK_ROOT} ${GRADLE_USER_HOME}

WORKDIR /project

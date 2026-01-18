FROM eclipse-temurin:17-jdk

ENV ANDROID_SDK_TOOLS="13114758" \
    GRADLE_VERSION="9.3.0" \
    ANDROID_HOME="/opt/android-sdk" \
    GRADLE_HOME="/opt/gradle"

ENV PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$GRADLE_HOME/bin"

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
    && mkdir -p ${ANDROID_HOME}/cmdline-tools \
    && curl -o sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip \
    && unzip sdk.zip -d ${ANDROID_HOME}/cmdline-tools \
    && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && rm sdk.zip \
    && yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" \
                  "platforms;android-${ANDROID_API}" \
                  "build-tools;${BUILD_TOOLS}"

WORKDIR /project

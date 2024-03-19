FROM gitpod/workspace-full-vnc:2024-03-17-11-10-27

# Cambiar el SHELL si es necesario
SHELL ["/bin/bash", "-c"]

# Variables de entorno
ENV ANDROID_HOME=$HOME/androidsdk \
    QTWEBENGINE_DISABLE_SANDBOX=1 \
    KOTLIN_VERSION=1.6.10

ENV PATH="$HOME/flutter/bin:$HOME/.kotlin-native/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# Instalar JDK, Kotlin y otras dependencias
USER root
RUN install-packages default-jdk -y 



# Instalar Kotlin Multiplatform
RUN echo "Downloading Kotlin..." \
    && curl -LO "https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip" \
    && unzip "kotlin-compiler-${KOTLIN_VERSION}.zip" -d "$HOME/.kotlin" \
    && rm "kotlin-compiler-${KOTLIN_VERSION}.zip" \
    && echo "Kotlin downloaded successfully."

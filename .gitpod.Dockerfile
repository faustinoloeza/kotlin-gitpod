FROM gitpod/workspace-full-vnc:2023-11-19-19-13-44

SHELL ["/bin/bash", "-c"]
ENV ANDROID_HOME=$HOME/androidsdk

# Agrega el directorio de Android SDK al PATH
ENV PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

USER root

# Instala wget, tar y OpenJDK
RUN apt-get update \
    && apt-get install -y wget tar openjdk-17-jdk fuse libfuse2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configura la variable de entorno JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Descarga jetbrains-toolbox
RUN wget https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-2.3.1.31116.tar.gz \
    && tar -xvzf jetbrains-toolbox-2.3.1.31116.tar.gz \
    && mv jetbrains-toolbox-2.3.1.31116 /opt/jetbrains-toolbox \
    && rm jetbrains-toolbox-2.3.1.31116.tar.gz \
    && chmod +x /opt/jetbrains-toolbox/jetbrains-toolbox

# Descarga y configura las herramientas de línea de comandos de Android
RUN echo "Downloading Android command line tools..." \
    && _file_name="commandlinetools-linux-11076708_latest.zip" \
    && wget "https://dl.google.com/android/repository/$_file_name" \
    && mkdir -p $ANDROID_HOME/cmdline-tools/latest \
    && unzip "$_file_name" -d $ANDROID_HOME/cmdline-tools/latest \
    && rm -f "$_file_name" \
    && echo "Android command line tools downloaded successfully."

# Update Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get -y install google-chrome-stable \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

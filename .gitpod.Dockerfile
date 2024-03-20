FROM gitpod/workspace-full-vnc:2023-11-19-19-13-44
SHELL ["/bin/bash", "-c"]
ENV ANDROID_HOME=$HOME/androidsdk

# Agrega el directorio de Android SDK al PATH
ENV PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

USER root

# Instala wget, tar y OpenJDK
RUN apt-get update \
    && apt-get install -y wget tar openjdk-18-jdk \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Descarga Android Studio y realiza las operaciones necesarias
RUN wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.2.1.23/android-studio-2023.2.1.23-linux.tar.gz \
    && tar -zxvf android-studio-2023.2.1.23-linux.tar.gz \
    && mv android-studio /opt/ \
    && ln -sf /opt/android-studio/bin/studio.sh /bin/android-studio

RUN echo "Downloading Android command line tools..." \
    && _file_name="commandlinetools-linux-11076708_latest.zip" \
    && wget "https://dl.google.com/android/repository/$_file_name" \
    && unzip "$_file_name" -d $ANDROID_HOME \
    && rm -f "$_file_name" \
    && echo "Android command line tools downloaded successfully."

RUN echo "Setting up Android SDK..." \
    && mkdir -p $ANDROID_HOME/cmdline-tools/latest \
    && mv $ANDROID_HOME/cmdline-tools/{bin,lib} $ANDROID_HOME/cmdline-tools/latest \
    && yes | sdkmanager "platform-tools" "build-tools;34.0.0" "platforms;android-33" \
    && echo "Android SDK set up successfully."


# Crear el archivo .desktop para Android Studio
RUN echo -e '[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=Android Studio\n\
Comment=Android Studio\n\
Exec=bash -i "/opt/android-studio/bin/studio.sh" %f\n\
Icon=/opt/android-studio/bin/studio.png\n\
Categories=Development;IDE;\n\
Terminal=false\n\
StartupNotify=true\n\
StartupWMClass=jetbrains-android-studio\n\
Name[en_GB]=android-studio.desktop' > /usr/share/applications/android-studio.desktop

# Update Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get -y install google-chrome-stable

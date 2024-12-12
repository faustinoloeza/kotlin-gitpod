FROM gitpod/workspace-full-vnc:2024-12-11-07-51-54
SHELL ["/bin/bash", "-c"]
ENV ANDROID_HOME=$HOME/androidsdk

# Agrega el directorio de Android SDK al PATH
ENV PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

USER root

# Instala wget, tar y OpenJDK
RUN apt-get update \
    && apt-get install -y wget tar unzip openjdk-18-jdk \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ENV JAVA_HOME=/usr/lib/jvm/java-18-openjdk-amd64  
ENV PATH="$JAVA_HOME/bin:$PATH"  

# Descarga Android Studio y realiza las operaciones necesarias
RUN wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2024.2.1.12/android-studio-2024.2.1.12-linux.tar.gz \
    && tar -zxvf android-studio-2024.2.1.12-linux.tar.gz \
    && rm android-studio-2024.2.1.12-linux.tar.gz \
    && mv android-studio /opt/ \
    && ln -sf /opt/android-studio/bin/studio.sh /bin/android-studio


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

FROM gitpod/workspace-full-vnc:2023-11-19-19-13-44
SHELL ["/bin/bash", "-c"]

USER root
RUN apt-get update 

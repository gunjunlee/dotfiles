FROM nvcr.io/nvidia/driver:550-5.15.0-1068-oracle-ubuntu22.04

LABEL maintainer="gunjunlee <gunjunlee@gmail.com>"

RUN \
    apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get install -y build-essential cmake ninja-build git sudo ccache htop zsh wget curl

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USER_NAME=gunjunlee

RUN echo "USER_ID: ${USER_ID}"
RUN echo "GROUP_ID: ${GROUP_ID}"
RUN echo "USER_NAME: ${USER_NAME}"

WORKDIR /home/${USER_NAME}

RUN groupadd -g ${GROUP_ID} ${USER_NAME} && \
    useradd -m -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME} -s /bin/zsh && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN chown -chR ${USER_NAME}:${USER_NAME} /home/${USER_NAME}

USER ${USER_NAME}

RUN git clone https://github.com/gunjunlee/dotfiles.git ~/.dotfiles && \
        cd ~/.dotfiles && \
        git submodule update --init --recursive && \
        sudo bash setup.sh && \
        python3 install.py

SHELL ["/bin/zsh", "-c"]


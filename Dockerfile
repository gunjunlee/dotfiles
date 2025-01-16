FROM nvcr.io/nvidia/pytorch:24.10-py3

LABEL maintainer="gunjunlee <gunjunlee97@gmail.com>"

RUN \
    apt-get remove -y neovim && \
    apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get install -y build-essential cmake ninja-build git sudo ccache htop zsh wget curl

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USER_NAME=gunjunlee
ARG USER_HOME=/home/${USER_NAME}

RUN echo "USER_ID: ${USER_ID}"
RUN echo "GROUP_ID: ${GROUP_ID}"
RUN echo "USER_NAME: ${USER_NAME}"
RUN echo "USER_HOME: ${USER_HOME}"

WORKDIR ${USER_HOME}

RUN groupadd -g ${GROUP_ID} ${USER_NAME} && \
    useradd -m -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME} -s /bin/zsh -d ${USER_HOME} && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN chown -chR ${USER_NAME}:${USER_NAME} ${USER_HOME}

USER ${USER_NAME}

RUN git clone https://github.com/gunjunlee/dotfiles.git ~/.dotfiles && \
        cd ~/.dotfiles && \
        git submodule update --init --recursive && \
        sudo bash setup.sh && \
        python3 install.py

RUN . ~/conda/etc/profile.d/conda.sh && \
  conda config --set auto_activate_base false

RUN sudo apt-get remove -y neovim

SHELL ["/bin/zsh", "-c"]

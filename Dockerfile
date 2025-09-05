ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# Copy the build scripts
WORKDIR /
COPY --chmod=755 build/* ./

# Install ComfyUI
ARG TORCH_VERSION
ARG XFORMERS_VERSION
ARG INDEX_URL
ARG COMFYUI_COMMIT
RUN /install_comfyui.sh

# Cleanup installation scripts
RUN rm -f /install_*.sh

# Remove existing SSH host keys
RUN rm -f /etc/ssh/ssh_host_*

# NGINX Proxy
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Set template version
ARG RELEASE
ENV TEMPLATE_VERSION=${RELEASE}

# Set the main venv path
ARG VENV_PATH
ENV VENV_PATH=${VENV_PATH}

# Copy the scripts
WORKDIR /
COPY --chmod=755 scripts/* ./

# Start the container
SHELL ["/bin/bash", "--login", "-c"]
CMD [ "/start.sh" ]

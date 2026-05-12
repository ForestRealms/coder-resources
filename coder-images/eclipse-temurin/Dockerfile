ARG UPSTREAM
FROM ${UPSTREAM}

ARG CHANGE_SOURCE=false
RUN if [ "$CHANGE_SOURCE" = "true" ]; then \
    sed -i 's/archive.ubuntu.com/mirrors.pku.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources && \
    sed -i 's/security.ubuntu.com/mirrors.pku.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources; \
    fi
ARG JETBRAINS_DOWNLOAD_URL
ENV JETBRAINS_DOWNLOAD_URL=${JETBRAINS_DOWNLOAD_URL}
COPY --chown=root:root personalize /root
RUN apt update && apt install -y curl gzip procps && apt clean all && chmod +x /root/personalize
WORKDIR /root
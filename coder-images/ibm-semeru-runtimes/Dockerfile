ARG UPSTREAM
FROM ${UPSTREAM}

ARG CHANGE_SOURCE=false
ARG SYSTEM_MIRROR
RUN if [ "$CHANGE_SOURCE" = "true" ]; then \
      MIRROR_PROTO="${SYSTEM_MIRROR%%://*}" && \
      MIRROR_HOST="${SYSTEM_MIRROR#*://}" && \
      sed -ri "s|https?://archive\.ubuntu\.com|${MIRROR_PROTO}://${MIRROR_HOST}|g" /etc/apt/sources.list.d/ubuntu.sources && \
      sed -ri "s|https?://security\.ubuntu\.com|${MIRROR_PROTO}://${MIRROR_HOST}|g" /etc/apt/sources.list.d/ubuntu.sources; \
    fi
ARG JETBRAINS_DOWNLOAD_URL
ARG FILE_BROWSER_DOWNLOAD_URL
ENV JETBRAINS_DOWNLOAD_URL=${JETBRAINS_DOWNLOAD_URL}
ENV FILE_BROWSER_DOWNLOAD_URL=${FILE_BROWSER_DOWNLOAD_URL}
COPY --chown=root:root personalize /root
COPY --chown=root:root get.sh /root
RUN apt update && apt install -y curl gzip procps && apt clean all && chmod +x /root/personalize && bash /root/get.sh
WORKDIR /root
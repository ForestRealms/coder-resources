ARG UPSTREAM
FROM ${UPSTREAM}

ARG CHANGE_SOURCE=false
COPY --chown=root:root personalize /root
COPY --chown=root:root get.sh /root
ARG JETBRAINS_DOWNLOAD_URL
ARG FILE_BROWSER_DOWNLOAD_URL
ENV JETBRAINS_DOWNLOAD_URL=${JETBRAINS_DOWNLOAD_URL}
ENV FILE_BROWSER_DOWNLOAD_URL=${FILE_BROWSER_DOWNLOAD_URL}
RUN if [ "$CHANGE_SOURCE" = "true" ]; then \
    printf 'Types: deb\n\
URIs: https://mirrors.aliyun.com/debian\n\
Suites: trixie trixie-updates trixie-backports\n\
Components: main contrib non-free non-free-firmware\n\
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg\n\
\n\
Types: deb\n\
URIs: https://mirrors.aliyun.com/debian-security\n\
Suites: trixie-security\n\
Components: main contrib non-free non-free-firmware\n\
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg\n' > /etc/apt/sources.list.d/debian.sources; \
    fi && \
    apt-get update && \
    apt-get install -y curl gzip procps && \
    apt-get clean all && \
    echo 'export PATH=/usr/local/cargo/bin:$PATH' > /etc/profile.d/rust.sh && \
    chmod +x /etc/profile.d/rust.sh && \
    chmod +x /root/personalize && \
    bash /root/get.sh

WORKDIR /root
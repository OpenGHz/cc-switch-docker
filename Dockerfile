FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        dbus-x11 \
        file \
        fonts-dejavu \
        libayatana-appindicator3-1 \
        libfuse2 \
        libgtk-3-0 \
        libnss3 \
        libwebkit2gtk-4.1-0 \
        libxss1 \
        libxtst6 \
        xdg-utils \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 appuser \
    && useradd --uid 1000 --gid 1000 --create-home --shell /bin/bash appuser

ENV HOME=/home/appuser
WORKDIR /home/appuser

COPY entrypoint.sh /usr/local/bin/cc-switch-entrypoint
RUN chmod +x /usr/local/bin/cc-switch-entrypoint

USER appuser
ENTRYPOINT ["/usr/local/bin/cc-switch-entrypoint"]

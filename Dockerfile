FROM scratch
ARG TARGETARCH
ARG TARGETVARIANT
ADD devuan-${TARGETARCH}${TARGETVARIANT}.tar.xz /
CMD ["/bin/bash"]
LABEL org.opencontainers.image.title="devuan"
LABEL org.opencontainers.image.description="Unofficial docker image for Devuan GNU/Linux"
LABEL org.opencontainers.image.source="https://github.com/arfshl/devuan-docker"
LABEL org.opencontainers.image.url="https://github.com/arfshl/devuan-docker"
LABEL org.opencontainers.image.documentation="https://github.com/arfshl/devuan-docker/blob/main/README.md"
LABEL org.opencontainers.image.licenses="GPL-3.0-or-later"
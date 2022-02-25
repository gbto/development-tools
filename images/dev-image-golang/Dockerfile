FROM ghcr.io/gbto/base-image-debian:1.0.0
LABEL maintainer="Gbto, gibboneto@gmail.com"
LABEL org.opencontainers.image.source="https://github.com/gbto/tools"
LABEL version="1.0.0"

USER root

ARG GO_VERSION="1.17.7"
RUN echo ${GO_VERSION}
RUN curl -OL https://golang.org/dl/go${GO_VERSION}.linux-arm64.tar.gz \
    && mkdir /etc/golang \
    && tar -xvzf go${GO_VERSION}.linux-arm64.tar.gz -C /etc/golang \
    && ln -s /etc/golang/go/bin/go /usr/bin/go \
    && rm -f go${GO_VERSION}.linux-arm64.tar.gz

USER gibboneto

CMD ["zsh"]

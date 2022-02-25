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

RUN go install -v golang.org/x/tools/gopls@latest
RUN go install -v honnef.co/go/tools/cmd/staticcheck@latest
RUN go install -v github.com/haya14busa/goplay/cmd/goplay@latest
RUN go install -v github.com/josharian/impl@latest
RUN go install -v github.com/fatih/gomodifytags@latest
RUN go install -v github.com/cweill/gotests/gotests@latest
RUN go install -v github.com/ramya-rao-a/go-outline@latest
RUN go install -v github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest

USER gibboneto

CMD ["zsh"]

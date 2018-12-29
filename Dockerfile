FROM alpine:3.8
LABEL Maintainer="Nick Brassel <nick@tzarc.org>" \
      Description="Run a QEMU virtual machine inside a docker container."

RUN apk update \
    && apk --no-cache add bash qemu-system-x86_64 qemu-img ovmf tini

COPY ./start-machine /start-machine

ENTRYPOINT ["/sbin/tini", "--", "/start-machine"]

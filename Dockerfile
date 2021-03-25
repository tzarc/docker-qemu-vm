FROM alpine:latest
LABEL Maintainer="Nick Brassel <nick@tzarc.org>" \
      Description="Run a QEMU virtual machine inside a docker container."

RUN apk update \
    && apk --no-cache add bash qemu-system-x86_64 qemu-img ovmf runit curl python3 py3-numpy shadow

RUN addgroup runner \
    && adduser -h /home/runner -s /bin/bash -G runner -D runner \
    && echo 'qemu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && usermod -G qemu,kvm runner

RUN umask 022 \
    && mkdir -pm 755 /novnc-noVNC \
    && mkdir -pm 755 /novnc-websockify \
    && curl -L 'https://github.com/novnc/noVNC/archive/refs/heads/master.tar.gz' | tar -zxf - -C /novnc-noVNC --strip-components=1 \
    && curl -L 'https://github.com/novnc/websockify/archive/refs/heads/master.tar.gz' | tar -zxf - -C /novnc-websockify --strip-components=1

RUN mkdir -p /etc/service/qemu \
    && mkdir -p /etc/service/websockify

COPY ./files/entrypoint /entrypoint
COPY ./files/etc-service-qemu-run /etc/service/qemu/run
COPY ./files/etc-service-websockify-run /etc/service/websockify/run

RUN chmod 755 /entrypoint /etc/service/*/run

ENTRYPOINT ["/bin/bash","/entrypoint"]

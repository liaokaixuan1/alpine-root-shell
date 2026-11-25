FROM alpine:3.21

# root by default in container; add a real toolchain so the shell is actually usable
RUN apk add --no-cache \
      ttyd bash coreutils tzdata ca-certificates curl wget \
      shadow procps htop less vim nano git openssh-client \
      ncurses-terminfo \
 && rm -rf /var/cache/apk/*

ENV PORT=8080 \
    TZ=Asia/Shanghai \
    TTYD_USER=admin \
    HOME=/root \
    LANG=C.UTF-8 \
    TERM=xterm-256color

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh

EXPOSE 8080
CMD ["/entrypoint.sh"]
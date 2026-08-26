FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates openssh-server tini \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash tunnel \
    && random_password="$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 64)" \
    && printf 'tunnel:%s\n' "$random_password" | chpasswd \
    && unset random_password \
    && install -d -m 0700 -o tunnel -g tunnel /home/tunnel/.ssh \
    && install -d -m 0755 /run/sshd

COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod 0755 /usr/local/bin/entrypoint.sh

EXPOSE 2222

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]

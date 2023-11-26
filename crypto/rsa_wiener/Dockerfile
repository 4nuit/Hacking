FROM debian:latest

RUN apt-get update && apt-get install -y openssh-server
RUN useradd -m -s /bin/bash dockeruser

RUN mkdir /run/sshd
RUN mkdir /home/dockeruser/.ssh
RUN chown dockeruser:dockeruser /home/dockeruser/.ssh
COPY id_rsa.pub /home/dockeruser/.ssh/authorized_keys
RUN chown dockeruser:dockeruser /home/dockeruser/.ssh/authorized_keys

COPY flag.txt /home/dockeruser
RUN chmod 700 /home/dockeruser/.ssh && chmod 600 /home/dockeruser/.ssh/authorized_keys

RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
RUN echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

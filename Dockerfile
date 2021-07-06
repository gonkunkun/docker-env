# ubuntuオフィシャルOSメモリイメージ
FROM ubuntu:bionic

# パッケージの更新と依存パッケージのインストール
RUN apt update \
  && apt install -my gnupg \
  && apt install -y lsb-release software-properties-common \
  && apt install -y curl unzip python3.7 python3-pip

# Terraformのインストール
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
  && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
  && apt install -y terraform

# AWS CLIのインストール
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && /aws/install \
  && rm -rf awscliv2.zip /aws

# ecstlのインストール
RUN curl -Lo /usr/local/bin/ecscli "https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest" \
  && chmod +x /usr/local/bin/ecscli

# eksctlのインストール
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
  && mv /tmp/eksctl /usr/local/bin \
  && chmod +x /usr/local/bin/eksctl

# kubectlのインストール
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" \
  && mv /kubectl /usr/local/bin \
  && chmod +x /usr/local/bin/kubectl

# Ansibleのインストール
RUN apt-add-repository --yes --update ppa:ansible/ansible \
  && apt install -y ansible

# その他よく使うコマンドのインストール
RUN apt install -y less vim openssh-client iputils-ping net-tools dnsutils telnet rsync git tig
FROM amazonlinux:2023 AS builder
RUN dnf install -y \
    gcc \
    python3 \
    git \
    python3-pip \
    python3-devel \
    unzip && \
    dnf clean all && rm -rf /var/cache/dnf

RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir boto3 azure-cli==2.79.0

RUN git clone https://github.com/tfutils/tfenv.git /usr/local/tfenv

ENV TERRAFORM_VERSION="1.14.0"
RUN for version in $TERRAFORM_VERSION; do \
    /usr/local/tfenv/bin/tfenv install $version; \
  done

FROM amazonlinux:2023

RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo -o /etc/yum.repos.d/microsoft-prod.repo && \
    rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    dnf install -y \
        aws-cli \
        git \
        openssh-clients \
        python3 \
        jq \
        unzip \
        powershell \
        nodejs && \
    dnf clean all && rm -rf /var/cache/dnf

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY --from=builder /usr/local/tfenv /usr/local/tfenv
RUN ln -s /usr/local/tfenv/bin/* /usr/local/bin/ || true

ENV TERRAFORM_VERSION="1.14.0"

RUN groupadd -g 1000 user && \
    useradd -rm -d /home/user -s /bin/bash -g root -G sudo user && \
    echo "user:user" | chpasswd

USER user

COPY --chown=user src/run.sh /home/user/run.sh
RUN chmod +x /home/user/run.sh

ENTRYPOINT ["/home/user/run.sh"]
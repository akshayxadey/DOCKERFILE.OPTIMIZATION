FROM amazonlinux:2023-minimal AS builder
RUN yum install -y \
    gcc \
    python3 \
    git \
    python3-pip \
    python3-devel \
    unzip && \
    yum clean all

RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir boto3 azure-cli==2.79.0

RUN git clone https:github.com/tfutils/tfenv.git /usr/local/tfenv

ENV TERRAFORM_VERSION="1.14.0"
RUN for version in $TERRAFORM_VERSION; do \
    /usr/local/tfenv/bin/tfenv install $version;
done

FROM amazonlinux:2023-minimal
RUN yum install -y curl && yum clean all

RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo -o /etc/yum.repos.d/microsoft-prod.repo && \
    rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    yum install -y \
        aws-cli \
        git\
        openshh-clients \
        python3 \
        jq \
        unzip && \
        powershell \
        nodejs \
        unzip && \  
    yum clean all

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY --from=builder /usr/local/tfenv /usr/local/tfenv
RUN ln -s /usr/local/tfenv/bin/* /usr/local/bin/

ENV TERRAFORM_VERSION="1.14.0"
RUN DEFAULT_TERRAFORM_VERSION=$(echo $TERRAFORM_VERSION | awk '{print $1}') && \
    tfenv use $DEFAULT_TERRAFORM_VERSION

RUN groupadd -g 1000 user && \
    useradd -rm -d /home/user -s /bin/bash -g root -G sudo user && \
    echo "user:user" | chpasswd

USER user

COPY --chown=user:user src/run.sh /home/user/run.sh
RUN chmod +x /home/user/run.sh

ENTRYPOINT ["/home/user/run.sh"]
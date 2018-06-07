FROM k8s.gcr.io/debian-iptables-amd64:v10

ARG KUBE_VERSION

MAINTAINER Yusuke KUOKA <ykuoka@gmail.com>

RUN apt-get update && \
    apt-get install -y bash jq curl ca-certificates && \
    curl --fail -L https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64.deb -o dumb-init.deb && \
    dpkg -i dumb-init.deb && \
    rm dumb-init.deb && \
    curl --fail -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl && \
    apt-get remove -y curl && \
    rm -rf /var/lib/apt/lists/*

COPY rootfs /

RUN chmod +x /init

WORKDIR /

ENTRYPOINT [ "/init" ]

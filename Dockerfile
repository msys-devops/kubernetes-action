FROM alpine:3.20

ARG KUBECTL_VERSION="1.34.6"
ARG KUBECTL_DATE="2026-04-08"

RUN apk add --no-cache \
        curl \
        bash \
        aws-cli \
        py3-yaml \
 && curl -L -o /usr/bin/kubectl \
        https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/${KUBECTL_DATE}/bin/linux/amd64/kubectl \
 && chmod +x /usr/bin/kubectl

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
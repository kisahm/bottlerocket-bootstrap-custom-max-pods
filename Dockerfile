FROM alpine
RUN apk --update add curl bash jq
# Install aws-cli
RUN apk add --no-cache \
        python3 \
        py3-pip \
    && pip3 install --break-system-packages \
        awscli \
    && rm -rf /var/cache/apk/*
# Downloads the EKS helper script
COPY custom-max-pod-calculation.sh /usr/local/bin/max-pods-calculator.sh
RUN chmod +x /usr/local/bin/max-pods-calculator.sh
ADD bootstrap-script.sh ./
ADD imds /usr/local/bin/imds
RUN chmod +x ./bootstrap-script.sh && chmod +x /usr/local/bin/imds
ENTRYPOINT ["./bootstrap-script.sh"]
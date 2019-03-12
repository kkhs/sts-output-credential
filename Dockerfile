FROM mesosphere/aws-cli

RUN \
  apk --update add jq \
  && mkdir -p /workspace/.aws
ADD ./endpoint.sh /workspace/endpoint.sh
WORKDIR /workspace

ENTRYPOINT ["./endpoint.sh"]

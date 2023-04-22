FROM alpine

# Dependencies
RUN apk add --no-cache curl bash jq
RUN rm -rf /var/cache/apk/*

# Copy the script
COPY ./scripts/state/state-inspector.sh /usr/local/bin/state-inspector.sh
RUN chmod +x /usr/local/bin/state-inspector.sh

RUN mkdir -p /state
WORKDIR /state
VOLUME [ "/state" ]

ENTRYPOINT [ "/usr/local/bin/state-inspector.sh" ]
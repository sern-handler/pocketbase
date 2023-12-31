FROM alpine:latest AS download

ARG VERSION
ARG BUILDARCH

ADD https://github.com/pocketbase/pocketbase/releases/download/v${VERSION}/pocketbase_${VERSION}_linux_${BUILDARCH}.zip /pb.zip
RUN unzip /pb.zip && chmod +x /pocketbase

FROM alpine
RUN apk update && apk add --no-cache ca-certificates && rm -rf /var/cache/apk/*
COPY --from=download /pocketbase /bin/pocketbase

VOLUME /data
EXPOSE 8090

# https://www.baeldung.com/linux/difference-ip-address
ENTRYPOINT ["/bin/pocketbase", "serve", "--http=0.0.0.0:8090", "--dir=/data"]

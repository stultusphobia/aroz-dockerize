FROM golang:alpine as build
RUN apk add git build-base
RUN git clone https://github.com/tobychui/arozos.git /arozos
WORKDIR /arozos/src
RUN git fetch && git checkout v1.123
RUN make web
RUN go build -o './dist/arozos' -trimpath
WORKDIR /arozos/src/dist
RUN tar -xf ./web.tar.gz && rm web.tar.gz

FROM alpine
RUN apk --no-cache add util-linux ffmpeg su-exec
COPY --from=build /arozos/src/dist /app/
COPY entrypoint.sh /app
WORKDIR /app
ENTRYPOINT ["/bin/sh", "entrypoint.sh"]
CMD ["./arozos"]
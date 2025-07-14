FROM golang:1.23 AS builder

WORKDIR /app

RUN apt-get update \
    && apt-get install --no-install-suggests --no-install-recommends --yes ca-certificates wget

COPY go.mod .
COPY main.go .
RUN go mod download && go build -o dist/gcsproxy

FROM gcr.io/distroless/base
COPY --from=builder /app/dist/gcsproxy /gcsproxy
ENTRYPOINT ["/gcsproxy"]
CMD [ "-b", "0.0.0.0:80" ]

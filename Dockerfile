FROM debian:bullseye-slim AS build

WORKDIR /app

RUN apt-get update \
    && apt-get install --no-install-suggests --no-install-recommends --yes ca-certificates wget

COPY go.mod .
COPY main.go .
RUN go build -o dist/gcsproxy

FROM gcr.io/distroless/base
COPY --from=build /app/gcsproxy /gcsproxy
ENTRYPOINT ["/gcsproxy"]
CMD [ "-b", "0.0.0.0:80" ]

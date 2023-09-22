# Please pre build the img with - TARGET=x86_64-unknown-linux-musl make package
# Replace the target with one for the env
# then copy the build package and this Dockerfile to a the same dir to build
FROM ubuntu:latest AS builder

WORKDIR /vector

COPY vector-0.33.0.custom.a2b3032e8-x86_64-unknown-linux-musl.tar.gz ./
RUN tar -xvf vector-0.33.0.custom.a2b3032e8-x86_64-unknown-linux-musl.tar.gz --strip-components=2

RUN mkdir -p /var/lib/vector

FROM ubuntu:latest

RUN apt-get update && apt-get install -y ca-certificates tzdata && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /vector/bin/* /usr/local/bin/
COPY --from=builder /vector/config/vector.yaml /etc/vector/vector.yaml
COPY --from=builder /var/lib/vector /var/lib/vector

# Smoke test
RUN ["vector", "--version"]

ENTRYPOINT ["/usr/local/bin/vector"]
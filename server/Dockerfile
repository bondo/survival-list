# Use the official Rust image.
# https://hub.docker.com/_/rust
FROM rust:1.68.2-alpine3.17 as build

RUN apk add --no-cache musl-dev

RUN rustup component add clippy

ARG RUSTFLAGS="-Dwarnings"
ARG CARGO_REGISTRIES_CRATES_IO_PROTOCOL="sparse"

# Copy local code to the container image.
WORKDIR /usr/src/app
COPY . .

RUN cargo clippy --all-targets --all-features

# Install production dependencies and build a release artifact.
RUN cargo build --release

FROM alpine:3.17

WORKDIR /usr/local/bin
COPY --from=build /usr/src/app/target/release/server .

# Run the web service on container startup.
CMD ["server"]
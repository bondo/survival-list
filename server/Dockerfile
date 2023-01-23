# Use the official Rust image.
# https://hub.docker.com/_/rust
FROM rust:1.66.1 as build

# Copy local code to the container image.
WORKDIR /usr/src/app
COPY . .

# Install production dependencies and build a release artifact.
RUN cargo build --release

FROM rust:1.66.1

WORKDIR /usr/local/bin
COPY --from=build /usr/src/app/target/release/server .

# Run the web service on container startup.
CMD ["server"]
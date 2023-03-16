# Survival List Server

Server for the Survival List project.

## Update dependencies

- Install cargo-upgrades and cargo-edit: `cargo install -f cargo-upgrades cargo-edit`
- Run `cargo upgrade`

## Deploy

- Run `cargo sqlx prepare`
- Push to production branch (`git push origin main:production`)

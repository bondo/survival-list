# Survival List Server

Server for the Survival List project.

## Update dependencies

- Install cargo-upgrades and cargo-edit: `cargo install -f cargo-upgrades cargo-edit`
- Run `cargo upgrade`

## Add migration

`cargo sqlx migrate add <name>`

## Deploy

- Run `cargo sqlx prepare`
- Push to deploy-server branch (`git push origin main:deploy-server`)

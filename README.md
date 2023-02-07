# survival-list

## Deploy

- Run `cargo sqlx prepare`
- Push to production branch (`git push origin main:production`)

## Update client localization

- Run `flutter gen-l10n`

## Play with API

- Run `grpcui -plaintext localhost:8080` after `cargo serve`

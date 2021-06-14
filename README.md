# Identity Service

This service provides a centralised location to manage users and their access tokens. Authentication is performed through warden, it provides access tokens in the form of [JWT's](https://jwt.io) along with a refresh token that must be stored securely.

## Quickstart

```shell
cp .env.example .env
echo "JWT_PRIVATE_KEY=$(./bin/bootstrap)" >> .env
docker-compose up
```

## Authentication Strategies

### OTP
We currently only support challenge/response with an OTP sent to a users mobile phone

## OAuth Flow

ID supports the following `OAuth2` [grant types](https://oauth.net/2/grant-types/), 
* `authorization_code`
* `client_credentials`
* `password`
* `implicit`
* `refresh_token`

In future the `implicit` grant flow should be [dropped in favour of `authorization_code` with `PKCE`](https://developer.okta.com/blog/2019/08/22/okta-authjs-pkce/) and the `password` grant flow dropped entirely

For more information on how to implement the above flows please see the [OAuth](https://oauth.net/) website, or take a look at the [Bouncer](https://github.com/cat-home-experts/bouncer) middleware, but essentially the following happens:

1. User vists a site that's secured, 
2. Redirect them to ID
3. Prompted to authenticate
4. ID generates a token for that requesting application
5. Token can be used to validate identity on the other site

Access tokens are valid for two hours, after that you can either perform the above dance again, or use a refresh token to generate a new access token on behalf of a user. 

## Applications

Each application that needs to ask identity for credentials will need an `application_id` and `application_secret`. These can be created at `/oauth/applications`.

## JWT

Application tokens are encoded as Json Web Tokens, and are signed with a public/private keypair, to ensure that they can't be tampered with.

### Structure

Payload
```ruby
{
  sub: user.id
  aud: application.uid,
  exp: opts[:expires_in].seconds.from_now.to_i,
  iat: Time.now.to_i,
  iss: Rails.application.config.jwt.issuer
}
```
Header
```ruby
{
  kid: Rails.application.config.jwt.keyset.kid,
  alg: Rails.application.config.jwt.encryption_method
}
```

If you've made a request with the `client_credentials` flow, then the payload will be slightly different if you decode it.
```ruby
{
  sub: applicaiton.uid,
  aud: application.uid
  exp: opts[:expires_in].seconds.from_now.to_i,
  iat: Time.now.to_i,
  iss: Rails.application.config.jwt.issuer
}
```

### Json Web Keyset

Instead of diseminating the public keys to individual applications, applications can make use of the JWKS in order to ensure that the token is indeed verified

JWKS are served from `/.well-known/jwks.json`

## Testing

Identity has a spec suite that you can run

```
docker-compose run app rake spec
```

It also outputs a coverage file that you can see at `./coverage`

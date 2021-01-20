# Braintree GraphQL API Sinatra Example

## Setup Instructions

1. Install bundler:

    ```sh
    gem install bundler
    ```

2. Bundle:

    ```sh
    bundle
    ```

3. Copy the contents of `.env_example` into a new file named `.env` and fill in your Braintree API credentials. Credentials can be found by navigating to Account > My User > View Authorizations in the Braintree Control Panel. Full instructions can be [found on our support site](https://articles.braintreepayments.com/control-panel/important-gateway-credentials#api-credentials).

4. Run server:

    ```sh
    rackup
    ```

## Running Tests

```sh
rspec
```
Visit site: [localhost:9292](http://localhost:9292)

# Authex

This a Elixir Library implementation for Auth0 JWT Authentication. It brings plugs for Authentication, ResourceLoading and EnforcingAuthentication.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `authex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:authex, "~> 0.1.0"}]
    end
    ```

  2. Ensure `authex` is started before your application:

    ```elixir
    def application do
      [applications: [:authex]]
    end
    ```

## Usage

To use Authex simply plug the different implementations to your pipeline.

#### TokenAuth Plug

The TokenAuth Plug simply checks for a token in the connection and decodes it to get the subject data.

Example:

    ```elixir
    plug MyApp.PlugOne
    plug Authex.TokenAuth
    ```

#### LoadCurrentResource Plug

The LoadCurrentResource Plug loads the subject of the token authenticatedby the TokenAuth Plug and makes it available through the Authex.current_resource/1 method.

This module plug takes some required parameters and some options.

  Required:

  - Model: Refers to the model used for autheticantion. (often User model)
  - Repo: Refers to the Repo module used to interact with the Database

  Optional:

  - Field: Refers to the field used to fetch and load the current resource

Examples:

  ```elixir
   plug Authex.TokenAuth
   plug Authex.LoadCurrentResource, model: MyApp.User, repo: MyApp.Repo
  ```

  ```elixir
   plug Authex.TokenAuth
   plug Authex.LoadCurrentResource, model: MyApp.User, repo: MyApp.Repo, field: :email
  ```

#### EnforceAuthentication Plug

The Enforce Authentication plug requires an error handler module implementing an :authentication_error/1
that takes a Plug connection. This module will be used by the EnforceAuthentication plug when it encounters
an authentication error. This module plug is designed to be used in controllers.

Examples:

  ```elixir
   plug Authex.LoadCurrentResource, handler: __MODULE__

   def authentication_error(conn) do
    conn
    |> put_status(401)
    |> render("error.json", message: "authentication error")
   end
  ```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/authex/fork )
2. Create your feature branch (`git checkout -b feature/my_new_feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Special Thanks To:

1. All the contributors to the Elixir Library Guardian

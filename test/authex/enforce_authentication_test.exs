defmodule Authex.EnforceAuthenticationTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Authex.TokenAuth
  alias Authex.LoadCurrentResource
  alias Authex.EnforceAuthentication

  setup do
    Application.put_env(:authex, :auth_id, TestHelpers.audience)
    Application.put_env(:authex, :auth_secret, Base.url_encode64(TestHelpers.secret))

    valid_conn = conn(:get, "/test")
                  |> put_req_header("authorization", TestHelpers.token)
                  |> TokenAuth.call(%{})
                  |> LoadCurrentResource.call(model: User, repo: Repo)

    invalid_conn = conn(:get, "/test")
    {:ok, valid: valid_conn, invalid: invalid_conn}
  end


  test "with valid token", %{valid: valid} do
    conn = valid |> EnforceAuthentication.call(handler: AuthenticationError)
    refute conn.assigns[:failed]
  end

  test "with invalid token", %{invalid: invalid} do
    conn = invalid |> EnforceAuthentication.call(handler: AuthenticationError)
    assert conn.assigns[:failed]
  end
end

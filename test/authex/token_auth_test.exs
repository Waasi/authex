defmodule Authex.TokenAuthTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Authex.TokenAuth

  setup do
    Application.put_env(:authex, :auth_id, TestHelpers.audience)
    Application.put_env(:authex, :auth_secret, Base.url_encode64(TestHelpers.secret))

    valid_conn = conn(:get, "/test") |> put_req_header("authorization", TestHelpers.token)
    invalid_conn = conn(:get, "/test")

    {:ok, valid: valid_conn, invalid: invalid_conn}
  end


  test "with valid token", %{valid: valid} do
    conn = valid |> TokenAuth.call(%{})
    assert conn.assigns[:token] != nil
  end

  test "with invalid token", %{invalid: invalid} do
    conn = invalid |> TokenAuth.call(%{})
    assert conn.assigns[:token] == nil
  end
end

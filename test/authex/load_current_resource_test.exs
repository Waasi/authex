defmodule Authex.LoadCurrentResourceTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Authex.TokenAuth
  alias Authex.LoadCurrentResource

  setup do
    Application.put_env(:authex, :auth_id, TestHelpers.audience)
    Application.put_env(:authex, :auth_secret, Base.url_encode64(TestHelpers.secret))

    valid_conn = conn(:get, "/test") |> put_req_header("authorization", TestHelpers.token) |> TokenAuth.call(%{})
    invalid_conn = conn(:get, "/test")

    {:ok, valid: valid_conn, invalid: invalid_conn}
  end


  test "with valid token", %{valid: valid} do
    conn = valid |> LoadCurrentResource.call(model: User, repo: Repo)
    assert conn.assigns[:current_resource] == Repo.get(User, 1)
  end

  test "with invalid token", %{invalid: invalid} do
    conn = invalid |> LoadCurrentResource.call(model: User, repo: Repo)
    assert conn.assigns[:current_resource] == nil
  end
end

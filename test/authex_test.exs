defmodule AuthexTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Authex.TokenAuth
  alias Authex.LoadCurrentResource

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

  test "current_resource with valid authentication", %{valid: valid} do
    assert Authex.current_resource(valid) == Repo.get(User, 1)
  end

  test "current_resource with invalid authentication", %{invalid: invalid} do
    refute Authex.current_resource(invalid) == Repo.get(User, 1)
  end
end

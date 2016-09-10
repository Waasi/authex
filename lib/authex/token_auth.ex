defmodule Authex.TokenAuth do
  import Plug.Conn

  def init(_), do: :ok

  def call(conn, _opts) do
    case conn |> get_req_header("authorization") do
      ["Bearer " <> token] -> token |> claims(conn)
      _invalid -> conn
    end
  end

  defp claims(token, conn) do
    case decode(token, salt) do
      {:ok, token} -> verify_audience(conn, token)
      {:error, _msg} -> conn
    end
  end

  defp decode(token, {:ok, salt}) do
    JsonWebToken.verify(token, %{key: salt})
  end

  defp verify_audience(conn, token) do
    if token[:aud] == Application.get_env(:authex, :auth_id) do
      assign(conn, :token, token)
    else
      conn
    end
  end

  defp salt do
    Application.get_env(:authex, :auth_secret)
    |> Base.url_decode64
  end
end

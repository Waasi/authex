defmodule Authex.EnforceAuthentication do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    if conn.assigns[:token], do: conn, else: error(conn, opts)
  end

  defp error(conn, [handler: handler]) do
    conn |> handler.authentication_error
  end
end

defmodule Authex.LoadCurrentResource do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    case conn.assigns[:token] do
      nil -> conn
      _token -> update(conn, opts)
    end
  end

  defp resource(value, opts) do
    case opts do
      [model: module, repo: repo] ->
        repo.get(module, value)
      [model: module, repo: repo, field: field] ->
        repo.get_by(module, %{field => value})
      _ ->
        nil
    end
  end

  defp field_value(conn, atom \\ :sub) do
    conn.assigns[:token][atom]
  end

  defp update(conn, opts) do
    case opts do
      [_, _, field: field] ->
        key = field_value(conn, field)
        assign(conn, :current_resource, resource(key, opts))
      _ ->
        key = field_value(conn)
        assign(conn, :current_resource, resource(key, opts))
    end
  end
end

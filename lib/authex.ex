defmodule Authex do
  def current_resource(conn) do
    conn.assigns[:current_resource]
  end
end

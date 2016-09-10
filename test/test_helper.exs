ExUnit.start()

defmodule TestHelpers do
  def token do
   "Bearer " <> JsonWebToken.sign(%{sub: 1, email: "test@test.com", aud: audience}, %{key: secret})
  end

  def secret do
    "lhdakjfhblKEFJBQNWLEFHj,hbdaljdblakbjdli"
  end

  def audience do
    "lskjdhfsldfkjhjhmdakjh"
  end
end

defmodule User do
  defstruct id: nil, email: nil
end

defmodule Repo do
  def get(User, 1) do
    %User{id: 1, email: "test@test.com"}
  end
end

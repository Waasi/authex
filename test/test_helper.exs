ExUnit.start()

defmodule TestHelpers do
  def token do
   "Bearer " <> JsonWebToken.sign(%{sup: "1", email: "test@test.com", aud: audience}, %{key: secret})
  end

  def secret do
    "lhdakjfhblKEFJBQNWLEFHj,hbdaljdblakbjdli"
  end

  def audience do
    "lskjdhfsldfkjhjhmdakjh"
  end
end

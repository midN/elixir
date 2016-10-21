defmodule Stockman.Factory do
  use ExMachina.Ecto, repo: Stockman.Repo

  def user_factory do
    %Stockman.User{
      email: "test@test.ee",
      password: "password123", password_confirmation: "password123",
      password_hash: "$2b$12$3PnpKYiDWoqzFT9nLc4N1eXpOp.fGihiyllmD6WhjwWj.awB.sdle"
    }
  end
end

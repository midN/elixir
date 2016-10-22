defmodule Stockman.Factory do
  use ExMachina.Ecto, repo: Stockman.Repo

  def user_factory do
    %Stockman.User{
      email: "test@test.ee",
      password: "password123", password_confirmation: "password123",
      password_hash: "$2b$12$3PnpKYiDWoqzFT9nLc4N1eXpOp.fGihiyllmD6WhjwWj.awB.sdle"
    }
  end

  def convert_factory do
    %Stockman.Convert{
      amount: Decimal.new("120.5"), base_currency: "EUR",
      target_currency: "USD", waiting_time: 42
    }
  end

  def rate_factory do
    %Stockman.Rate{
      rate: Decimal.new("120.5"),
      date: Ecto.Date.cast!(%{day: 17, month: 4, year: 2010})
    }
  end
end

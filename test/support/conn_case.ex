defmodule Stockman.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Stockman.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Stockman.Router.Helpers
      import Stockman.Factory

      # The default endpoint for testing
      @endpoint Stockman.Endpoint

      @doc """
      Helper for setting up a `conn` which logs in a user
      """
      def guardian_login(user, token \\ :token, opts \\ []) do
        build_conn
        |> bypass_through(Stockman.Router, [:browser])
        |> get("/")
        |> Guardian.Plug.sign_in(user, token, opts)
        |> send_resp(200, "Flush the session")
        |> recycle
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Stockman.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Stockman.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end

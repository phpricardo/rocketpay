defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Rick",
        password: "123456",
        nickname: "Lima",
        email: "rick@gmail.com",
        age: 33
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic cmljYXJkbzoxMjM0NTY=")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "10.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)
        
      assert %{
                "account" => %{"balance" => "10.00", "id" => _id}, 
                "message" => "Ballance chaged successfully"
              } = response
    end

    test "when there are invalid params, return error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)
        
      expected_response = %{"message" => "Invalid deposit value!"}

      assert response == expected_response
    end

  end
end
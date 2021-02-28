defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = %{
        name: "Rick",
        password: "123456",
        nickname: "Lima",
        email: "rick@gmail.com",
        age: 33
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{name: "Rick", age: 33, id: ^user_id} = user
    end

    test "when there are invalid params, returns an user" do
      params = %{
        name: "Rick",
        nickname: "Lima",
        email: "rick@gmail.com",
        age: 15
      }

      expected_response = %{age: ["must be greater than or equal to 18"], password: ["can't be blank"]}

      {:error, changeset} = Create.call(params)

      assert errors_on(changeset) == expected_response
    end
  end
end
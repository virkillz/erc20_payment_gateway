defmodule IdkPayWeb.TransactionControllerTest do
  use IdkPayWeb.ConnCase

  alias IdkPay.Ethereum

  @create_attrs %{block: "some block", block_int: 42, contract: "some contract", erc20_value: 42, eth_value: 42, from: "some from", gas: "some gas", gas_price: "some gas_price", hash: "some hash", input: "some input", network: "some network", to: "some to", token: "some token", type: "some type"}
  @update_attrs %{block: "some updated block", block_int: 43, contract: "some updated contract", erc20_value: 43, eth_value: 43, from: "some updated from", gas: "some updated gas", gas_price: "some updated gas_price", hash: "some updated hash", input: "some updated input", network: "some updated network", to: "some updated to", token: "some updated token", type: "some updated type"}
  @invalid_attrs %{block: nil, block_int: nil, contract: nil, erc20_value: nil, eth_value: nil, from: nil, gas: nil, gas_price: nil, hash: nil, input: nil, network: nil, to: nil, token: nil, type: nil}

  def fixture(:transaction) do
    {:ok, transaction} = Ethereum.create_transaction(@create_attrs)
    transaction
  end

  describe "index" do
    test "lists all transactions", %{conn: conn} do
      conn = get conn, transaction_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Transactions"
    end
  end

  describe "new transaction" do
    test "renders form", %{conn: conn} do
      conn = get conn, transaction_path(conn, :new)
      assert html_response(conn, 200) =~ "New Transaction"
    end
  end

  describe "create transaction" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, transaction_path(conn, :create), transaction: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == transaction_path(conn, :show, id)

      conn = get conn, transaction_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Transaction"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, transaction_path(conn, :create), transaction: @invalid_attrs
      assert html_response(conn, 200) =~ "New Transaction"
    end
  end

  describe "edit transaction" do
    setup [:create_transaction]

    test "renders form for editing chosen transaction", %{conn: conn, transaction: transaction} do
      conn = get conn, transaction_path(conn, :edit, transaction)
      assert html_response(conn, 200) =~ "Edit Transaction"
    end
  end

  describe "update transaction" do
    setup [:create_transaction]

    test "redirects when data is valid", %{conn: conn, transaction: transaction} do
      conn = put conn, transaction_path(conn, :update, transaction), transaction: @update_attrs
      assert redirected_to(conn) == transaction_path(conn, :show, transaction)

      conn = get conn, transaction_path(conn, :show, transaction)
      assert html_response(conn, 200) =~ "some updated block"
    end

    test "renders errors when data is invalid", %{conn: conn, transaction: transaction} do
      conn = put conn, transaction_path(conn, :update, transaction), transaction: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Transaction"
    end
  end

  describe "delete transaction" do
    setup [:create_transaction]

    test "deletes chosen transaction", %{conn: conn, transaction: transaction} do
      conn = delete conn, transaction_path(conn, :delete, transaction)
      assert redirected_to(conn) == transaction_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, transaction_path(conn, :show, transaction)
      end
    end
  end

  defp create_transaction(_) do
    transaction = fixture(:transaction)
    {:ok, transaction: transaction}
  end
end

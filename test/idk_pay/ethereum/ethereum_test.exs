defmodule IdkPay.EthereumTest do
  use IdkPay.DataCase

  alias IdkPay.Ethereum

  describe "addresses" do
    alias IdkPay.Ethereum.Address

    @valid_attrs %{addr: "some addr", remark: "some remark"}
    @update_attrs %{addr: "some updated addr", remark: "some updated remark"}
    @invalid_attrs %{addr: nil, remark: nil}

    def address_fixture(attrs \\ %{}) do
      {:ok, address} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Ethereum.create_address()

      address
    end

    test "list_addresses/0 returns all addresses" do
      address = address_fixture()
      assert Ethereum.list_addresses() == [address]
    end

    test "get_address!/1 returns the address with given id" do
      address = address_fixture()
      assert Ethereum.get_address!(address.id) == address
    end

    test "create_address/1 with valid data creates a address" do
      assert {:ok, %Address{} = address} = Ethereum.create_address(@valid_attrs)
      assert address.addr == "some addr"
      assert address.remark == "some remark"
    end

    test "create_address/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ethereum.create_address(@invalid_attrs)
    end

    test "update_address/2 with valid data updates the address" do
      address = address_fixture()
      assert {:ok, address} = Ethereum.update_address(address, @update_attrs)
      assert %Address{} = address
      assert address.addr == "some updated addr"
      assert address.remark == "some updated remark"
    end

    test "update_address/2 with invalid data returns error changeset" do
      address = address_fixture()
      assert {:error, %Ecto.Changeset{}} = Ethereum.update_address(address, @invalid_attrs)
      assert address == Ethereum.get_address!(address.id)
    end

    test "delete_address/1 deletes the address" do
      address = address_fixture()
      assert {:ok, %Address{}} = Ethereum.delete_address(address)
      assert_raise Ecto.NoResultsError, fn -> Ethereum.get_address!(address.id) end
    end

    test "change_address/1 returns a address changeset" do
      address = address_fixture()
      assert %Ecto.Changeset{} = Ethereum.change_address(address)
    end
  end

  describe "transactions" do
    alias IdkPay.Ethereum.Transaction

    @valid_attrs %{block: "some block", block_int: 42, contract: "some contract", erc20_value: 42, eth_value: 42, from: "some from", gas: "some gas", gas_price: "some gas_price", hash: "some hash", input: "some input", network: "some network", to: "some to", token: "some token", type: "some type"}
    @update_attrs %{block: "some updated block", block_int: 43, contract: "some updated contract", erc20_value: 43, eth_value: 43, from: "some updated from", gas: "some updated gas", gas_price: "some updated gas_price", hash: "some updated hash", input: "some updated input", network: "some updated network", to: "some updated to", token: "some updated token", type: "some updated type"}
    @invalid_attrs %{block: nil, block_int: nil, contract: nil, erc20_value: nil, eth_value: nil, from: nil, gas: nil, gas_price: nil, hash: nil, input: nil, network: nil, to: nil, token: nil, type: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Ethereum.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Ethereum.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Ethereum.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Ethereum.create_transaction(@valid_attrs)
      assert transaction.block == "some block"
      assert transaction.block_int == 42
      assert transaction.contract == "some contract"
      assert transaction.erc20_value == 42
      assert transaction.eth_value == 42
      assert transaction.from == "some from"
      assert transaction.gas == "some gas"
      assert transaction.gas_price == "some gas_price"
      assert transaction.hash == "some hash"
      assert transaction.input == "some input"
      assert transaction.network == "some network"
      assert transaction.to == "some to"
      assert transaction.token == "some token"
      assert transaction.type == "some type"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ethereum.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, transaction} = Ethereum.update_transaction(transaction, @update_attrs)
      assert %Transaction{} = transaction
      assert transaction.block == "some updated block"
      assert transaction.block_int == 43
      assert transaction.contract == "some updated contract"
      assert transaction.erc20_value == 43
      assert transaction.eth_value == 43
      assert transaction.from == "some updated from"
      assert transaction.gas == "some updated gas"
      assert transaction.gas_price == "some updated gas_price"
      assert transaction.hash == "some updated hash"
      assert transaction.input == "some updated input"
      assert transaction.network == "some updated network"
      assert transaction.to == "some updated to"
      assert transaction.token == "some updated token"
      assert transaction.type == "some updated type"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Ethereum.update_transaction(transaction, @invalid_attrs)
      assert transaction == Ethereum.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Ethereum.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Ethereum.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Ethereum.change_transaction(transaction)
    end
  end
end

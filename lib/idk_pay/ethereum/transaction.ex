defmodule IdkPay.Ethereum.Transaction do
  use Ecto.Schema
  import Ecto.Changeset


  schema "transactions" do
    field :block, :string
    field :block_int, :integer
    field :contract, :string
    field :erc20_value, :integer
    field :eth_value, :integer
    field :from, :string
    field :gas, :string
    field :gas_price, :string
    field :hash, :string
    field :input, :string
    field :network, :string
    field :to, :string
    field :token, :string
    field :type, :string
    field :address_id, :id

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:block_int, :network, :token, :contract, :hash, :from, :to, :block, :input, :erc20_value, :eth_value, :gas, :gas_price, :type])
    |> validate_required([:block_int, :network, :token, :contract, :hash, :from, :to, :block, :input, :erc20_value, :eth_value, :gas, :gas_price, :type])
  end
end

defmodule IdkPay.Ethereum.Address do
  use Ecto.Schema
  import Ecto.Changeset


  schema "addresses" do
    field :addr, :string
    field :remark, :string
    field :user_id, :id
    field :invoice_id, :id

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:addr, :remark])
    |> validate_required([:addr, :remark])
  end
end

defmodule IdkPay.Ethereum.Address do
  use Ecto.Schema
  import Ecto.Changeset

  schema "addresses" do
    field(:addr, :string)
    field(:remark, :string)
    field(:invoice_id, :id)
    field(:is_used, :boolean, default: false)
    field(:network, :string)
    field(:privkey, :string)

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:addr, :remark, :network, :privkey, :is_used, :invoice_id])
    |> validate_required([:addr])
  end
end

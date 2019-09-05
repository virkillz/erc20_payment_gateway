defmodule IdkPay.Transaction.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invoices" do
    field(:amount, :integer)
    field(:invoice_status, :string)
    field(:payment_status, :string)
    field(:purpose, :string)
    field(:token, :string)
    field(:user_id, :id)
    field(:eth_address, :string)
    field(:is_settled, :boolean)
    field(:settlement_fee, :integer)
    field(:settlement_nett, :integer)
    field(:expiry, :string)
    field(:expiry_date, :naive_datetime)
    field(:success_redirect, :string)

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [
      :token,
      :amount,
      :payment_status,
      :invoice_status,
      :expiry_date,
      :expiry,
      :eth_address,
      :is_settled,
      :purpose
    ])
    |> validate_required([
      :token,
      :amount,
      :payment_status,
      :invoice_status,
      :expiry_date,
      :purpose
    ])
  end
end

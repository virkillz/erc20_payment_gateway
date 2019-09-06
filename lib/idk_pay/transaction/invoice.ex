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
      :purpose,
      :user_id
    ])
    |> validate_required([
      :token,
      :amount,
      :payment_status,
      :invoice_status,
      :expiry_date,
      :purpose
    ])
    |> add_code
  end

  def add_code(changeset) do
    change(changeset, %{
      token: :crypto.strong_rand_bytes(18) |> Base.url_encode64() |> binary_part(0, 18)
    })
  end
end

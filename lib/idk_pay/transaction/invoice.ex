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
    field(:inv_id, :string)
    field(:request_id, :string)

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
      :user_id,
      :inv_id,
      :request_id
    ])
    |> validate_required([
      :amount,
      :payment_status,
      :invoice_status,
      :request_id,
      :expiry_date,
      :purpose
    ])
    |> unique_constraint(:request_id, name: :invoices_request_id_user_id_index)
    |> add_code
  end

  def add_code(changeset) do
    if is_nil(get_field(changeset, :inv_id)) do
      change(changeset, %{
        inv_id: :crypto.strong_rand_bytes(18) |> Base.url_encode64() |> binary_part(0, 18)
      })
    else
      changeset
    end
  end
end

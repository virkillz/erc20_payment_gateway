defmodule IdkPay.Transaction.Invoice do
  use Ecto.Schema
  import Ecto.Changeset


  schema "invoices" do
    field :amount, :integer
    field :expiry_date, :date
    field :fee, :integer
    field :invoice_status, :string
    field :payment_status, :string
    field :purpose, :string
    field :token, :string
    field :total, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:token, :amount, :fee, :total, :payment_status, :invoice_status, :expiry_date, :purpose])
    |> validate_required([:token, :amount, :fee, :total, :payment_status, :invoice_status, :expiry_date, :purpose])
  end
end

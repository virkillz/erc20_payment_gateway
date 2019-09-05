defmodule IdkPay.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add(:token, :string)
      add(:amount, :bigserial)
      add(:payment_status, :string)
      add(:invoice_status, :string)
      add(:eth_address, :string)
      add(:is_settled, :boolean)
      add(:settlement_fee, :bigserial)
      add(:settlement_nett, :bigserial)
      add(:expiry, :string)
      add(:expiry_date, :naive_datetime)
      add(:success_redirect, :string)
      add(:purpose, :text)
      add(:user_id, references(:user, on_delete: :nothing))

      timestamps()
    end

    create(index(:invoices, [:user_id]))
  end
end

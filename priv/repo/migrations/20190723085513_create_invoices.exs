defmodule IdkPay.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add :token, :string
      add :amount, :integer
      add :fee, :integer
      add :total, :integer
      add :payment_status, :string
      add :invoice_status, :string
      add :expiry_date, :date
      add :purpose, :text
      add :user_id, references(:user, on_delete: :nothing)

      timestamps()
    end

    create index(:invoices, [:user_id])
  end
end

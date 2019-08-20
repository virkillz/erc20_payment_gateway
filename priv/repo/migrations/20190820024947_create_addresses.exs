defmodule IdkPay.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :addr, :string
      add :remark, :text
      add :user_id, references(:user, on_delete: :nilify_all)
      add :invoice_id, references(:invoices, on_delete: :nilify_all)

      timestamps()
    end

    create index(:addresses, [:user_id])
    create index(:addresses, [:invoice_id])
  end
end

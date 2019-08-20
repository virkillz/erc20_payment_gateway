defmodule IdkPay.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :block_int, :integer
      add :network, :string
      add :token, :string
      add :contract, :string
      add :hash, :string
      add :from, :string
      add :to, :string
      add :block, :string
      add :input, :string
      add :erc20_value, :integer
      add :eth_value, :integer
      add :gas, :string
      add :gas_price, :string
      add :type, :string
      add :address_id, references(:addresses, on_delete: :nilify_all)

      timestamps()
    end

    create index(:transactions, [:address_id])
  end
end

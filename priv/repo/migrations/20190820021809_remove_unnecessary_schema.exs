defmodule IdkPay.Repo.Migrations.RemoveUnnecessarySchema do
  use Ecto.Migration

  def change do
    alter table(:user) do
      remove :merchant_key
      remove :eth_address
         
    end
  end
end

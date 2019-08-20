defmodule IdkPay.Repo.Migrations.TurnUserIntoMerchant do
  use Ecto.Migration

  def change do
    alter table(:user) do
      add :eth_address, :string
      add :gas, :string
      add :merchant_key, :string
      add :logo, :string
      add :website, :string
      add :webhook_url, :string                  

    end
  end
end

defmodule IdkPay.Repo.Migrations.AddMoreMetadataIntoUser do
  use Ecto.Migration

  def change do
    alter table(:user) do
      add :recovery_code, :string
      add :merchant_name, :string 
      add :mainnet_eth_address, :string 
      add :testnet_eth_address, :string 
      add :mainnet_key, :string 
      add :mainnet_secret, :string 
      add :testnet_key, :string
      add :testnet_secret, :string 
      add :mainnet_webhook, :string 
      add :testnet_webhook, :string 
      add :mainnet_default_success_url, :string 
      add :testnet_default_success_url, :string 
      add :mainnet_default_error_url, :string 
      add :testnet_default_error_url, :string       

    end
  end
end

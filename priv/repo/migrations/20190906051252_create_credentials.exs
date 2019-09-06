defmodule IdkPay.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add :eth_address, :string
      add :webhook_url, :string
      add :success_url_redirect, :string
      add :public_key, :string
      add :secret_key, :string
      add :network, :string
      add :is_deleted, :boolean, default: false, null: false
      add :user_id, references(:user, on_delete: :nothing)

      timestamps()
    end

    create index(:credentials, [:user_id])
  end
end

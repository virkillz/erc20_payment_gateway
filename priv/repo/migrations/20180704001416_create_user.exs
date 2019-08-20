defmodule IdkPay.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :fullname, :string
      add :username, :string
      add :password_hash, :string
      add :avatar, :string
      add :role, :string
      add :is_active, :boolean, default: true, null: false
      add :bio, :string
      add :email, :string
      add :mobile, :string
      add :location, :string
      add :verification_code, :string  
      add :is_verified, :boolean, default: false, null: false          

      timestamps()
    end

  end
end

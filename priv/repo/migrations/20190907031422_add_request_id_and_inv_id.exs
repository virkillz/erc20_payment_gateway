defmodule IdkPay.Repo.Migrations.AddRequestIdAndInvId do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      add(:request_id, :string)
      add(:inv_id, :string)
    end

    create(unique_index(:invoices, [:request_id, :user_id]))
  end
end

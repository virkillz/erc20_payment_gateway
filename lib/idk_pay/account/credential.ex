defmodule IdkPay.Account.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  schema "credentials" do
    field(:eth_address, :string)
    field(:is_deleted, :boolean, default: false)
    field(:network, :string)
    field(:public_key, :string)
    field(:secret_key, :string)
    field(:success_url_redirect, :string)
    field(:webhook_url, :string)
    field(:user_id, :id)

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [
      :eth_address,
      :webhook_url,
      :user_id,
      :success_url_redirect,
      :public_key,
      :secret_key,
      :network,
      :is_deleted
    ])
    |> validate_required([:eth_address, :webhook_url, :success_url_redirect, :network])
  end
end

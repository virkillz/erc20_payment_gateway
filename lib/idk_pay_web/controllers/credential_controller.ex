defmodule IdkPayWeb.CredentialController do
  use IdkPayWeb, :controller

  alias IdkPay.Account
  alias IdkPay.Account.Credential

  def index(conn, _params) do
    credentials = Account.list_credentials()
    render(conn, "index.html", credentials: credentials)
  end

  def new(conn, _params) do
    changeset = Account.change_credential(%Credential{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"credential" => credential_params}) do
    case Account.create_credential(credential_params) do
      {:ok, credential} ->
        conn
        |> put_flash(:info, "Credential created successfully.")
        |> redirect(to: credential_path(conn, :show, credential))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    credential = Account.get_credential!(id)
    render(conn, "show.html", credential: credential)
  end

  def edit(conn, %{"id" => id}) do
    credential = Account.get_credential!(id)
    changeset = Account.change_credential(credential)
    render(conn, "edit.html", credential: credential, changeset: changeset)
  end

  def update(conn, %{"id" => id, "credential" => credential_params}) do
    credential = Account.get_credential!(id)

    case Account.update_credential(credential, credential_params) do
      {:ok, credential} ->
        conn
        |> put_flash(:info, "Credential updated successfully.")
        |> redirect(to: credential_path(conn, :show, credential))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", credential: credential, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    credential = Account.get_credential!(id)
    {:ok, _credential} = Account.delete_credential(credential)

    conn
    |> put_flash(:info, "Credential deleted successfully.")
    |> redirect(to: credential_path(conn, :index))
  end
end

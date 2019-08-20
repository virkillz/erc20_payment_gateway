defmodule IdkPayWeb.AddressController do
  use IdkPayWeb, :controller

  alias IdkPay.Ethereum
  alias IdkPay.Ethereum.Address

  def index(conn, _params) do
    addresses = Ethereum.list_addresses()
    render(conn, "index.html", addresses: addresses)
  end

  def new(conn, _params) do
    changeset = Ethereum.change_address(%Address{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"address" => address_params}) do
    case Ethereum.create_address(address_params) do
      {:ok, address} ->
        conn
        |> put_flash(:info, "Address created successfully.")
        |> redirect(to: address_path(conn, :show, address))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    address = Ethereum.get_address!(id)
    render(conn, "show.html", address: address)
  end

  def edit(conn, %{"id" => id}) do
    address = Ethereum.get_address!(id)
    changeset = Ethereum.change_address(address)
    render(conn, "edit.html", address: address, changeset: changeset)
  end

  def update(conn, %{"id" => id, "address" => address_params}) do
    address = Ethereum.get_address!(id)

    case Ethereum.update_address(address, address_params) do
      {:ok, address} ->
        conn
        |> put_flash(:info, "Address updated successfully.")
        |> redirect(to: address_path(conn, :show, address))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", address: address, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    address = Ethereum.get_address!(id)
    {:ok, _address} = Ethereum.delete_address(address)

    conn
    |> put_flash(:info, "Address deleted successfully.")
    |> redirect(to: address_path(conn, :index))
  end
end

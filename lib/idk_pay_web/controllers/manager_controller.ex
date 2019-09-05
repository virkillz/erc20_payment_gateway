defmodule IdkPayWeb.ManagerController do
  use IdkPayWeb, :controller

  alias IdkPay.Logging
  alias IdkPay.Account
  alias IdkPay.Account.User
  alias IdkPay.Auth.Guardian

  def index(conn, _params) do
    manager = Account.list_administrator()
    render(conn, "index.html", manager: manager)
  end

  def new(conn, _params) do
    changeset = Account.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => admin_params}) do
    case Account.create_admin(admin_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    manager = Account.get_user!(id)
    render(conn, "show.html", manager: manager)
  end

  def edit(conn, %{"id" => id}) do
    manager = Account.get_user!(id)
    changeset = Account.change_user(manager)
    render(conn, "edit.html", manager: manager, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    case Account.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Admin info updated successfully.")
        |> redirect(to: manager_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  # Still working on this

  def updateprofile(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    filename =
      if upload = user_params["avatar"] do
        extension = Path.extname(upload.filename)
        randomname = Ecto.UUID.generate() |> binary_part(16, 16)
        filenamez = "/images/#{randomname}-profile#{extension}"
        File.cp(upload.path, "assets/static#{filenamez}")
        filenamez
      else
        "/images/default.png"
      end

    addpicture = Map.put(user_params, "avatar", filename)

    case Account.update_user(user, addpicture) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    {:ok, _user} = Account.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end

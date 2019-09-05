defmodule IdkPayWeb.UserController do
  use IdkPayWeb, :controller

  alias IdkPay.Logging
  alias IdkPay.Account
  alias IdkPay.Account.User
  alias IdkPay.Auth.Guardian

  def index(conn, _params) do
    user = Account.list_user_only()
    render(conn, "index.html", user: user)
  end

  def new(conn, _params) do
    changeset = Account.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
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

    case Account.create_user(addpicture) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    changeset = Account.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
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

  def login(conn, _params) do
    changeset = Account.change_user(%User{})

    render(conn, "login.html", layout: {IdkPayWeb.LayoutView, "center.html"}, changeset: changeset)
  end

  def auth(conn, %{"username" => user, "password" => password}) do
    [browser] = Plug.Conn.get_req_header(conn, "user-agent")

    case Account.authenticate_user(user, password) do
      {:ok, user} ->
        if user.role != "administrator" do
          changeset = Account.change_user(%User{})

          conn
          |> put_flash(:error, "You are not belong back here")
          |> render("login.html",
            layout: {IdkPayWeb.LayoutView, "center.html"},
            changeset: changeset
          )
        else
          Logging.create_activity(%{
            "user_id" => user.id,
            "activity" => "User sign in from #{browser}"
          })

          conn
          |> Guardian.login(user)
          |> put_flash(:info, "Welcome back, #{user.fullname}! You look so damn handsome today.")
          |> redirect(to: user_path(conn, :dashboard))
        end

      {:error, reason} ->
        changeset = Account.change_user(%User{})

        conn
        |> put_flash(:error, reason)
        |> render("login.html",
          layout: {IdkPayWeb.LayoutView, "center.html"},
          changeset: changeset
        )
    end
  end

  def logout(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    Logging.create_activity(%{"user_id" => user.id, "activity" => "User sign out."})

    conn
    |> Guardian.logout()
    |> redirect(to: user_path(conn, :login))
  end

  def locked(conn, _) do
    changeset = Account.change_user(%User{})
    avatar = conn.private.guardian_default_resource.avatar
    username = conn.private.guardian_default_resource.username
    name = conn.private.guardian_default_resource.fullname

    conn
    |> Guardian.logout()
    |> render("locked.html",
      layout: {IdkPayWeb.LayoutView, "center.html"},
      name: name,
      avatar: avatar,
      username: username,
      changeset: changeset
    )
  end

  def dashboard(conn, _) do
    render(conn, "dashboard.html")
  end

  def profile(conn, _) do
    id = conn.private.guardian_default_resource.id
    user = Account.get_user!(id)
    changeset = Account.change_user(user)
    histories = Logging.get_last_x_activity(20, user.id)

    history =
      histories
      |> Enum.map(fn x -> Map.from_struct(x) end)
      |> Enum.map(fn x -> getday(x) end)
      |> Enum.map(fn x -> getago(x) end)
      |> Enum.group_by(fn x -> x.day end)
      |> IO.inspect()

    render(conn, "profile.html",
      logs: histories,
      user: user,
      changeset: changeset,
      history: history
    )
  end

  defp getago(activity) do
    {:ok, relative_str} =
      Timex.shift(activity.inserted_at, minutes: -3) |> Timex.format("{relative}", :relative)

    Map.put(activity, :ago, relative_str)
  end

  defp getday(activity) do
    {:ok, datetime} = DateTime.from_naive(activity.inserted_at, "Etc/UTC")
    Map.put(activity, :day, DateTime.to_date(datetime))
  end

  def redirector(conn, _) do
    conn
    |> put_flash(:info, "You need to login first.")
    |> redirect(to: user_path(conn, :login))
  end
end

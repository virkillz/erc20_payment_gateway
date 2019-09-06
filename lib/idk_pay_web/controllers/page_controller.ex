defmodule IdkPayWeb.PageController do
  use IdkPayWeb, :controller

  alias IdkPay.Account
  alias IdkPay.Account.User

  def index(conn, _params) do
    conn
    |> render("index.html", layout: {IdkPayWeb.LayoutView, "fe.html"})
  end

  def dashboard(conn, _params) do
    conn
    |> render("dashboard.html", layout: {IdkPayWeb.LayoutView, "fe.html"})
  end

  def payment(conn, _params) do
    conn
    |> render("payment.html", layout: {IdkPayWeb.LayoutView, "blank.html"})
  end

  def integration(conn, _params) do
    conn
    |> render("integration.html", layout: {IdkPayWeb.LayoutView, "fe.html"})
  end

  def pricing(conn, _params) do
    conn
    |> render("pricing.html", layout: {IdkPayWeb.LayoutView, "fe.html"})
  end

  def login(conn, _params) do
    changeset = Account.change_user(%User{})
    render(conn, "login.html", layout: {IdkPayWeb.LayoutView, "fe.html"}, changeset: changeset)
  end

  def register(conn, _params) do
    changeset = Account.change_user(%User{})
    render(conn, "register.html", layout: {IdkPayWeb.LayoutView, "fe.html"}, changeset: changeset)
  end

  def createuser(conn, %{"user" => params}) do
    case Account.create_user_frontend(params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully. You can login now")
        |> redirect(to: "/login")

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)

        conn
        |> put_flash(:error, "Oops, check error below")
        |> render("register.html", layout: {IdkPayWeb.LayoutView, "fe.html"}, changeset: changeset)
    end
  end

  def auth(conn, %{"email" => email, "password" => password}) do
    case Account.authenticate_user_front(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> redirect(to: "/")

      {:error, reason} ->
        changeset = Account.change_user(%User{})

        conn
        |> put_flash(:error, reason)
        |> render("login-nosocial.html",
          layout: {IdkPayWeb.LayoutView, "fe.html"},
          changeset: changeset
        )
    end
  end

  def createuser(conn, params) do
    IO.inspect(params)
    text(conn, "mbel")
  end

  def recover(conn, _params) do
    render(conn, "recover.html", layout: {IdkPayWeb.LayoutView, "fe.html"})
  end

  def signout(conn, _parms) do
    conn
    |> Plug.Conn.configure_session(drop: true)
    |> redirect(to: "/")
  end

  def current_user(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    if user_id, do: Repo.get(User, user_id)
  end

  def user_signed_in?(conn) do
    !!current_user(conn)
  end
end

defmodule IdkPayWeb.Router do
  use IdkPayWeb, :router

  # -----------------pipeline ----------------

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(Phoenix.LiveView.Flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(IdkPayWeb.Plugs.SetCurrentUser)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(IdkPay.Auth.AuthAccessPipeline)
  end

  # ----------------- scope route ----------------

  scope "/admin", IdkPayWeb do
    # Use the default browser stack
    pipe_through([:browser, :auth])

    get("/", UserController, :dashboard)
    get("/profile", UserController, :profile)
    get("/locked", UserController, :locked)
    resources("/activity", ActivityController, only: [:index, :show, :delete])
    resources("/user", UserController)
    resources("/invoices", InvoiceController)
    resources("/addresses", AddressController)
    resources("/transactions", TransactionController)
    get("/logout", UserController, :logout)
  end

  scope "/", IdkPayWeb do
    pipe_through(:browser)

    get("/dashboard", PageController, :dashboard)

    get("/", PageController, :index)
    get("/login", PageController, :login)
    get("/lgn", PageController, :lgn)
    get("/integration", PageController, :integration)
    get("/pricing", PageController, :pricing)
    get("/register", PageController, :register)
    post("/login", PageController, :auth)
    post("/register", PageController, :createuser)
    get("/recover", PageController, :recover)
    get("/admin/login", UserController, :login)
    post("/admin/login", UserController, :auth)
    get("/signout", PageController, :signout)
  end

  # Other scopes may use custom stacks.
  # scope "/api", IdkPayWeb do
  #   pipe_through :api
  # end
end

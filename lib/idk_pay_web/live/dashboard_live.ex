defmodule IdkPayWeb.DashboardLive do
  use Phoenix.LiveView

  alias IdkPay.Account
  alias IdkPay.Account.Credential
  alias IdkPay.Transaction

  def render(assign) do
    IdkPayWeb.DashboardView.render("dashboard.html", assign)
  end

  def mount(%{current_user_id: user_id}, socket) do
    user = Account.get_user!(user_id)

    invoices = Transaction.list_invoices_by(:user_id, user.id) |> IO.inspect()

    active_tab =
      if is_nil(user.business_name) do
        "profile"
      else
        "my_invoice"
      end

    new_socket =
      socket
      |> assign_new(:user, fn -> user end)
      |> assign(:active_tab, active_tab)
      |> assign(:success_alert, "")
      |> assign(:error_alert, "")
      |> assign(:invoices, invoices)
      |> assign(:credential_mode, "Testnet")
      |> assign(:credentials, Account.list_credentials())
      |> assign_new(:user_changeset, fn -> Account.change_user(user) end)
      |> assign_new(:credential_changeset, fn -> Account.change_credential(%Credential{}) end)

    {:ok, new_socket}
  end

  def handle_event("switch_tab", %{"tab" => tab}, socket) do
    new_socket =
      socket
      |> assign(:success_alert, "")
      |> assign(:error_alert, "")
      |> assign(:active_tab, tab)

    {:noreply, new_socket}
  end

  def handle_event("change_network", %{"network" => network}, socket) do
    {:noreply, assign(socket, :credential_mode, network)}
  end

  def handle_event("add_mainnet_credential", %{"credential" => credential_params}, socket) do
    {:noreply, socket}
  end

  def handle_event("save_profile", %{"user" => user_params}, socket) do
    new_socket =
      case Account.update_user(socket.assigns.user, user_params) do
        {:ok, user} ->
          socket
          |> assign(success_alert: "Success")
          |> assign(:user, user)
          |> assign(:user_changeset, Account.change_user(user))

        {:error, %Ecto.Changeset{} = changeset} ->
          socket
          |> assign(:user_changeset, changeset)
      end

    {:noreply, new_socket}
  end

  def handle_event("add_credential", %{"credential" => credential_params}, socket) do
    new_credential_params = Map.put(credential_params, "network", socket.assigns.credential_mode)

    new_socket =
      case Account.create_credential(new_credential_params) do
        {:ok, credential} ->
          socket
          |> assign(success_alert: "Success. New credential is created.")
          |> assign(:active_tab, "my_credential")
          |> assign(:credentials, Account.list_credentials())

        {:error, %Ecto.Changeset{} = changeset} ->
          socket
          |> assign(error_alert: "Oops, something is wrong with your input.")
          |> assign(:credential_changeset, changeset)
      end

    {:noreply, new_socket}
  end
end

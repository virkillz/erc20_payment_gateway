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

    invoices = Transaction.list_invoices_by(:user_id, user.id)
    list_credential = Account.list_credentials_by(:user_id, user.id)

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
      |> assign(:credential_detail, %Credential{})
      |> assign(:error_alert, "")
      |> assign(:invoices, invoices)
      |> assign(:credential_mode, "Testnet")
      |> assign(:credentials, list_credential)
      |> assign_new(:user_changeset, fn -> Account.change_user(user) end)
      |> assign_new(:credential_changeset, fn -> Account.change_credential(%Credential{}) end)

    {:ok, new_socket}
  end

  def handle_event("switch_tab", %{"tab" => tab} = value, socket) do
    new_socket =
      socket
      |> assign(:success_alert, "")
      |> assign(:error_alert, "")
      |> put_credential_detail_if_any(value)
      |> assign(:active_tab, tab)

    {:noreply, new_socket}
  end

  def handle_event("delete_credential", _value, socket) do
    case(Account.delete_credential(socket.assigns.credential_detail)) do
      {:ok, _} ->
        list_credential = Account.list_credentials_by(:user_id, socket.assigns.user.id)

        new_socket =
          socket
          |> assign(:credential_detail, %Credential{})
          |> assign(:credentials, list_credential)
          |> assign(:active_tab, "my_credential")

        {:noreply, new_socket}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  def handle_event("change_network", %{"network" => network}, socket) do
    {:noreply, assign(socket, :credential_mode, network)}
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
    new_credential_params =
      credential_params
      |> Map.put("network", socket.assigns.credential_mode)
      |> Map.put("user_id", socket.assigns.user.id)

    new_socket =
      case Account.create_credential(new_credential_params) do
        {:ok, credential} ->
          # list_credential = Account.list_credentials_by(:user_id, socket.assigns.user.id)

          socket
          |> assign(success_alert: "Success. New credential is created.")
          |> assign(:active_tab, "my_credential")
          |> assign(:credentials, [credential | socket.assigns.credentials])

        {:error, %Ecto.Changeset{} = changeset} ->
          socket
          |> assign(error_alert: "Oops, something is wrong with your input.")
          |> assign(:credential_changeset, changeset)
      end

    {:noreply, new_socket}
  end

  defp put_credential_detail_if_any(socket, value) do
    if Map.has_key?(value, "credential-id") do
      credential_detail =
        value["credential-id"] |> String.to_integer() |> Account.get_credential!()

      assign(socket, :credential_detail, credential_detail)
    else
      socket
    end
  end
end

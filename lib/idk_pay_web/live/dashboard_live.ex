defmodule IdkPayWeb.DashboardLive do
  use Phoenix.LiveView

  alias IdkPay.Account
  alias IdkPay.Account.Credential

  def render(assign) do
    IdkPayWeb.DashboardView.render("dashboard.html", assign)
  end

  def mount(%{current_user_id: user_id}, socket) do
    user = Account.get_user!(user_id)

    new_socket =
      socket
      |> assign_new(:user, fn -> user end)
      |> assign(:active_tab, "profile")
      |> assign(:success_alert, "")
      |> assign_new(:user_changeset, fn -> Account.change_user(user) end)

    # |> assign_new(:credential_changeset, fn -> Account.change_credential(%Credential{}) end)

    {:ok, new_socket}
  end

  def handle_event("switch_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, :active_tab, tab)}
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
end

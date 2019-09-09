defmodule IdkPayWeb.PaymentLive do
  use Phoenix.LiveView

  def render(assign) do
    IdkPayWeb.DashboardView.render("payment.html", assign)
  end

  def mount(%{path_params: %{invoice: invoice}}, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    count_second = NaiveDateTime.diff(invoice.expiry_date, NaiveDateTime.utc_now())

    new_socket =
      socket
      |> assign_new(:invoice, fn -> invoice end)
      |> assign(:sponsor, 1)
      |> assign(:remaining, second_to_counter(count_second))

    {:ok, new_socket}
  end

  def handle_event("coba", _value, socket) do
    IO.inspect("COBA")
    {:noreply, update(socket, :sponsor, fn x -> x + 1 end)}
  end

  def handle_info(:tick, socket) do
    count_second = NaiveDateTime.diff(socket.assigns.invoice.expiry_date, NaiveDateTime.utc_now())

    new_socket =
      socket
      |> assign(:remaining, second_to_counter(count_second))

    {:noreply, new_socket}
  end

  def second_to_counter(second) do
    day = div(second, 86400)
    day_rem = rem(second, 86400)
    hour = div(day_rem, 3600)
    hour_rem = rem(day_rem, 3600)
    minute = div(hour_rem, 60)
    minute_rem = rem(hour_rem, 60)
    %{day: day, hour: hour, minute: minute, second: minute_rem}
  end
end

defmodule IdkPayWeb.ActivityController do
  use IdkPayWeb, :controller

  alias IdkPay.Logging
  alias IdkPay.Logging.Activity

  def index(conn, _params) do
    activity = Logging.get_last_x_activity(100)
    render(conn, "index.html", activity: activity)
  end


  def create(conn, %{"activity" => activity_params}) do
    case Logging.create_activity(activity_params) do
      {:ok, activity} ->
        conn
        |> put_flash(:info, "Activity created successfully.")
        |> redirect(to: activity_path(conn, :show, activity))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end


  def delete(conn, %{"id" => id}) do
    activity = Logging.get_activity!(id)
    {:ok, _activity} = Logging.delete_activity(activity)

    conn
    |> put_flash(:info, "Activity deleted successfully.")
    |> redirect(to: activity_path(conn, :index))
  end
end

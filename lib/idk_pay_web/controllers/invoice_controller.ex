defmodule IdkPayWeb.InvoiceController do
  use IdkPayWeb, :controller

  alias IdkPay.Transaction
  alias IdkPay.Transaction.Invoice
  alias IdkPay.Account

  def index(conn, _params) do
    invoices = Transaction.list_invoices()
    render(conn, "index.html", invoices: invoices)
  end

  def new(conn, _params) do
    changeset = Transaction.change_invoice(%Invoice{})
    render(conn, "new.html", changeset: changeset, users: get_users())
  end

  def get_users do
    Account.list_user_only() |> Enum.map(fn x -> {x.email, x.id} end)
  end

  def create(conn, %{"invoice" => invoice_params}) do
    case Transaction.create_invoice(invoice_params) do
      {:ok, %{invoice: invoice}} ->
        conn
        |> put_flash(:info, "Invoice created successfully.")
        |> redirect(to: invoice_path(conn, :show, invoice))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, users: get_users())
    end
  end

  def show(conn, %{"id" => id}) do
    invoice = Transaction.get_invoice!(id)
    render(conn, "show.html", invoice: invoice)
  end

  def edit(conn, %{"id" => id}) do
    invoice = Transaction.get_invoice!(id)
    changeset = Transaction.change_invoice(invoice)
    render(conn, "edit.html", invoice: invoice, changeset: changeset, users: get_users())
  end

  def update(conn, %{"id" => id, "invoice" => invoice_params}) do
    invoice = Transaction.get_invoice!(id)

    case Transaction.update_invoice(invoice, invoice_params) do
      {:ok, invoice} ->
        conn
        |> put_flash(:info, "Invoice updated successfully.")
        |> redirect(to: invoice_path(conn, :show, invoice))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", invoice: invoice, changeset: changeset, users: get_users)
    end
  end

  def delete(conn, %{"id" => id}) do
    invoice = Transaction.get_invoice!(id)
    {:ok, _invoice} = Transaction.delete_invoice(invoice)

    conn
    |> put_flash(:info, "Invoice deleted successfully.")
    |> redirect(to: invoice_path(conn, :index))
  end
end

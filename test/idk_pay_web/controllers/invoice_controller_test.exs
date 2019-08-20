defmodule IdkPayWeb.InvoiceControllerTest do
  use IdkPayWeb.ConnCase

  alias IdkPay.Transaction

  @create_attrs %{amount: 42, expiry_date: ~D[2010-04-17], fee: 42, invoice_status: "some invoice_status", payment_status: "some payment_status", purpose: "some purpose", token: "some token", total: 42}
  @update_attrs %{amount: 43, expiry_date: ~D[2011-05-18], fee: 43, invoice_status: "some updated invoice_status", payment_status: "some updated payment_status", purpose: "some updated purpose", token: "some updated token", total: 43}
  @invalid_attrs %{amount: nil, expiry_date: nil, fee: nil, invoice_status: nil, payment_status: nil, purpose: nil, token: nil, total: nil}

  def fixture(:invoice) do
    {:ok, invoice} = Transaction.create_invoice(@create_attrs)
    invoice
  end

  describe "index" do
    test "lists all invoices", %{conn: conn} do
      conn = get conn, invoice_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Invoices"
    end
  end

  describe "new invoice" do
    test "renders form", %{conn: conn} do
      conn = get conn, invoice_path(conn, :new)
      assert html_response(conn, 200) =~ "New Invoice"
    end
  end

  describe "create invoice" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, invoice_path(conn, :create), invoice: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == invoice_path(conn, :show, id)

      conn = get conn, invoice_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Invoice"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, invoice_path(conn, :create), invoice: @invalid_attrs
      assert html_response(conn, 200) =~ "New Invoice"
    end
  end

  describe "edit invoice" do
    setup [:create_invoice]

    test "renders form for editing chosen invoice", %{conn: conn, invoice: invoice} do
      conn = get conn, invoice_path(conn, :edit, invoice)
      assert html_response(conn, 200) =~ "Edit Invoice"
    end
  end

  describe "update invoice" do
    setup [:create_invoice]

    test "redirects when data is valid", %{conn: conn, invoice: invoice} do
      conn = put conn, invoice_path(conn, :update, invoice), invoice: @update_attrs
      assert redirected_to(conn) == invoice_path(conn, :show, invoice)

      conn = get conn, invoice_path(conn, :show, invoice)
      assert html_response(conn, 200) =~ "some updated invoice_status"
    end

    test "renders errors when data is invalid", %{conn: conn, invoice: invoice} do
      conn = put conn, invoice_path(conn, :update, invoice), invoice: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Invoice"
    end
  end

  describe "delete invoice" do
    setup [:create_invoice]

    test "deletes chosen invoice", %{conn: conn, invoice: invoice} do
      conn = delete conn, invoice_path(conn, :delete, invoice)
      assert redirected_to(conn) == invoice_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, invoice_path(conn, :show, invoice)
      end
    end
  end

  defp create_invoice(_) do
    invoice = fixture(:invoice)
    {:ok, invoice: invoice}
  end
end

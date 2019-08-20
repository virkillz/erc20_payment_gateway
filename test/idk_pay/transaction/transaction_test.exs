defmodule IdkPay.TransactionTest do
  use IdkPay.DataCase

  alias IdkPay.Transaction

  describe "invoices" do
    alias IdkPay.Transaction.Invoice

    @valid_attrs %{amount: 42, expiry_date: ~D[2010-04-17], fee: 42, invoice_status: "some invoice_status", payment_status: "some payment_status", purpose: "some purpose", token: "some token", total: 42}
    @update_attrs %{amount: 43, expiry_date: ~D[2011-05-18], fee: 43, invoice_status: "some updated invoice_status", payment_status: "some updated payment_status", purpose: "some updated purpose", token: "some updated token", total: 43}
    @invalid_attrs %{amount: nil, expiry_date: nil, fee: nil, invoice_status: nil, payment_status: nil, purpose: nil, token: nil, total: nil}

    def invoice_fixture(attrs \\ %{}) do
      {:ok, invoice} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transaction.create_invoice()

      invoice
    end

    test "list_invoices/0 returns all invoices" do
      invoice = invoice_fixture()
      assert Transaction.list_invoices() == [invoice]
    end

    test "get_invoice!/1 returns the invoice with given id" do
      invoice = invoice_fixture()
      assert Transaction.get_invoice!(invoice.id) == invoice
    end

    test "create_invoice/1 with valid data creates a invoice" do
      assert {:ok, %Invoice{} = invoice} = Transaction.create_invoice(@valid_attrs)
      assert invoice.amount == 42
      assert invoice.expiry_date == ~D[2010-04-17]
      assert invoice.fee == 42
      assert invoice.invoice_status == "some invoice_status"
      assert invoice.payment_status == "some payment_status"
      assert invoice.purpose == "some purpose"
      assert invoice.token == "some token"
      assert invoice.total == 42
    end

    test "create_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transaction.create_invoice(@invalid_attrs)
    end

    test "update_invoice/2 with valid data updates the invoice" do
      invoice = invoice_fixture()
      assert {:ok, invoice} = Transaction.update_invoice(invoice, @update_attrs)
      assert %Invoice{} = invoice
      assert invoice.amount == 43
      assert invoice.expiry_date == ~D[2011-05-18]
      assert invoice.fee == 43
      assert invoice.invoice_status == "some updated invoice_status"
      assert invoice.payment_status == "some updated payment_status"
      assert invoice.purpose == "some updated purpose"
      assert invoice.token == "some updated token"
      assert invoice.total == 43
    end

    test "update_invoice/2 with invalid data returns error changeset" do
      invoice = invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Transaction.update_invoice(invoice, @invalid_attrs)
      assert invoice == Transaction.get_invoice!(invoice.id)
    end

    test "delete_invoice/1 deletes the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{}} = Transaction.delete_invoice(invoice)
      assert_raise Ecto.NoResultsError, fn -> Transaction.get_invoice!(invoice.id) end
    end

    test "change_invoice/1 returns a invoice changeset" do
      invoice = invoice_fixture()
      assert %Ecto.Changeset{} = Transaction.change_invoice(invoice)
    end
  end
end

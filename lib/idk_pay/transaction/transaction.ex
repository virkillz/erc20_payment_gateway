defmodule IdkPay.Transaction do
  @moduledoc """
  The Transaction context.
  """

  import Ecto.Query, warn: false
  alias IdkPay.Repo

  alias IdkPay.Transaction.Invoice
  alias IdkPay.Ethereum
  alias Ecto.Multi

  @doc """
  Returns the list of invoices.

  ## Examples

      iex> list_invoices()
      [%Invoice{}, ...]

  """
  def list_invoices do
    Repo.all(Invoice)
  end

  @doc """
  Returns the list of invoices by user ID.

  ## Examples

      iex> list_invoices()
      [%Invoice{}, ...]

  """
  def list_invoices_by(:user_id, user_id) do
    query =
      from(i in Invoice,
        where: i.user_id == ^user_id
      )

    Repo.all(query)
  end

  @doc """
  Return invoice by Invoice ID

  ## Examples

      iex> list_invoices()
      [%Invoice{}, ...]

  """
  def get_invoice_by(:inv_id, inv_id) do
    query =
      from(i in Invoice,
        where: i.inv_id == ^inv_id,
        limit: 1,
        preload: [:user]
      )

    Repo.one(query)
  end

  @doc """
  Gets a single invoice.

  Raises `Ecto.NoResultsError` if the Invoice does not exist.

  ## Examples

      iex> get_invoice!(123)
      %Invoice{}

      iex> get_invoice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invoice!(id), do: Repo.get!(Invoice, id)

  @doc """
  Creates a invoice.

  ## Examples

      iex> create_invoice(%{field: value})
      {:ok, %Invoice{}}

      iex> create_invoice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invoice(attrs \\ %{}) do
    Multi.new()
    |> Multi.run(:invoice, fn _, _ ->
      case Ethereum.get_unused_address() |> IO.inspect() do
        {:ok, addr} ->
          new_attrs = Map.put(attrs, "eth_address", addr) |> IO.inspect()

          %Invoice{}
          |> Invoice.changeset(new_attrs)
          |> Repo.insert()

        {:error, _reason} ->
          {:error, "No available ethereum address to be assigned."}
      end
    end)
    |> Multi.run(:eth_address, fn _repo, %{invoice: invoice} ->
      address = Ethereum.get_address_by(:eth_address, invoice.eth_address)

      Ethereum.update_address(address, %{is_used: true, invoice_id: invoice.id})
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a invoice.

  ## Examples

      iex> update_invoice(invoice, %{field: new_value})
      {:ok, %Invoice{}}

      iex> update_invoice(invoice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_invoice(%Invoice{} = invoice, attrs) do
    invoice
    |> Invoice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Invoice.

  ## Examples

      iex> delete_invoice(invoice)
      {:ok, %Invoice{}}

      iex> delete_invoice(invoice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invoice(%Invoice{} = invoice) do
    Repo.delete(invoice)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invoice changes.

  ## Examples

      iex> change_invoice(invoice)
      %Ecto.Changeset{source: %Invoice{}}

  """
  def change_invoice(%Invoice{} = invoice) do
    Invoice.changeset(invoice, %{})
  end
end

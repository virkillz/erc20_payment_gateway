defmodule IdkPay.AccountTest do
  use IdkPay.DataCase

  alias IdkPay.Account

  describe "credentials" do
    alias IdkPay.Account.Credential

    @valid_attrs %{eth_address: "some eth_address", is_deleted: true, network: "some network", public_key: "some public_key", secret_key: "some secret_key", success_url_redirect: "some success_url_redirect", webhook_url: "some webhook_url"}
    @update_attrs %{eth_address: "some updated eth_address", is_deleted: false, network: "some updated network", public_key: "some updated public_key", secret_key: "some updated secret_key", success_url_redirect: "some updated success_url_redirect", webhook_url: "some updated webhook_url"}
    @invalid_attrs %{eth_address: nil, is_deleted: nil, network: nil, public_key: nil, secret_key: nil, success_url_redirect: nil, webhook_url: nil}

    def credential_fixture(attrs \\ %{}) do
      {:ok, credential} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_credential()

      credential
    end

    test "list_credentials/0 returns all credentials" do
      credential = credential_fixture()
      assert Account.list_credentials() == [credential]
    end

    test "get_credential!/1 returns the credential with given id" do
      credential = credential_fixture()
      assert Account.get_credential!(credential.id) == credential
    end

    test "create_credential/1 with valid data creates a credential" do
      assert {:ok, %Credential{} = credential} = Account.create_credential(@valid_attrs)
      assert credential.eth_address == "some eth_address"
      assert credential.is_deleted == true
      assert credential.network == "some network"
      assert credential.public_key == "some public_key"
      assert credential.secret_key == "some secret_key"
      assert credential.success_url_redirect == "some success_url_redirect"
      assert credential.webhook_url == "some webhook_url"
    end

    test "create_credential/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_credential(@invalid_attrs)
    end

    test "update_credential/2 with valid data updates the credential" do
      credential = credential_fixture()
      assert {:ok, %Credential{} = credential} = Account.update_credential(credential, @update_attrs)
      assert credential.eth_address == "some updated eth_address"
      assert credential.is_deleted == false
      assert credential.network == "some updated network"
      assert credential.public_key == "some updated public_key"
      assert credential.secret_key == "some updated secret_key"
      assert credential.success_url_redirect == "some updated success_url_redirect"
      assert credential.webhook_url == "some updated webhook_url"
    end

    test "update_credential/2 with invalid data returns error changeset" do
      credential = credential_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_credential(credential, @invalid_attrs)
      assert credential == Account.get_credential!(credential.id)
    end

    test "delete_credential/1 deletes the credential" do
      credential = credential_fixture()
      assert {:ok, %Credential{}} = Account.delete_credential(credential)
      assert_raise Ecto.NoResultsError, fn -> Account.get_credential!(credential.id) end
    end

    test "change_credential/1 returns a credential changeset" do
      credential = credential_fixture()
      assert %Ecto.Changeset{} = Account.change_credential(credential)
    end
  end
end

defmodule KsuiteMiddlewareWeb.HomeControllerTest do
  use KsuiteMiddlewareWeb.ConnCase

  import KsuiteMiddleware.HomewFixtures

  @create_attrs %{test: "some test"}
  @update_attrs %{test: "some updated test"}
  @invalid_attrs %{test: nil}

  describe "index" do
    test "lists all homes", %{conn: conn} do
      conn = get(conn, ~p"/homes")
      assert html_response(conn, 200) =~ "Listing Homes"
    end
  end

  describe "new home" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/homes/new")
      assert html_response(conn, 200) =~ "New Home"
    end
  end

  describe "create home" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/homes", home: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/homes/#{id}"

      conn = get(conn, ~p"/homes/#{id}")
      assert html_response(conn, 200) =~ "Home #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/homes", home: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Home"
    end
  end

  describe "edit home" do
    setup [:create_home]

    test "renders form for editing chosen home", %{conn: conn, home: home} do
      conn = get(conn, ~p"/homes/#{home}/edit")
      assert html_response(conn, 200) =~ "Edit Home"
    end
  end

  describe "update home" do
    setup [:create_home]

    test "redirects when data is valid", %{conn: conn, home: home} do
      conn = put(conn, ~p"/homes/#{home}", home: @update_attrs)
      assert redirected_to(conn) == ~p"/homes/#{home}"

      conn = get(conn, ~p"/homes/#{home}")
      assert html_response(conn, 200) =~ "some updated test"
    end

    test "renders errors when data is invalid", %{conn: conn, home: home} do
      conn = put(conn, ~p"/homes/#{home}", home: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Home"
    end
  end

  describe "delete home" do
    setup [:create_home]

    test "deletes chosen home", %{conn: conn, home: home} do
      conn = delete(conn, ~p"/homes/#{home}")
      assert redirected_to(conn) == ~p"/homes"

      assert_error_sent 404, fn ->
        get(conn, ~p"/homes/#{home}")
      end
    end
  end

  defp create_home(_) do
    home = home_fixture()
    %{home: home}
  end
end

defmodule KratosApi.PageControllerTest do
  use KratosApi.ConnCase

  test "GET /api/", %{conn: conn} do
    conn = get conn, "/api"
    assert json_response(conn, 200) =~ "Welcome to the Kratos API!"
  end
end

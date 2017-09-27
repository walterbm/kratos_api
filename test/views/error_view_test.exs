defmodule KratosApi.ErrorViewTest do
  use KratosApi.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(KratosApi.ErrorView, "404.json", []) ==
           "{\"errors\":[{\"error\":\"We\'re sorry, something went wrong.\"}]}"
  end

  test "render 500.html" do
    assert render_to_string(KratosApi.ErrorView, "404.json", []) ==
           "{\"errors\":[{\"error\":\"We\'re sorry, something went wrong.\"}]}"
  end

  test "render any other" do
    assert render_to_string(KratosApi.ErrorView, "404.json", []) ==
           "{\"errors\":[{\"error\":\"We\'re sorry, something went wrong.\"}]}"
  end
end

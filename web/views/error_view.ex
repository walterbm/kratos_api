defmodule KratosApi.ErrorView do
  use KratosApi.Web, :view

  def render("404.json", _assigns) do
    %{ error: "We're sorry, something went wrong." } |> wrap
  end

  def render("500.json", _assigns) do
    %{ error: "We're sorry, something went wrong." } |> wrap
  end

  def render("not_following_bill.json", _assings) do
    %{ error: "You are not following this Bill." } |> wrap
  end

  def render("not_voted.json", _assings) do
    %{ error: "You have not voted on this question yet." } |> wrap
  end

  def render("bad_address.json", _assings) do
    %{ error: "Sorry, we could not find your congressional district." } |> wrap
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end

  def wrap(errors) when is_list(errors)do
    %{ errors: errors }
  end
  def wrap(error) do
    %{ errors: List.wrap(error) }
  end
end

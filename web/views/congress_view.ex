defmodule KratosApi.CongressView do
  use KratosApi.Web, :view

  def render("activity.json", %{activity: activity}) do
    %{
      chamber: activity.chamber,
      title: activity.title,
      bill: render_one(activity.bill, KratosApi.BillView, "bill_small.json"),
    }
  end

  def render("activities.json", %{activities: activities}) do
    %{
      data: render_many(activities, KratosApi.CongressView, "activity.json", as: :activity),
    }
  end

end

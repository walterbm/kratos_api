defmodule KratosApi.CongressView do
  use KratosApi.Web, :view

  def render("activity.json", %{activity: activity}) do
    %{
      chamber: activity.chamber,
      title: activity.title,
      bill_id: activity.bill_id,
      bill_gpo_id: activity.bill_gpo_id,
      pretty_bill_gpo_id: activity.pretty_bill_gpo_id
    }
  end

  def render("activities.json", %{activities: activities}) do
    %{
      data: render_many(activities, KratosApi.CongressView, "activity.json", as: :activity),
    }
  end

end

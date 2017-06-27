defmodule KratosApi.CongressView do
  use KratosApi.Web, :view

  def render("activity.json", %{activity: activity}) do
    %{
      chamber: activity.chamber,
      title: activity.title,
      description: activity.description,
      link: activity.link,
      published_at: activity.published_at
    }
  end

  def render("activities.json", %{activities: activities}) do
    %{
      data: render_many(activities, KratosApi.CongressView, "activity.json"),
    }
  end

end

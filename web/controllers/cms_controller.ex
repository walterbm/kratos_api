defmodule KratosApi.CMSController do
  use KratosApi.Web, :controller

  plug KratosApi.BasicAuth
  plug :put_layout, "cms.html"

  alias KratosApi.{
    Repo,
    StateImage,
  }

  @bucket "kratos-assets/state-images"

  def index(conn, _params) do
    render conn, "index.html"
  end

  def state_image_index(conn, _params) do
    state_images = Repo.all(StateImage)
    changeset = StateImage.changeset(%StateImage{})

    render conn, "state_image_index.html", state_images: state_images, changeset: changeset
  end


  def state_image_create(conn, %{"state_image" => %{"image" => image, "state" => state} }) do
    image_binary = File.read!(image.path)
    filename = "#{state}-#{UUID.uuid4(:hex)}-#{image.filename}"

    ExAws.S3.put_object(@bucket, filename, image_binary, [content_type: image.content_type]) |> ExAws.request!

    changeset_params = %{state: state, image_url: "https://s3.amazonaws.com/#{@bucket}/#{filename}"}

    changeset = StateImage.changeset(%StateImage{}, changeset_params)
    case Repo.insert(changeset) do
      {:ok, _upload} ->
          conn
          |> put_flash(:info, "Image uploaded successfully!")
          |> redirect(to: cms_path(conn, :state_image_index))
      {:error, _changeset} ->
          conn
          |> put_flash(:error, "Image upload failed!")
          |> redirect(to: cms_path(conn, :state_image_index))
    end
  end

  def state_image_delete(conn, %{"state" => state}) do
    Repo.get!(StateImage, state)
    |> Repo.delete!

    conn
    |> put_flash(:info, "Image deleted!")
    |> redirect(to: cms_path(conn, :state_image_index))
  end

end

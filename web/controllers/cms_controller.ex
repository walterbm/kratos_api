defmodule KratosApi.CMSController do
  use KratosApi.Web, :controller

  plug KratosApi.BasicAuth

  alias KratosApi.{
    Repo,
    StateImage,
  }

  @bucket "kratos-assets/state-images"

  def new_state_image(conn, _params) do
    changeset = StateImage.changeset(%StateImage{})

    render conn, "new_state_image.html", changeset: changeset
  end

  def upload_state_image(conn, %{"state_image" => %{"image" => image, "state" => state} }) do
    image_binary = File.read!(image.path)
    filename = "#{state}-#{UUID.uuid4(:hex)}-#{image.filename}"

    ExAws.S3.put_object(@bucket, filename, image_binary, [content_type: image.content_type]) |> ExAws.request!

    changeset_params = %{state: state, image_url: "https://s3.amazonaws.com/#{@bucket}/#{filename}"}

    changeset = StateImage.changeset(%StateImage{}, changeset_params)
    case Repo.insert(changeset) do
      {:ok, _upload} ->
          conn
          |> put_flash(:info, "Image uploaded successfully!")
          |> redirect(to: cms_path(conn, :new_state_image))
      {:error, changeset} ->
          conn
          |> put_flash(:info, "Image upload failed!")
          |> render "new_state_image.html", changeset: changeset
    end
  end

end

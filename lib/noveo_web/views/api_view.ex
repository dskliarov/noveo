defmodule NoveoWeb.APIView do
  use NoveoWeb, :view

  def render("error.json", %{message: message}) do
    %{errorMessage: message}
  end

  def render("job_posting.json", %{data: data}) do
    %{"job_postings" => data}
  end
end

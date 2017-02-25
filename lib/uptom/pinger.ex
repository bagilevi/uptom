defmodule Uptom.Pinger do
  def ping(url) do
    response = HTTPotion.get(url, [timeout: 5_000])
    case response do
      %HTTPotion.Response{} ->
        if HTTPotion.Response.success?(response) do
          {:ok, status_code: response.status_code}
        else
          {:error, status_code: response.status_code}
        end
      %HTTPotion.ErrorResponse{} ->
        {:error, message: response.message}
    end
  end
end

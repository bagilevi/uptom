defmodule Uptom.Pinger do
  def ping(url) do
    response = HTTPotion.get(url, [timeout: 5_000])
    case response do
      %HTTPotion.Response{} ->
        if HTTPotion.Response.success?(response) do
          {:up, status_code: response.status_code}
        else
          {:down, status_code: response.status_code}
        end
      %HTTPotion.ErrorResponse{} ->
        {:down, message: response.message}
    end
  end
end

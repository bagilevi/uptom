defmodule Uptom.Pinger do
  def ping(url, opts \\ [timeout: 5_000]) do
    response = HTTPotion.get(url, [timeout: opts[:timeout]])
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

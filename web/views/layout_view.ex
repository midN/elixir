defmodule Stockman.LayoutView do
  use Stockman.Web, :view

  def show_flash(conn) do
    get_flash(conn) |> flash_msg
  end

  def flash_msg(%{"success" => msg}), do: closable_alert("success", msg)
  def flash_msg(%{"info" => msg}), do: closable_alert("info", msg)
  def flash_msg(%{"error" => msg}), do: closable_alert("danger", msg)
  def flash_msg(_), do: nil

  defp closable_alert(type, msg) do
    ~E"""
    <div class='alert alert-<%= type %>'>
      <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
      <%= msg %>
    </div>
    """
  end
end

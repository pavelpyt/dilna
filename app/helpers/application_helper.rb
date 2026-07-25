module ApplicationHelper
  def nav_item_active?(path)
    return request.path == path if path == root_path

    request.path.start_with?(path)
  end
end

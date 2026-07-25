module ApplicationHelper
  def nav_item_active?(path)
    return request.path == path if path == root_path

    request.path.start_with?(path)
  end

  # Počet nevyřízených poptávek — visí u položky v menu, ať je vidět, že něco přišlo.
  def open_inquiries_count
    @open_inquiries_count ||= current_account.jobs.with_status("inquiry").count
  end
end

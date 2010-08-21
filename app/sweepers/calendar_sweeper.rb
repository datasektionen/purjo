class CalendarSweeper < ActionController::Caching::Sweeper
  observe Post
  def after_save(post)
    Rails.cache.delete("views/front_pages/agenda")
    Rails.cache.delete("views/front_pages/tag_list")
  end
end
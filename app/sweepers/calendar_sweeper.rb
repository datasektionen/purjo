class CalendarSweeper < ActionController::Caching::Sweeper
  observe Post
  def after_save(post)
    Rails.cache.delete("views/front_pages/agenda")
  end
end

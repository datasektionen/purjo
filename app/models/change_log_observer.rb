class ChangeLogObserver < ActiveRecord::Observer
  observe :text_node
  
  def after_update(record)
    Change.create!(
      :action => 'update',
      :changed_object => record.versions.last,
      :changed_by => Person.current
    )
  end
  
  def after_create(record)
    Change.create!(
      :action => 'create',
      :changed_object => record,
      :changed_by => Person.current
    )
  end
  
end

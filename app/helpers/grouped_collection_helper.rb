module GroupedCollectionHelper
  def group_collection_options(collection, group, selected)
    options_for_select(
      collection.collect { |x| [x.name, [group, x.id].join('_')] },
      selected
    )
  end
end

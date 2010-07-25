module ActsAsTaggableOn::Taggable
  module Core
    module InstanceMethods
      # Detta hack finns för att acts_as_taggable_on inte verkar fungera med
      # rails 3 riktigt som det ska. Raden som hämtar ut old_taggings returnerar
      # alla taggings om old_tags == [], vilket gör att om användaren
      # bara lägger till taggar så tas alla som redan finns bort.
      def save_tags
        tagging_contexts.each do |context|
          next unless tag_list_cache_set_on(context)

          tag_list = tag_list_cache_on(context).uniq

          # Find existing tags or create non-existing tags:
          tag_list = ActsAsTaggableOn::Tag.find_or_create_all_with_like_by_name(tag_list)

          current_tags = tags_on(context)
          old_tags     = current_tags - tag_list
          new_tags     = tag_list     - current_tags
    
          if old_tags.present?
            # Find taggings to remove:
            old_taggings = taggings.where(:tagger_type => nil, :tagger_id => nil,
                                          :context => context.to_s, :tag_id => old_tags).all

            if old_taggings.present?
              # Destroy old taggings:
              ActsAsTaggableOn::Tagging.destroy_all :id => old_taggings.map(&:id)
            end
          end

          # Create new taggings:
          new_tags.each do |tag|
            taggings.create!(:tag_id => tag.id, :context => context.to_s, :taggable => self)
          end
        end

        true
      end
    end
  end
end
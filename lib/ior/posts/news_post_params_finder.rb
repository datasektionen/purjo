module Ior
  module Posts
    module NewsPostParamsFinder
      def self.included(base)
        base.send(:include, InstanceMetods)
      end
      
      module InstanceMetods
        def find_news_post_by_params(params)
          posts = nil
          tags = nil
          archive = nil
          
          params[:tags] = nil if params[:tags] == ""
          params[:tags] = [params[:tags]] if params[:tags] && !params[:tags].is_a?(Array)
    
          if params[:archive]
            archive = true
    
            if params[:tags]
              tags = params[:tags]
              posts = Post.news_posts.tagged_with(tags, :on => :categories)
            else
              posts = Post.news_posts
            end
          else
            archive = false
    
            if params[:tags]
              tags = params[:tags]
              posts = Post.news_posts.active.tagged_with(tags, :on => :categories)
            else
              posts = Post.news_posts.active
            end
          end
    
          
          [posts, tags, archive]
        end
      end
    end
  end
end
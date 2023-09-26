# frozen_string_literal: true

class PostsController < CollectionsController

  private
  
  def allowed_params
    params.require(:post).permit :title, :content, :user_id
  end
end

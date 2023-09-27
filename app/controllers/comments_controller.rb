# frozen_string_literal: true

class CommentsController < CollectionsController

  skip_before_action :authenticate_user!

  private

  def allowed_params
    params.require(:comment).permit :name, :content, :post_id
  end
end

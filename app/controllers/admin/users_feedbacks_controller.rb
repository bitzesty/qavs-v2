class Admin::UsersFeedbacksController < Admin::BaseController
  def show
    authorize :users_feedback, :show?
  end
end

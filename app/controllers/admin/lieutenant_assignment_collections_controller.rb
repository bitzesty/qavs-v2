class Admin::LieutenantAssignmentCollectionsController < Admin::BaseController
  def create
    @lieutenant_assignment_collection = LieutenantAssignmentCollection.new(create_params)
    authorize @lieutenant_assignment_collection, :create?

    @lieutenant_assignment_collection.subject = current_subject

    @lieutenant_assignment_collection.save

    respond_to do |format|
      format.html do
        flash[:notice] = @lieutenant_assignment_collection.notice_message
        flash[:error] = @lieutenant_assignment_collection.errors.full_messages.to_sentence
        redirect_back(fallback_location: root_path)
      end
    end
  end

  private

  def create_params
    params
      .require(:lieutenant_assignment_collection)
      .permit(:form_answer_ids,
              :ceremonial_county_id)
  end
end

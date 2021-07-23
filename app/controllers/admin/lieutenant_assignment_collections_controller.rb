class Admin::LieutenantAssignmentCollectionsController < Admin::BaseController
  def create
    @lieutenant_assignment_collection = LieutenantAssignmentCollection.new(create_params)
    authorize @lieutenant_assignment_collection, :create?

    @lieutenant_assignment_collection.subject = current_subject
    total_checked = @lieutenant_assignment_collection.form_answer_ids.split(",").length
    if @lieutenant_assignment_collection.save
      notification = if total_checked > 1
                       "Groups have"
                     else
                       "Group has"
                     end.concat " been assigned to the Lord Lieutenancy office."
    end

    respond_to do |format|
      format.html do
        flash[:notice] = notification
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

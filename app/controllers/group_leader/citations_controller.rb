class GroupLeader::CitationsController < GroupLeader::BaseController
  before_action :load_citation

  def edit
    authorize @citation, :edit?
  end

  def update
    authorize @citation, :update?

    if params["accept_award"] == "false"
      redirect_to reject_group_leader_citations_path
      return
    end

    @citation.completed_at = Time.now
    if @citation.update citation_params
      flash[:success] = "Citation successfully updated!"
      redirect_to group_leader_root_path
    else
      render :edit
    end
  end

  def reject
    authorize @citation, :reject?
  end

  private

  def load_citation
    @citation = current_nomination.citation
  end

  def citation_params
    params.require(:citation).permit(:group_name, :body)
  end
end

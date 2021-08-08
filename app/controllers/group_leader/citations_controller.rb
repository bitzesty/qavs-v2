class GroupLeader::CitationsController < ApplicationController
  before_action :load_citation

  def update
    if @citation.update citation_params
      redirect_to group_leader_root_path
    else
      render :edit
    end
  end

  private

    def load_citation
      @citation = Citation.find params[:id]
    end

    def citation_params
      params.require(:citation).permit(:group_name, :body, completed_at: Time.now)
    end
end

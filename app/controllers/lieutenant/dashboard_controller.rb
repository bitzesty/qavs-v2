class Lieutenant::DashboardController < Lieutenant::BaseController
  def show
    # authorize :lieutenant_dashboard, :show?
    redirect_to lieutenant_form_answers_url
  end
end

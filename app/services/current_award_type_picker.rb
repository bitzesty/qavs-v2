class CurrentAwardTypePicker
  # If Assessor is a lead in at least one category
  # and is a lead or assigned as regular to another category
  # he sees the tabs with these categories displayed

  attr_reader :params, :current_subject

  def initialize(current_subject, params)
    @current_subject = current_subject
    @params = params
  end

  def current_award_type
    categories = ["qavs"]
    if params[:award_type].present?
      params[:award_type] if categories.include?(params[:award_type])
    else
      categories.first
    end
  end

  def visible_categories
    categories =  ["qavs"]

    categories.uniq.each_with_index.map do |category, index|
      AwardCategory.new(slug: category, first_element: index == 0)
    end
  end

  def show_award_tabs_for_assessor?
    false
  end

  class AwardCategory < OpenStruct
    def active?(params)
      slug == params[:award_type] || (params[:award_type].blank? && first_element)
    end

    def text_label
      "QAVS"
    end
  end
end

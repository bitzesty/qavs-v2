class AssessorAssignmentsConstructor
  attr_reader :nomination, :user

  def initialize(nomination, user)
    @nomination = nomination
    @user = user
  end

  def assessments
    return [] if !nomination.sub_group

    @assessments = []

    existing_assessments = nomination.assessor_assignments

    nomination.assessors.each do |assessor|
      assessment = existing_assessments.detect do |aa|
        aa.form_answer == nomination &&
          aa.assessor == assessor
      end

      assessment ||= nomination.assessor_assignments.build(assessor_id: assessor.id, document: {}, award_year: nomination.award_year)

      @assessments << assessment
    end

    if user.is_a?(Assessor)
      # reorder assessments display assessor's form first

      @assessments.sort_by! { |a| a.assessor_id == user.id ? 0 : 1 }
    end

    @assessments
  end
end

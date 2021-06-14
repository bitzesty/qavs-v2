module AssessorsHelper
  def available_assessors_for_select
    Assessor.all.map do |a|
      [a.full_name, a.id]
    end
  end
end

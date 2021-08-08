module DeadlinesHelper
  def deadline_for(kind, format = "%A %d %B %Y")
    deadline = AwardYear.current.settings.deadlines.find_by(kind: kind)
    if deadline.present? && deadline.trigger_at.present?
      deadline.trigger_at.strftime(format)
    else
      "--/--/----"
    end
  end
end

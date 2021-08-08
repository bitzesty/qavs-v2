module CitationsHelper
  def remaining_characters
    @citation.group_name.split.size < 6 ? 100 : 70
  end
end

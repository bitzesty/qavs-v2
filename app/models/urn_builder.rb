class UrnBuilder
  attr_reader :fa, :award_year

  def initialize(form_answer)
    @fa = form_answer
    @award_year = form_answer.award_year
  end

  def assign
    return if fa.urn
    return unless fa.submitted?

    fa.urn = generate_urn
  end

  def generate_urn
    sequence_attr ||= "urn_seq_#{award_year.year}"

    next_seq = fa.class.connection.select_value("SELECT nextval(#{ActiveRecord::Base.connection.quote(sequence_attr)})")

    generated_urn = "KAVS#{sprintf("%.4d", next_seq)}/"
    generated_urn += "#{award_year.year.to_s[2..]}"

    generated_urn
  end
end

class NominationStatsSearch < Search
  TRACKED_STATES = %i[
    submitted
    admin_eligible
    admin_not_eligible_nominator
    admin_not_eligible_group
    withdrawn
    local_assessment_not_recommended
    local_assessment_recommended
    not_recommended
    shortlisted
    awarded
  ]
  
  FETCH_QUERY = %Q{
    CASE WHEN ceremonial_counties.name IS NULL THEN '-' ELSE ceremonial_counties.name END AS ceremonial_county_name,
    #{TRACKED_STATES.map { |s| "COUNT(CASE WHEN form_answers.state = '#{s}' THEN 1 END) AS #{s}_count" }.join(',')},
    COUNT(CASE WHEN form_answers.state IN (#{TRACKED_STATES.map { |s| "'#{s}'" }.join(',')}) THEN 1 END) AS total_count
  }.squish.freeze

  def self.default_search
    {
      sort: "ceremonial_county_name",
      search_filter: {
        year: "all_years",
        assigned_ceremonial_county: ceremonial_county_options.map(&:second)
      }
    }
  end

  def results
    super

    @search_results = @search_results
      .select(FETCH_QUERY)
      .left_joins(:ceremonial_county)
      .group("ceremonial_counties.name")

    @search_results
  end

  def filter_by_year(scoped_results, value)
    if value == "all_years"
      scoped_results
    else
      (year = AwardYear.find_by(year: value)) ? scoped_results.where(award_year: year) : scoped_results.none
    end
  end

  def filter_by_assigned_ceremonial_county(scoped_results, value)
    value = value.map do |v|
      v == "not_assigned" ? nil : v
    end
    scoped_results.where(ceremonial_county_id: value)
  end

  def sort_by_ceremonial_county_name(scoped_results, desc = false)
    scoped_results.order("ceremonial_counties.name #{sort_order(desc)}")
  end

  class << self
    def ceremonial_county_options
      collection_mapping(county_options)
    end

    private

    def collection_mapping(options)
      options.map do |k, v|
        [v[:label], k]
      end
    end

    def county_options
      options = Hash[not_assigned: { label: "Not assigned" }]

      CeremonialCounty.ordered.collect do |county|
        options[county.id] = { label: county.name }
      end

      options
    end
  end
end

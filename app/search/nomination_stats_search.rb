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
    ceremonial_counties.id AS ceremonial_county_id,
    CASE WHEN ceremonial_counties.name IS NULL THEN 'Not assigned' ELSE ceremonial_counties.name END AS ceremonial_county_name,
    #{TRACKED_STATES.map { |s| "COUNT(CASE WHEN form_answers.state = '#{s}' THEN 1 END) AS #{s}_count" }.join(',')},
    COUNT(CASE WHEN form_answers.state IN (#{TRACKED_STATES.map { |s| "'#{s}'" }.join(',')}) THEN 1 END) AS total_count
  }.squish.freeze

  def self.default_search
    {
      sort: "name",
      search_filter: {
        year: "all_years",
        assigned_ceremonial_county: FormAnswerStatus::AdminFilter.values('assigned county')
      }
    }
  end

  def results
    @search_results = scope

    if !!filter_params[:year].presence
      @search_results = filter_by_year(@search_results, filter_params[:year].presence)
    end

    cte_query = @search_results
      .select(FETCH_QUERY)
      .left_joins(:ceremonial_county)
      .group("ceremonial_counties.id, ceremonial_counties.name")

    base_query = CeremonialCounty.select(:id, :name)
    base_scope = base_query.from("(#{base_query.to_sql} UNION ALL (SELECT NULL AS id, 'Not assigned' AS name)) AS ceremonial_counties")

    if !!filter_params[:assigned_ceremonial_county].presence
      base_scope = filter_by_assigned_ceremonial_county(base_scope, filter_params[:assigned_ceremonial_county].presence)
    end

    desc = params.fetch(:sort, "").split(".")&.last == "desc"
    base_scope = sort_by_ceremonial_county_name(base_scope, desc)

    @search_results = base_scope.with(data: cte_query)
      .select(%Q{
        ceremonial_counties.id,
        ceremonial_counties.name,
        #{TRACKED_STATES.map { |s| "COALESCE(data.#{s}_count, 0) AS #{s}_count" }.join(',')},
        COALESCE(data.total_count, 0) AS total_count
      }.squish)
      .joins("LEFT OUTER JOIN data ON data.ceremonial_county_id = ceremonial_counties.id")
  
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

    scoped_results.where(id: value)
  end

  def sort_by_ceremonial_county_name(scoped_results, desc = false)
    scoped_results.order("name #{sort_order(desc)}")
  end
end

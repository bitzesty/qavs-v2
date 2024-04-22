class LieutenantSearch < Search
  include FullNameSort

  def self.default_search
    {
      sort: "full_name",
      search_filter: {
        assigned_ceremonial_county: LieutenantSearch.ceremonial_county_options.map(&:second)
      }
    }
  end


  def filter_by_assigned_ceremonial_county(scoped_results, value)
    value = value.map do |v|
      v == "not_assigned" ? nil : v
    end
    scoped_results.where(ceremonial_county_id: value)
  end

  def sort_by_ceremonial_county_name(scoped_results, desc = false)
    scoped_results.joins(:ceremonial_county).order("ceremonial_counties.name #{sort_order(desc)}")
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

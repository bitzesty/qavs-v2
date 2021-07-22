class LieutenantSearch < Search
  DEFAULT_SEARCH = {
    sort: "full_name"
  }

  include FullNameSort

  def sort_by_ceremonial_county_name(scoped_results, desc = false)
    scoped_results.joins(:ceremonial_county).order("ceremonial_counties.name #{sort_order(desc)}")
  end
end

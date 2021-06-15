class UserSearch < Search
  DEFAULT_SEARCH = {
    sort: "full_name",
    search_filter: {}
  }

  include FullNameSort
end

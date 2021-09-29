module FormAnswerStatus::FilteringHelper
  def internal_states(filtering_values)
    filtering_values = Array(filtering_values)

    filtering_values.flat_map do |val|
      if supported_filter_attrs.include?(val.to_s)
        options[val.to_sym][:states]
      end
    end.compact
  end

  def collection(filter)
    case filter
    when 'status'
      collection_mapping(options)
    when 'sub'
      collection_mapping(sub_options)
    when 'activity type'
      collection_mapping(activity_options)
    when 'nomination county'
      collection_mapping(county_options('nomination'))
    when 'assigned county'
      collection_mapping(county_options('assigned'))
    end
  end

  def collection_mapping(options)
    options.map do |k, v|
      [v[:label], k]
    end
  end

  def values(options)
    case options
    when 'activity'
      activity_options.keys.map(&:to_s)
    when 'assigned county'
      county_options('assigned').keys.map(&:to_s)
    when 'nominated county'
      county_options('nomination').keys.map(&:to_s)
    end
  end

  def collection_for_select(_collection)
    _collection.map do |k, v|
      [v[:label], k]
    end
  end

  def activity_options
    Hash[NomineeActivityHelper.nominee_activities.collect { |activity|
      [activity, { label: NomineeActivityHelper.lookup_label_for_activity(activity), nominee_activity: [activity] }]
    } ]
  end

  def county_options(type)
    if type == 'assigned'
      options = Hash[not_assigned: { label: "Not assigned" }]
    elsif type == 'nomination'
      options = Hash[not_stated: { label: "Not stated" }]
    end
    CeremonialCounty.all.collect { |county|
      options[county.id] = { label: county.name }
    }
    options
  end

  def supported_filter_attrs
    options.keys.map(&:to_s)
  end

  def all
    collection('status').map { |s| s.last.to_s } + collection('sub').map { |s| s.last.to_s }
  end
end

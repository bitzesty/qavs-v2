module SearchHelper
  def sort_link(f, name, search, field, options = {})
    return name if options[:disabled]

    h = ''.html_safe

    h << link_to(name, { search: { sort: sort_link_param(search, field)} }, { class: sort_link_class(search, field) })
    h << f.input(:sort, as: :hidden, input_html: { id:"search_sort_#{field}", value: sort_link_param(search, field), disabled: true })

    h
  end

  private

  def sort_link_class(search, field)
    klass = ''

    if search.ordered_by == field.to_s
      klass << 'ordered'

      if search.ordered_desc
        klass << ' ordered-desc'
      end
    end

    klass
  end

  def sort_link_param(search, field)
    if search.ordered_by == field.to_s && !search.ordered_desc
      "#{field}.desc"
    else
      field
    end
  end

  def user_search_count(resource, deleted = false)
     "Showing " + user_count(resource, deleted) unless resource.none?
  end

  def user_default_count(resource, deleted = false)
    if deleted
      "Showing "
    else
      "Showing all "
    end + user_count(resource, deleted) unless resource.none?
  end

  def user_count(resource, deleted = false)
    user_type = t("admin.users.role_headers.#{controller_name}")
    user_type = user_type.downcase unless controller_name == "lieutenants"
    user_type = resource.count == 1 ? user_type.singularize : user_type
    deleted_msg = " deleted" if deleted
    "#{resource.count.to_s}#{deleted_msg.to_s} #{user_type}"
  end
end

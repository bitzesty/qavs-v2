# frozen_string_literal: true

require "countries"

module FormAnswerHelper
  def format_submit_notice(notice)
    notice.gsub!("[SUBMISSION_ENDS_TIME]", submission_deadline.decorate.formatted_trigger_time)
    notice.gsub!("[LIEUTENANT_SUBMISSION_ENDS_TIME]", local_assessment_submission_deadline.decorate.formatted_trigger_time)

    notice
  end

  def application_flags(fa, subject = nil)
    comments_count = if subject
      if current_subject.is_a?(Admin)
        fa.flagged_admin_comments_count
      else
        fa.flagged_critical_comments_count
      end
    else
      if current_subject.is_a?(Admin)
        fa.flagged_critical_comments_count
      else
        fa.flagged_admin_comments_count
      end
    end

    current_user_class = current_subject.model_name.to_s.parameterize

    flag_type = if subject
      "icon-flag-#{current_user_class}"
    else
      current_user_class == "admin" ? "icon-flag-assessor" : "icon-flag-admin"
    end

    if comments_count > 0
      content_tag :span, class: "icon-flagged #{flag_type}" do
        content_tag :span, class: "flag-count" do
          comments_count.to_s
        end
      end
    end
  end

  def user_can_edit(form, item)
    policy(form).update_item?(item)
  end

  def user_can_edit_company(form)
    policy(form).update_company? && form.submitted_and_after_the_deadline?
  end

  def application_comments(comments_count)
    return unless comments_count > 0

    output = "<span class='icon-comment'>Comments: <span class='comment-count'>"
    output += "#{comments_count}"
    output += "</span></span>"
    output.html_safe
  end

  def each_index_or_empty(collection, attrs, &block)
    if collection.any?
      collection.each_with_index &block
    else
      block.(attrs, 0)
    end
  end

  def sic_code(form_answer)
    code = form_answer.sic_code
    code || "-"
  end

  def country_collection
    ([["United Kingdom of Great Britain and Northern Ireland", "GB"], ["United States of America", "US"]] +
     ISO3166::Country.all.map { |c| [c.name, c.alpha2] }).uniq
  end

  def assessors_collection_for_bulk
    return # available_for has been removed
    assessors = Assessor.available_for(category_picker.current_award_type).map { |a| [a.full_name, a.id] }
    [["Not Assigned", "not assigned"]] + assessors
  end

  def show_bulk_lieutenants_assignment?
    policy(:lieutenant_assignment_collection).create? && Settings.after_current_submission_deadline?
  end
end

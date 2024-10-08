ready = ->
  htmlDecode = (value) ->
    $("<div/>").html(value).text()

  editFormAnswerAutoUpdate()

  # Move the attach document button
  moveAttachDocumentButton = ->
    wrapper = $("#application-attachment-form")
    $(".attachment-link", wrapper).removeClass("if-js-hide")
    $(".attachment-link", wrapper).addClass("btn btn-default btn-block btn-attachment")
    $(".attachment-link", wrapper).prepend("<span class='btn-title'>Attach document</span>")
    $(".attachment-link", wrapper).prepend("<span class='glyphicon glyphicon-paperclip'></span>")
    $(".attachment-link", wrapper).prependTo("#new_form_answer_attachment")

    wrapper = $("#audit-certificate-form")
    $(".attachment-link", wrapper).removeClass("if-js-hide")
    $(".attachment-link", wrapper).addClass("btn btn-default btn-block btn-attachment")
    $(".attachment-link", wrapper).prepend("<span class='btn-title'>Attach audit certificate</span>")
    $(".attachment-link", wrapper).prepend("<span class='glyphicon glyphicon-paperclip'></span>")
    $(".attachment-link", wrapper).prependTo("#new_audit_certificate")

  $("#new_review_audit_certificate").on "ajax:success", (e, data, status, xhr) ->
    $(this).find(".form-group").removeClass("form-edit")
    $(this).find(".form-edit-link").remove()
    $(".save-review-audit").remove()
    area = $(".audit-cert-description textarea")
    unless area.val()
      $(this).find(".form-value").html($("<p>No change necessary</p>"))
    else
      div = "<div><label>Changes made</label><p class='control-label'>#{area.val()}</p></div>"
      $(this).find(".form-value").html(div)

  $("#new_review_audit_certificate").on "click", ".save-review-audit", (e) ->
    e.preventDefault()
    $("#new_review_audit_certificate").submit()

  $(".edit-review-audit").on "click", (e) ->
    $(".save-review-audit").show()

  $("#new_form_answer_state_transition").on "ajax:success", (e, data, status, xhr) ->
    $(".section-applicant-status .dropdown-menu").replaceWith(data)
    if data == ""
      stateToggle = $(".section-applicant-status .dropdown-toggle")
      stateToggle.replaceWith("<p class='p-lg'>"+stateToggle.text()+"</p>")

  # $(".section-applicant-users .edit_assessor_assignment select").select2()
  # $("#new_assessor_assignment_collection select").select2()
  # $(".bulk-assign-assessors-form select").select2()
  # $(".bulk-assign-lieutenants-form select").select2()

  $(".section-applicant-users form").on "ajax:success", (e, data, status, xhr) ->

    form.find(".errors-holder").text("")
    form.closest(".form-group").removeClass("form-edit")
    formValueBox = form.closest(".form-group").find(".edit-value")
    formValue = form.find("select :selected").text()
    formValueBox.text(formValue)

  $(".section-applicant-users form").on "ajax:error", (e, data, status, xhr) ->
    form = $(this)
    errors = ""
    for k, error of data.responseJSON["errors"]
      errors += error

    form.find(".errors-holder").text(errors)

  $(".submit-assessment").on "ajax:error", (e, data, status, xhr) ->
    errors = data.responseJSON
    $(this).addClass("field-with-errors")
    $(this).closest(".panel-body").find("textarea").each ->
      unless $(this).val().length
        $(this).closest(".input").addClass("field-with-errors")
    $(this).find(".feedback-holder").addClass("error")
    $(this).find(".feedback-holder").html(errors.error.join("<br>"))
  $(".submit-assessment").on "ajax:success", (e, data, status, xhr) ->
    $(this).closest(".panel-body").find(".field-with-errors").removeClass("field-with-errors")
    $(this).find(".feedback-holder").removeClass("error").addClass("alert alert-success")

    successMessage = "Assessment submitted"

    $(this).find(".feedback-holder").html(successMessage)
    $(this).find("input:submit").remove()

  $(document).on "click", ".form-save-link", (e) ->
    link = $(this)
    e.preventDefault()
    formGroup = link.closest(".govuk-form-group")
    form = formGroup.closest("form")
    area = formGroup.find("textarea:visible")

    if area.length > 1
      for _area in area
        LS.removeItem($(_area).data("autosave-key"))
    else
      LS.removeItem(area.data("autosave-key"))

    formGroup.removeClass("form-edit")

    if formGroup.find(".toggable-form .toggable-form__read p[data-for]").length > 0 # use manual mapping
      formGroup.find(".toggable-form .toggable-form__read p[data-for]").each ->
        $(this).html($("##{$(this).data("for")}").val())
      form.submit()
    else if area.length == 1
      if area.val().length
        formGroup.find(".toggable-form .toggable-form__read p").html(area.val().replace(/\n/g, '<br />'))
        updatedSection = link.data("updated-section")
        $(this).closest(".panel-body").find(".field-with-errors").removeClass("field-with-errors")
        $(this).closest(".panel-body").find(".feedback-holder.error").html("")
        $(this).closest(".panel-body").find(".feedback-holder").removeClass("error")
        formGroup.find("textarea").each ->
          if $(this).val().length
            $(this).closest(".input").removeClass("field-with-errors")
        if updatedSection
          input = form.find("input[name='updated_section']")
          if input.length
            input.val(updatedSection)
        form.submit()
    else
       if area.first().val().length
         formGroup.find(".toggable-form .toggable-form__read p:first").html(area.first().val().replace(/\n/g, '<br />'))
       if area.last().val().length
         formGroup.find(".toggable-form .toggable-form__read p:last").html(area.last().val().replace(/\n/g, '<br />'))
       form.submit()

  $("#new_review_audit_certificate input[type='radio']").on "change", ->
    area = $(".audit-cert-description")
    if $(this).val() == "confirmed_changes"
      area.removeClass("if-js-hide")
    else
      area.addClass("if-js-hide")

changeRagStatus = ->
  $(document).on "click", ".btn-rag .dropdown-menu a", (e) ->
    e.preventDefault()
    rag_clicked = $(this).closest("li").attr("class")
    rag_status = $(this).closest(".btn-rag").find(".dropdown-toggle")
    rag_status.removeClass("rag-neutral")
              .removeClass("rag-positive")
              .removeClass("rag-average")
              .removeClass("rag-negative")
              .removeClass("rag-blank")
              .addClass(rag_clicked)
    rag_status.find(".rag-text").text($(this).find(".rag-text").text())
    $(this).closest(".panel-body").find(".field-with-errors").removeClass("field-with-errors")
    $(this).closest(".panel-body").find(".feedback-holder.error").html("")
    $(this).closest(".panel-body").find(".feedback-holder").removeClass("error")

editFormAnswerAutoUpdate = ->
  $(".sic-code .form-save-link, .section-applicant-lieutenants .form-save-link").on "click", (e) ->
    e.preventDefault()
    e.stopPropagation()
    that = $("#form_answer_sic_code")
    form = $(e.currentTarget).closest(".edit_form_answer")
    $.ajax
      action: form.attr("action")
      data: form.serialize()
      method: "PATCH"
      dataType: "json"

      success: (result) ->
        formGroup = that.parents(".form-group")
        formGroup.removeClass("form-edit")
        formGroup.find(".form-value p").text(that.find("option:selected").text())
        sicCodes = result["form_answer"]["sic_codes"]
        counter = 1
        for row in $(".sector-average-growth td")
          $(row).text(sicCodes[counter.toString()])
          counter += 1
        $(".avg-growth-legend").text(result["form_answer"]["legend"])

        if result["form_answer"]["ceremonial_county_name"]
          $(".section-applicant-lieutenants .form-value").text(result["form_answer"]["ceremonial_county_name"])
          $("#form_answer_ceremonial_county_id").val(result["form_answer"]["ceremonial_county_id"])
          $(".section-applicant-lieutenants .form-edit").removeClass("form-edit")

bindRags =(klass) ->
  $(document).on "click", "#{klass} .btn-rag .dropdown-menu a", (e) ->
    e.preventDefault()
    ragClicked = $(this).closest("li").attr("class")
    ragClicked = ragClicked.replace("rag-", "")
    ragSection = $(this).parents(".form-group")
    form       = $(klass)
    ragSection.find("option").each ->
      if $(this).val() == ragClicked
        select = $(this).parents("select")
        select.val(ragClicked)
        section = select.data("updated-section")
        if section
          input = form.find("input[name='updated_section']")
          if input.length
            input.val(section)
    form.submit()

handleWinnersForm = ->
  removeAttendeeForm = ".remove-palace-attendee-form"
  addAttendeeForm    = ".palace-attendee-form"
  attendeeFormHolder = ".palace-attendee-container"

  $(document).on "ajax:success", attendeeFormHolder, (e, data, status, xhr) ->
    $(this).closest(attendeeFormHolder).replaceWith(data)

  $(document).on "click", ".remove-palace-attendee", (e) ->
    e.preventDefault()
    $(this).closest("form").submit()
    $(this).closest(".form-group").find(".empty-message").removeClass("visuallyhidden")

  $(document).on "ajax:success", removeAttendeeForm, (e, data, status, xhr) ->
    $(this).closest(attendeeFormHolder).remove()
    $(".attendees-forms").closest(".form-group").find(".empty-message").removeClass("visuallyhidden")
  $(document).on "click", ".add-another-attendee", (e) ->
    e.preventDefault()
    that = $(this)

    limit      = $(".attendees-forms").data("attendees-limit")
    visibleLen = $(".attendees-forms .list-attendees:visible").length
    if visibleLen < limit
      $.ajax
        type: "GET",
        url: that.attr("href")
        success: (data) ->
          $(".section-palace-attendees .panel-body").append(data)

          limit = $(".attendees-forms").data("attendees-limit")
          visibleLen = $(".attendees-forms .list-attendees:visible").length
          that.hide() if visibleLen >= limit
    else
      alert("You can not add more attendees")

handleCompanyDetailsForm = ->
  if $('.duplicatable-nested-form').length
    nestedForm = $('.duplicatable-nested-form').last().clone()
    $(".destroy_duplicate_nested_form:first").remove()
    $('.destroy_duplicate_nested_form').on 'click', (e) ->
      $(this).closest('.duplicatable-nested-form').slideUp().remove()

    $(document).on "click", ".add-previous-winning", (e) ->
      e.preventDefault()

      lastNestedForm = $('.duplicatable-nested-form').last()
      newNestedForm  = $(nestedForm).clone()
      formsOnPage    = $('.duplicatable-nested-form').length

      $(newNestedForm).find('label').each ->
        oldLabel = $(this).attr 'for'
        if oldLabel
          newLabel = oldLabel.replace(new RegExp(/_[0-9]+_/), "_#{formsOnPage}_")
          $(this).attr 'for', newLabel

      $(newNestedForm).find('select, input').each ->
        oldId = $(this).attr 'id'
        if oldId
          newId = oldId.replace(new RegExp(/_[0-9]+_/), "_#{formsOnPage}_")
          $(this).attr 'id', newId

        oldName = $(this).attr 'name'
        if oldName
          newName = oldName.replace(new RegExp(/\[[0-9]+\]/), "[#{formsOnPage}]")
          $(this).attr 'name', newName
      newNestedForm.find(".duplicatable-nested-form").removeClass("if-js-hide")
      $( newNestedForm ).insertAfter( lastNestedForm )

  $(document).on "ajax:success", ".company-details-forms form", (e, data, status, xhr) ->
    closest_form_group = $(this).closest(".form-group")
    if closest_form_group.hasClass("form-group-multiple")
      $(this).closest(".form-group-multiple-parent").replaceWith($(data))
    else
      closest_form_group.replaceWith($(data))

  $(".company-details-forms").on "click", ".remove-link", (e) ->
    e.preventDefault()
    parent = $(this).closest(".duplicatable-nested-form")
    parent.find("input[type='checkbox']").prop("checked", "checked")
    parent.hide()

  $(".previous-wins").on "click", ".form-save-link", (e) ->
    e.preventDefault()
    $(this).closest("form").submit()

  $(document).on "click", ".form-cancel-link", (e) ->
    e.preventDefault()
    $(this).closest(".form-edit").removeClass("form-edit")

handleReviewAuditCertificate = ->
  $("#new_review_audit_certificate").on "ajax:success", (e, data, status, xhr) ->
    $(this).find(".form-group").removeClass("form-edit")
    $(".save-review-audit").hide()
    area = $(".audit-cert-description textarea")
    confirmedChanges = $("#radio-audit-cert2")
    unless confirmedChanges.prop("checked")
      $(this).find(".form-value").html($("<p>No change necessary</p>"))
    else
      div = "<div><label>Changes made</label><p class='control-label'>#{area.val()}</p></div>"
      $(this).find(".form-value").html(div)
  $("#new_review_audit_certificate").on "click", ".save-review-audit", (e) ->
    e.preventDefault()
    $("#new_review_audit_certificate").submit()

  $(".edit-review-audit").on "click", (e) ->
    $(".save-review-audit").show()

handleRemovingOfAuditCertificate = ->
  $(document).on "click", ".js-remove-audit-certificate-link", (e) ->
    $(this).closest("form").submit()
    return false

$(document).ready(ready)

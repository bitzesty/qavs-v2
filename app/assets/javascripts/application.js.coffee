#= require jquery3
#= require jquery-ujs
#= require vendor/file_upload/jquery.ui.widget
#= require vendor/file_upload/jquery.iframe-transport
#= require vendor/file_upload/jquery.fileupload
#= require vendor/file_upload/jquery.fileupload-process
#= require vendor/file_upload/jquery.fileupload-validate
#= require ./ckeditor/config.js
#= require Countable
#= require moment.min
#= require core
#= require libs/suchi/isOld.js
#= require libs/pusher.min.js
#= require mobile
#= require browser-check
#= require vendor/zxcvbn
#= require vendor/accessible-autocomplete.min
#= require vendor/jquery-debounce
#= require vendor/details.polyfill.js
#= require js.cookie
#= require_tree ./frontend
#= require offline

ordinal = (n) ->
  nHundreds = n % 100
  nDecimal = n % 10

  if nHundreds in [11, 12, 13]
    return n + "th"
  else
    if nDecimal is 1
      return n + "st"
    else if nDecimal is 2
      return n + "nd"
    else if nDecimal is 3
      return n + "rd"

    return n + "th"

jQuery ->
  $("html").removeClass("no-js")

  offlineCheck = new Offline
  offlineCheck.start()

  # This is a very primitive way of testing.
  # Should be refactored once forms stabilize.
  #
  # TODO: Refactor this later on
  validate = ->
    window.FormValidation.validate()

  window.changesUnsaved = false

  window.FormValidation.hookIndividualValidations()

  $(document).on "submit", ".qae-form", (e) ->
    $("body").addClass("tried-submitting")
    if not validate()
      $("body").addClass("show-error-page")
      $(".steps-progress-bar .step-current").removeClass("step-current")
      $("html, body").animate(
        scrollTop: 0
      , 0)
      return false

  # Hidden hints as seen on
  # https://www.gov.uk/service-manual/user-centred-design/resources/patterns/help-text
  # Creates the links and adds the arrows
  $(".hidden-link").wrap("<a href='#'></a>")
  # Adds the arrows
  $(".hidden-link").closest("a").prepend("<span class='hidden-arrow-right'>▶</span><span class='hidden-arrow-down'>▼</span>")
  # Adds click event to links
  $(document).on "click", ".hidden-hint a", (e) ->
    e.preventDefault()
    e.stopPropagation()

    $(this).closest(".hidden-hint").toggleClass("show-hint")

  $(document).on "click", ".hidden-link-for", (e) ->
    e.preventDefault()
    link_href = $(this).attr("href").substr(1)
    hidden_link = $(this).closest(".question-block").find("."+link_href)
    hidden_link.toggleClass("show-hint")

  $(".supporters-list input").change ->
    $(this).closest("label").find(".govuk-error-message").empty()
    $(this).closest(".govuk-form-group--error").removeClass("govuk-form-group--error")

  # Conditional questions that appear depending on answers
  $(".js-conditional-question, .js-conditional-drop-question").addClass("conditional-question")
  # Simple conditional using a == b
  simpleConditionalQuestion = (input, clicked) ->
    answer = input.closest(".js-conditional-answer").attr("data-answer")
    question = $(".conditional-question[data-question='#{answer}']")
    isCheckbox = input.attr('type') == 'checkbox'
    checkboxVal = input.val()
    answerVal = if isCheckbox then input.is(':checked').toString() else input.val()
    boolean_values = ["0", "1", "true", "false"]
    values = input.closest(".govuk-form-group").find("input[type='checkbox']").filter(":checked").map(() -> $(@).val()).toArray()

    question.each () ->
      nonBooleanCheckboxMeetsCriteria = isCheckbox && $(this).attr('data-value') in values
      if $(this).attr('data-value') == answerVal || nonBooleanCheckboxMeetsCriteria || ($(this).attr('data-value') == "true" && (answerVal != 'false' && answerVal != false)) || ($(this).attr('data-type') == "in_clause_collection" && $(this).attr('data-value') <= answerVal)
        if clicked || (!clicked && input.attr('type') == 'radio' && input.is(':checked')) || (!clicked && input.attr('type') != 'radio')
          $(this).addClass("show-question")
      else
        if clicked || (!clicked && input.attr('type') != 'radio')
          $(this).removeClass("show-question")
  $(".js-conditional-answer input, .js-conditional-answer select").each () ->
    simpleConditionalQuestion($(this), false)
  $(".js-conditional-answer input, .js-conditional-answer select").change () ->
    setTimeout((() =>
      simpleConditionalQuestion($(this), true)
    ), 50)
  # Numerical conditional that checks that trend doesn't ever drop
  dropConditionalQuestion = (input) ->
    drop_question_ids = input.closest(".js-conditional-drop-answer").attr('data-drop-question')
    drop = false

    $(".js-conditional-drop-answer[data-drop-question='#{drop_question_ids}']").each () ->
      drop_answers = $(this).closest(".js-conditional-drop-answer")
      last_val = Math.log(0) # -Infinity

      drop_answers.find("input").each () ->
        if $(this).val()
          value = parseFloat $(this).val()
          if value < last_val || value < 0
            drop = true
          last_val = value

    $.each drop_question_ids.split(','), (index, id) ->
      parent_q = $(".js-conditional-answer[data-answer='#{id}']").closest(".js-conditional-drop-question")

      if drop
        parent_q.addClass("show-question")
      else
        parent_q.removeClass("show-question")

  $(".js-conditional-drop-answer input").each () ->
    dropConditionalQuestion($(this))
  $(".js-conditional-drop-answer input").change () ->
    dropConditionalQuestion($(this))

  # Get the latest financial year date from input
  updateYearEndInput = () ->
    fy_latest_changed_input = $(".js-financial-year-changed-dates .fy-latest .date-input")
    fy_latest_changed_input.find("input").removeAttr("disabled")

    fy_day = $('.js-financial-year-latest .js-fy-day select').val()
    fy_month = $('.js-financial-year-latest .js-fy-month select').val()

    if gon?
      fy_year = gon.base_year || new Date().getFullYear()
    else
      fy_year = new Date().getFullYear()

    # Conditional latest year
    # If from 12th of September to December -> then previous year
    # If from January to 12th of September -> then current year
    if (parseInt(fy_month, 10) == 9 && parseInt(fy_day, 10) >= 13) || parseInt(fy_month, 10) > 9
      fy_year = parseInt(fy_year, 10) - 1

    # Updates the latest changed financial year input
    fy_latest_changed_input.find("input.js-fy-day").val(fy_day)
    fy_latest_changed_input.find("input.js-fy-month").val(fy_month)

    # disabled for 2021
    # Auto fill the year for previous years
    # $(".js-financial-year-changed-dates .js-fy-entries").each ->
    #  if $(this).find("input.js-fy-year").val() == ""
    #    parent_fy = $(this).parent().find(".js-fy-entries")
    #    this_year = fy_year - (parent_fy.length - parent_fy.index($(this)) - 1)
    #    $(this).find("input.js-fy-year").val(this_year)

    # fy_latest_changed_input.find("input").attr("disabled", "disabled")
    # $(".js-financial-year-changed-dates").attr("data-year", fy_year)

    # We should change the last year date regardless if it's present or not
    # fy_latest_changed_input.find("input.js-fy-year").val(fy_year)

    updateYearEnd()

  # Update the financial year labels
  updateYearEnd = () ->
    $(".js-financial-conditional .js-year-end").removeClass("show-default")

    if $(".js-financial-year-change input:checked").val() == "no"
      # Year end hasn't changed, auto select the year
      fy_latest_changed_input = $(".js-financial-year")
      fy_latest_day = fy_latest_changed_input.find(".js-fy-day select").val()
      fy_latest_month = fy_latest_changed_input.find(".js-fy-month select").val()
      fy_latest_year = $(".js-financial-year-changed-dates").attr("data-year")

      if !fy_latest_day || !fy_latest_month || !fy_latest_year
        $(".js-year-end").addClass("show-default")
      else
        $(".js-year-end").each ->
          year = parseInt(fy_latest_year) + parseInt($(this).attr("data-year").substr(0, 1)) - parseInt($(this).attr("data-year").substr(-1, 1))
          pre_text = "Year ending in"
          if $(this).closest(".question-block").hasClass("total-net-assets")
            pre_text = "As at"
          $(this).find(".js-year-text").text("#{pre_text} #{fy_latest_day}/#{fy_latest_month}/#{year}")
    else
      # Year has changed, use what they've inputted
      $(".js-financial-conditional > .by-years-wrapper").each ->
        all_years_value = true
        $(this).find(".js-year-end").each ->
          fy_input = $(".js-financial-year-changed-dates .js-year-end[data-year='#{$(this).attr("data-year")}']").closest(".js-fy-entries").find(".date-input")
          fy_day = fy_input.find(".js-fy-day").val()
          fy_month = fy_input.find(".js-fy-month").val()
          fy_year = fy_input.find(".js-fy-year").val()

          if !fy_day || !fy_month || !fy_year
            all_years_value = false
        if !all_years_value
          $(this).find(".js-year-end").addClass("show-default")
        else
          $(this).find(".js-year-end").each ->
            fy_input = $(".js-financial-year-changed-dates .js-year-end[data-year='#{$(this).attr("data-year")}']").closest(".js-fy-entries").find(".date-input")
            fy_day = fy_input.find(".js-fy-day").val()
            fy_month = fy_input.find(".js-fy-month").val()
            fy_year = fy_input.find(".js-fy-year").val()
            pre_text = "Year ending in"
            if $(this).closest(".question-block").hasClass("total-net-assets")
              pre_text = "As at"
            $(this).find(".js-year-text").text("#{pre_text} #{fy_day}/#{fy_month}/#{fy_year}")

  updateYearEndInput()
  $(".js-financial-year select").change () ->
    updateYearEndInput()
  $(".js-financial-year-latest").closest(".question-block").next().find("input").change () ->
    updateYearEnd()

  # Calculates the UK Sales for Sus Dev form
  # UK sales = turnover - exports
  updateTurnoverExportCalculation = ->
    $(".js-sales-value").each ->
      sales_year = $(this).data("year")
      turnover_data = $(this).data("turnover")
      exports_data = $(this).data("exports")
      turnover_selector = "[id='form["+turnover_data+"_"+sales_year+"]']"
      exports_selector = "[id='form["+exports_data+"_"+sales_year+"]']"
      $("#{turnover_selector}, #{exports_selector}").each ->
        $(this).attr("data-year", sales_year)
      $(document).on "change", "#{turnover_selector}, #{exports_selector}", ->
        sales_year = $(this).data("year")
        turnover_selector = "[id='form["+turnover_data+"_"+sales_year+"]']"
        exports_selector = "[id='form["+exports_data+"_"+sales_year+"]']"
        sales_selector = ".js-sales-value[data-year='"+sales_year+"']"
        sales_value = parseInt($(turnover_selector).val().replace(/,/g, '')) - parseInt($(exports_selector).val().replace(/,/g, ''))
        if sales_value
          $(sales_selector).text(sales_value)
        else
          $(sales_selector).text("0")

  updateTurnoverExportCalculation()

  replaceCommasInFinancialData = ->
    $(document).on "change", "input.js-form-financial-data", ->
      formatted_value = $(this).val().replace(/,/g, '')
      $(this).val(formatted_value)

  replaceCommasInFinancialData()

  # Show/hide the correct step/page for the award form
  showAwardStep = (step) ->
    $("body").removeClass("show-error-page")

    $(".js-step-condition.step-current").removeClass("step-current")

    window.location.hash = "##{step.substr(5)}"
    $(".js-step-condition[data-step='#{step}']").addClass("step-current")
    $(".js-step-condition[data-step='#{step}']").focus()

    # Show past link status
    $(".steps-progress-bar .js-step-link.step-past").removeClass("step-past")

    current_index = $(".steps-progress-bar .js-step-link").index($(".steps-progress-bar .step-current"))
    $(".steps-progress-bar .js-step-link").each () ->
      this_index = $(".steps-progress-bar .js-step-link").index($(this))
      if this_index < current_index
        $(this).addClass("step-past")

    # Setting current_step_id to form as we updating only current section form_data (not whole form)
    $("#current_step_id").val(step)

  if window.location.hash
    step = window.location.hash.substr(1)
    if $(".js-step-condition[data-step='step-#{step}']").length > 0
      showAwardStep("step-#{step}")
      # Resize textareas that were previously hidden
      resetResizeTextarea()
    else
      window.location.hash = $(".js-step-condition.step-current").attr("data-step").substr(5)

      # Setting current_step_id to form as we updating only current section form_data (not whole form)
      $("#current_step_id").val(step)

  $(".qae-form").on "submit", (e) ->
    if window.changesUnsaved
      e.preventDefault()
      e.stopPropagation()

      autosave ->
        $(".steps-progress-content .step-current button[type='submit']").click()

  #
  # In case if was attempt to submit and validation errors are present
  # then we are passing validate_on_form_load option
  # in order to show validation errors to user after redirection
  #
  if window.location.href.search("validate_on_form_load") > 0
    validate()

  $(document).on "click", "a.js-step-link, .js-step-link button[type='submit']", (e) ->
    e.preventDefault()
    e.stopPropagation()

    current_step = if $(this).attr('data-step') isnt undefined
      $(this).attr("data-step")
    else
      $(this).closest(".js-step-link").attr("data-step")

    window.FormValidation.validateStep() unless $(this).hasClass("bypass-validations")

    #
    # Make a switch to next section if this is not same tab only
    #
    if current_step != $(".js-step-link.step-current").attr('data-step')

      # If there are more than one one-time form collaborator
      #
      if ApplicationCollaboratorsGeneralRoomTracking.there_are_other_collaborators_here()
        CollaboratorsLog.log("[COLLABORATOR MODE] ----------------------- ")
        ApplicationCollaboratorsEditorBar.show_loading_bar()

        #
        # Getting url of next section to show
        #
        if $(this).prop("tagName") == "A"
          redirect_url = $(this).attr("href")
        else
          redirect_url = $("li.js-step-link.step-current").next().find("a").attr('href')

        #
        # System will redirect normal (NON AJAX) request
        # to "add-website-address-documents" step into related NON JS section
        # so that we need to pass extra 'no_redirect' option in this case
        #
        redirect_url += "&form_refresh=true"

        #
        # In case if was attempt to submit and validation errors are present
        # then we are passing validate_on_form_load option
        # in order to show validation errors to user after redirection
        #
        if window.location.href.search("validate_on_form_load") > 0 ||
           $(this).closest(".js-review-sections").length > 0 ||
           $(this).hasClass("step-errors")
          redirect_url += "&validate_on_form_load=true"

        CollaboratorsLog.log("[COLLABORATOR MODE] ------------ redirect_url ----------- " + redirect_url)

        if ApplicationCollaboratorsAccessManager.does_im_current_editor()
          CollaboratorsLog.log("[COLLABORATOR MODE] -------------I'm EDITOR---------- SAVE AND REDIRECT")
          # If I'm current editor
          # -> then save form data and once it saved redirect me to proper section in a callback
          #
          save_form_data ->
            window.location.href = redirect_url
        else
          CollaboratorsLog.log("[COLLABORATOR MODE] -------------I'm NOT EDITOR---------- REDIRECT TO TAB")
          # If I'm not editor
          # -> then just redirect to target section
          #
          window.location.href = redirect_url

      else
        CollaboratorsLog.log("[STANDART MODE] ----------------------- ")

        autosave() unless $(this).hasClass('.bypass-autosave')

        if $(this).hasClass "js-next-link"
          if $("body").hasClass("tried-submitting")
            validate()

        showAwardStep(current_step)

        # Scroll to top
        $("html, body").animate(
          scrollTop: 0
        , 0)

        # Resize textareas that were previously hidden
        resetResizeTextarea()

  $(document).on "click", ".save-quit-link a", (e) ->
    if window.changesUnsaved
      e.preventDefault()
      e.stopPropagation()

      link = $(@).attr("href")

      $(@).text("Saving...")

      autosave ->
        window.location.href = link

  save_form_data = (callback) ->
    url = $('form.qae-form').data('autosave-url')

    if url
      # Setting current_step_id to form as we updating only current section form_data (not whole form)
      $("#current_step_id").val($(".js-step-condition.step-current").attr("data-step"))

      form_data = $('form.qae-form').serialize()

      $.ajax({
        url: url
        data: form_data
        type: 'POST'
        dataType: 'json'
        success: ->
          window.changesUnsaved = false
          if callback isnt undefined
            callback()
        error: (e) ->
          # tricking onbeforereload
          window.changesUnsaved = false
          window.location.reload()
      })

  autosave = (callback) ->
    window.autosave_timer = null
    autosave_enabled = true

    if ApplicationCollaboratorsGeneralRoomTracking.there_are_other_collaborators_here() &&
       ApplicationCollaboratorsAccessManager.im_in_viewer_mode()
      #
      # If there are more than once collaborator for this form application
      #    and I'm not in editor mode of current form section
      #
      # Then autosave request should be disabled
      #
      autosave_enabled = false

    # Assessor viewing form, autosave should be disabled
    if $(".page-read-only-form").length > 0
      autosave_enabled = false

    if autosave_enabled
      save_form_data(callback)
    #TODO: indicators, error handlers?

  loseChangesMessage = "You have unsaved changes! If you leave the page now, some answers will be lost. Stay on the page for a minute in order for everything to be saved or use the buttons at the bottom of the page."

  window.onbeforeunload = ->
    if !$(".page-read-only-form").length
      if window.changesUnsaved then loseChangesMessage else undefined

  if window.addEventListener isnt undefined
    window.addEventListener "beforeunload", (e) ->
      return undefined unless window.changesUnsaved

      e.returnValue = loseChangesMessage
      loseChangesMessage

  triggerAutosave = (e) ->
    window.autosave_timer ||= setTimeout( autosave, 1000 )

  raiseChangesFlag = ->
    window.changesUnsaved = true

  debounceTime = 20000
  $(document).debounce "change", ".js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "keyup", "input[type='text'].js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "keyup", "input[type='number'].js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "keyup", "input[type='url'].js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "keyup", "input[type='tel'].js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "change", "textarea.js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "focusout", ".js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag

  updateUploadListVisiblity = (list, button, max) ->
    list_elements = list.find("li")
    count = list_elements.length
    wrapper = button.closest('div.js-upload-wrapper')

    if count > 0
      list.removeClass("govuk-!-display-none")

    if !max || count < max
      button.removeClass("govuk-!-display-none")
    else
      button.addClass("govuk-!-display-none")

  reindexUploadListInputs = (list) ->
    idx = 0
    list.find("li").each (i, li) ->
      process_input = (j, input_el) ->
        name = $(input_el).attr("name")
        match = /([^\[]+)\[([^\]]+)\]\[([0-9]*)\](.*)/.exec name
        if match
          $(input_el).attr("name", "#{match[1]}[#{match[2]}][#{idx}]#{match[4]}")

      $(li).find("input").each process_input
      $(li).find("textarea").each process_input
      idx++

  appendRemoveLinkForWebsiteLink = (div) ->
    remove_link = $("<a>").addClass("remove-link").prop("href", "#").text("Remove")
    div.append(remove_link)

  appendRemoveLinkForAttachment = (div, wrapper, data) ->
    attachment_id = data.result['id']
    form_answer_id = data.result['form_answer_id']
    list_namespace = wrapper.attr("data-list-namespace")
    destroy_url = "/form/form_answers/" + form_answer_id + "/" + list_namespace + "/" + attachment_id

    remove_link = $("<a>").addClass("remove-link")
                          .prop("href", destroy_url)
                          .attr("data-method", "delete")
                          .attr("data-remote", "true")
                          .text("Remove")
    div.append(remove_link)

  $('.js-file-upload').each (idx, el) ->
    form = $(el).closest('form')
    attachments_url = form.data 'attachments-url'
    $el = $(el)

    wrapper = $el.closest('div.js-upload-wrapper')
    button = wrapper.find(".js-button-add")
    list = wrapper.find('.js-uploaded-list')

    max = wrapper.data('max-attachments')
    name = wrapper.data('name')
    form_name = wrapper.data('form-name')
    needs_description = !!wrapper.data('description')
    has_filename = !!wrapper.data('filename')
    is_link = !!$el.data('add-link')

    $el.on "focus", ->
      button.addClass("onfocus")

    $el.on "blur", ->
      button.removeClass("onfocus")

    progress_all = (e, data) ->
      # TODO

    upload_started = (e, data) ->
      # Show `Uploading...`
      button.addClass("govuk-!-display-none")
      new_el = $("<li class='js-uploading'>")
      div = $("<div>")
      label = $("<label>").text("Uploading...")
      div.append(label)
      new_el.append(div)
      list.append(new_el)
      list.removeClass("govuk-!-display-none")
      wrapper.removeClass("govuk-form-group--error")
      wrapper.find(".govuk-error-message").empty()

    success_or_error = (e, data) ->
      errors = data.result.errors

      if errors
        failed(errors.toString())
      else
        upload_done(e, data)

    failed = (error_message) ->
      if error_message
        wrapper.addClass("govuk-form-group--error")
        wrapper.find(".govuk-error-message").html(error_message)

      # Remove `Uploading...`
      list.find(".js-uploading").remove()
      list.removeClass("govuk-!-display-none")
      button.removeClass("govuk-!-display-none")

    upload_done = (e, data, link) ->
      # Remove `Uploading...`
      list.find(".js-uploading").remove()
      list.addClass("govuk-!-display-none")
      wrapper.removeClass("govuk-form-group--error")
      wrapper.find(".govuk-error-message").empty()

      # Show new upload
      new_el = $("<li>")

      if link
        div = $("<div>")
        label = $("<label>").text('Website address')
        input = $("<input class=\"medium js-trigger-autosave\" type=\"text\">").
          prop('name', "#{form_name}[#{name}][][link]")
        label.append(input)
        appendRemoveLinkForWebsiteLink(div)
        div.append(label)
        new_el.append(div)
      else
        new_el.addClass("js-file-uploaded")

        if has_filename
          filename = wrapper.data('filename')
        else
          if data.result['original_filename']
            filename = data.result['original_filename']
          else
            filename = "File uploaded"
        div = $("<div>").text(filename)

        hidden_input = $("<input type='hidden' name='#{form_name}[#{name}][][file]' value='#{data.result['id']}' />")

        div.append(hidden_input)
        appendRemoveLinkForAttachment(div, wrapper, data)
        new_el.append(div)

      if needs_description
        desc_div = $("<div>")
        unique_name = "#{form_name}[#{name}][][description]"
        label = ($("<label>").text("Description").attr("for", unique_name))
        label.append($("<textarea class='js-char-count js-trigger-autosave' rows='2' maxlength='600' data-word-max='100'>")
             .attr("name", unique_name)
             .attr("id", unique_name))
        desc_div.append(label)
        new_el.append(desc_div)

      list.append(new_el)
      new_el.find("textarea").val("")
      new_el.find('.js-char-count').charcount()
      list.removeClass('govuk-!-display-none')
      updateUploadListVisiblity(list, button, max)
      reindexUploadListInputs(list)

    updateUploadListVisiblity(list, button, max)

    if is_link
      $el.click (e) ->
        e.preventDefault()
        if !$(this).hasClass("read-only")
          upload_done(null, null, true)
        false
    else
      $el.fileupload(
        url: attachments_url + ".json"
        forceIframeTransport: true
        dataType: 'json'
        formData: [
          {
            name: "authenticity_token",
            value: $("meta[name='csrf-token']").attr("content")
          },
          {
            name: "question_key",
            value: $el.data("question-key")
          }
        ]
        progressall: progress_all
        send: upload_started
        always: success_or_error
      )

  $(document).on "click", ".js-upload-wrapper .remove-link", (e) ->
    e.preventDefault()

    if !$(this).hasClass("read-only")
      li = $(this).closest 'li'
      list = li.closest(".js-uploaded-list")
      wrapper = list.closest(".js-upload-wrapper")
      button = wrapper.find(".js-button-add")
      max = wrapper.data('max-attachments')

      li.remove()
      updateUploadListVisiblity(list, button, max)
      reindexUploadListInputs(list)
      triggerAutosave()
      false

  # Show current holder info when they are a current holder on basic eligibility current holder question
  if $(".eligibility_current_holder").length > 0
    $(".eligibility_current_holder input").change () ->
      if $(this).val() == "true"
        $("#current-holder-info").removeClass("govuk-!-display-none")
      else
        $("#current-holder-info").addClass("govuk-!-display-none")

  # Show innovation amount info when the amount is greater than 1 on innovation eligibility
  if $(".innovative_amount_input").length > 0
    $(".innovative_amount_input").bind "propertychange change click keyup input paste", ->
      if $(this).val() > 1
        $("#innovative-amount-info").removeClass("govuk-!-display-none")
      else
        $("#innovative-amount-info").addClass("govuk-!-display-none")

  # Show text about submitting multiple applications when the number of eligible initiatives is greater than 1
  if $(".number_of_eligible_initiatives_input").length > 0
    $(".number_of_eligible_initiatives_input").bind "propertychange change click keyup input paste", ->
      if $(this).val() > 1
        $("#number-of-eligible-initiatives-info").removeClass("govuk-!-display-none")
      else
        $("#number-of-eligible-initiatives-info").addClass("govuk-!-display-none")

  # Show the eligibility failure contact message
  if $("#basic-eligibility-failure-submit").length > 0
    $(document).on "click", "#basic-eligibility-failure-submit", (e) ->
      e.preventDefault()
      if $(this).closest("form").find("input:checked").val()
        $("#basic-eligibility-failure-answered").addClass("govuk-!-display-none")
        $("#basic-eligibility-failure-show").removeClass("govuk-!-display-none")

  # Change your eligibility answers for award eligibility
  if $(".award-finish-previous-answers").length > 0
    $(document).on "click", ".award-finish-previous-answers a", (e) ->
      e.preventDefault()
      $("#form_eligibility_show").addClass("govuk-!-display-none")
      $("#form_eligibility_questions").removeClass("govuk-!-display-none")

  $(".question-block .js-button-add").each ->
    question = $(this).closest(".question-block")
    add_limit_attr = question.find(".list-add").attr("data-add-limit")
    li_size = question.find(".list-add > li:visible").length

    if ((typeof(add_limit_attr) != typeof(undefined)) && add_limit_attr != false)
      if li_size + 1 > add_limit_attr
        question.find(".js-button-add").addClass("govuk-!-display-none")

  # Clicking `+ Add` on certain questions add fields
  $(document).on "click", ".question-block .js-button-add", (e) ->
    e.preventDefault()
    e.stopPropagation()

    if !$(this).hasClass("read-only")
      entity = $(this).data("entity")
      question = $(this).closest(".question-block")
      add_eg = question.find(".js-add-example").html()

      if question.find(".list-add").length > 0
        can_add = true

        # Are there add limits
        add_limit_attr = question.find(".list-add").attr("data-add-limit")

        li_size = question.find(".list-add > li:visible").length

        if ((typeof(add_limit_attr) != typeof(undefined)) && add_limit_attr != false)

          if li_size >= add_limit_attr
            can_add = false

          if li_size + 1 >= add_limit_attr
            question.find(".js-button-add").addClass("govuk-!-display-none")

        if can_add
          highest_index = 0
          question.find(".list-add > li:visible").each ->
            name = $(this).find(".js-system-tag").data('new-hidden-input-name')
            p = name.split('form[supporter_letters_list][')
            p2 = p[1].split(']')
            index = parseInt(p2[0], 10)
            highest_index = Math.max(highest_index, index)

          new_index = highest_index + 1
          add_eg = add_eg.replace(/((\w+|_)\[(\w+|_)\]\[)(\d+)\]/g, "$1#{new_index}]")
          add_eg = add_eg.replace(/((\w+|_)\[(\w+|_)\]\[)(\{index\})\]/g, "$1#{new_index}]")

          question.find(".list-add").append("<li class='js-add-example js-list-item'>#{add_eg}</li>")
          question.find(".list-add").find("li:last-child input").prop("disabled", false)
          question.find(".list-add").find("li:last-child .js-save-collection").prop("disabled", false)

          idx = question.find(".list-add").find("> li").length

          question.find(".list-add").find("li:last-child .remove-link").attr("aria-label", "Remove " + ordinal(idx) + " " + entity)
          clear_example = question.find(".list-add").attr("data-need-to-clear-example")
          if (typeof(clear_example) != typeof(undefined) && clear_example != false)
            question.find(".list-add li.js-list-item:last .govuk-error-message").empty()
            clearFormElements(question.find(".list-add li.js-list-item:last"))

          # If .js-add-example has file field (like in SupportLetters)
          # Then we also need to clean filename and init fileupload
          example_has_file_field = question.find(".list-add").attr("data-example-has-file-field")
          if (typeof(example_has_file_field) != typeof(undefined) && example_has_file_field != false)
            SupportLetters.new_item_init(question.find(".list-add li.js-list-item:last"))

          # charcount needs to be reinitialized
          if (textareas = question.find(".list-add > li:last .js-char-count")).length
            textareas.removeCharcountElements()
            textareas.charcount()

          # remove the default reached class to allow removing again
          questionAddDefaultReached(question.find(".list-add"))

          triggerAutosave()

  # Removing these added fields
  $(document).on "click", ".govuk-form-group .list-add .js-remove-link", (e) ->
    e.preventDefault()
    if !$(this).hasClass("read-only")
      parent_ul = $(this).closest("ul")
      $(this).closest(".govuk-form-group")
             .find(".js-button-add")
             .removeClass("govuk-!-display-none")

      if $(this).hasClass("remove-supporter")

        url = $(this).data('url')
        if url && url != '#'
          $.ajax
            url: url
            type: 'DELETE'

      if $(this).data("remove-association")
        $(this).closest("li").addClass("govuk-!-display-none")
        $("input.remove", $(this).closest("li")).val("1")
      else
        $(this).closest("li").remove()

      questionAddDefaultReached(parent_ul)
      window.FormValidation.validateStep()
      triggerAutosave()

  questionAddDefaultReached = (ul) ->
    if ul.length > 0
      attr = ul.attr("data-default")
      hasAttrDefault = false

      if typeof attr != typeof undefined && attr != false
        hasAttrDefault = true

      if hasAttrDefault
        ul.removeClass("js-default-reached")
        if ul.find("li").not(".hidden").length <= attr
          ul.addClass("js-default-reached")

  $(".list-add").each ->
    questionAddDefaultReached($(this))

  # Disable copying in input fields
  $('.js-disable-copy').bind "cut copy contextmenu", (e) ->
    e.preventDefault()

  $(".js-entry-period input").change () ->
    replaceEntryPeriodText()
    FormValidation.validateStep("step-company-information")

  # Auto tab on date input entry
  #$(".date-input input").on 'keyup', (e) ->
  #  this_label = $(this).closest("label")
  #  new_input = ""
  #  # if it isn't the year input accept 2 numbers (48-57) or moving right (39)
  #  if this_label.index() != $(this).closest(".date-input").find("label:last-child").index()
  #    if (e.which >= 48 && e.which <= 57) || (e.which >= 96 && e.which <= 105) || e.keyCode == 39
  #      if $(this).val().length == 2
  #        # focus on the next input
  #        new_input = this_label.next().find("input")
  #  # if it isn't the day input you can go backwards by backspacing (8) or moving left (37)
  #  if this_label.index() != $(this).closest(".date-input").find("label:first-child").index()
  #    if e.keyCode == 8 || e.keyCode == 37
  #      if $(this).val().length == 0
  #        # focus on the next input
  #        new_input = this_label.prev().find("input")
  #  if new_input != ""
  #    new_input_text = new_input.val()
  #    new_input.val("")
  #    new_input.focus()
  #    new_input.val(new_input_text)

  # only accept numbers(48-47), backspace(8), tab(9), cursor keys left(37) and right(39) and enter for submitting
  $(".date-input input").on 'keypress keydown keyup', (e) ->
    if !((e.which >= 48 && e.which <= 57) || (e.which >= 96 && e.which <= 105) || e.keyCode == 8 || e.keyCode == 9 || e.keyCode == 37 || e.keyCode == 39 || e.keyCode == 13)
      e.preventDefault()
      return false

  # Remove alerts from registration page as soon as user starts typing
  $(".page-devise input").on 'keypress keydown keyup change', () ->
    $(this).closest(".field-with-errors").removeClass("field-with-errors")
    if $(this).closest(".form-inputs-group").length > 0
      $(this).closest(".form-inputs-group").find(".error").remove()
    else
      $(this).closest(".question-body").find(".error").remove()

  # Disable using enter key to submit on the form
  $("form .steps-progress-content").on 'keypress', (e) ->
    if e.keyCode == 13
      target = $(e.target)
      if !target.is("textarea") && !target.is(":button,:submit")
        $(this).find(":input:visible:not([disabled],[readonly]), a").each () ->
          return false
        return false

  # Dropdowns for nav
  $(document).on "click", ".dropdown > a", (e) ->
    e.preventDefault()
    $(this).closest(".dropdown").toggleClass("dropdown-open")
  $(document).on 'click', (e) ->
    if !$(e.target).closest('.dropdown').length
      $(".dropdown.dropdown-open").removeClass("dropdown-open")

  # Dropdowns for sidebar
  $(document).on "click", ".steps-progress-bar .dropdown-toggle", (e) ->
    e.preventDefault()
    $(this).closest("span").toggleClass("open")

  ongoingDateDuration()
  SupportLetters.init()
  AuditCertificatesUpload.init()

  if $(".js-press-comment-correct input:checked").val() == "true"
    $(".js-press-comment-feeback").addClass("section-confirmed")
  $(".js-press-comment-correct input").change ->
    $(".js-press-comment-feeback").removeClass("section-confirmed")
    if $(".js-press-comment-correct input:checked").val() == "true"
      $(".js-press-comment-feeback").addClass("section-confirmed")

  #
  # Init WYSYWYG editor for QAE Form textareas - begin
  #

  if $('.js-ckeditor').length > 0

    CKEDITOR.plugins.addExternal( 'wordcount', '/ckeditor/plugins/notification/plugin.js' );
    CKEDITOR.plugins.addExternal( 'wordcount', '/ckeditor/plugins/wordcount/plugin.js' );

    $('.js-ckeditor').each (index) ->
      group = $(this).closest(".govuk-form-group")

      spacer = $("<div class='js-ckeditor-spacer'></div>")
      spacer.insertAfter($(this).parent().find(".hint"))

      CKEDITOR.replace this,
        title: group.find('label').first().text(),
        language: 'en'
        toolbar_mini: [
          {name: 'p1', items: ["Cut", "Copy", "PasteText", "-", "Undo", "Redo"]},
          {name: 'p2', items: ["Bold", "Italic",  "-", "RemoveFormat"]},
          {name: 'p3', items: ["NumberedList", "BulletedList", "-", "Outdent", "Indent", "-", 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock']}
        ]
        toolbar: "mini";
        extraPlugins: 'wordcount'

        wordcount: {
          showParagraphs: false,
          showWordCount: true
        }

        removePlugins: 'link,elementspath,contextmenu,liststyle,tabletools,tableselection'
        disableNativeSpellChecker: false

        allowedContent: 'h1 h2 h3 blockquote p ul ol li em i strong b i br'
        height: 200
        wordcount:
          maxWordCount: $(this).data('word-max')
        versionCheck: false

      CKEDITOR.on 'instanceCreated', (event) ->
        editor = event.editor
        element = editor.element


      CKEDITOR.on 'instanceReady', (event) ->
        target_id = event.editor.name

        spinner = group.find(".js-ckeditor-spinner-block")
        spinner.addClass('govuk-!-display-none')

    for i of CKEDITOR.instances
      instance = CKEDITOR.instances[i]

      instance.on 'change', (event) ->
        target_id = event.editor.name
        element = CKEDITOR.instances[target_id]

        element.updateElement()
        raiseChangesFlag()

        $("#" + target_id).trigger("change")

        return

    TextareaCkeditorIeCallback.init()

  #
  # Init WYSYWYG editor for QAE Form textareas - end
  #


  #cookie settings

  if $('.cookie-settings').length > 0
    saveButton = document.querySelector('.save-cookie-settings')
    cookieForm = document.querySelector('.cookie-save-form')

    return if !saveButton

    analyticsConsent = Cookies.get('analytics_cookies_consent_status')

    if analyticsConsent is 'yes'
      document.getElementById('cookies-analytics-yes').checked = true
    if analyticsConsent is 'no'
      document.getElementById('cookies-analytics-no').checked = true

    cookieForm.addEventListener 'submit', (e) ->
      e.preventDefault()
      e.stopPropagation()

      analyticsRadio = document.querySelector('input[name="cookies-analytics"]:checked')
      analyticsValue = if analyticsRadio then analyticsRadio.value else null

      if analyticsValue
        Cookies.set('analytics_cookies_consent_status', analyticsValue, { expires: 365 })

      Cookies.set('general_cookie_consent_status', 'yes', { expires: 365 })

      existingMessage = document.querySelector('.save-cookie-message')

      if existingMessage
        existingMessage.parentNode.removeChild(existingMessage)

      message = document.createElement('p')
      message.classList.add('save-cookie-message')
      message.setAttribute('role', 'alert')
      message.innerHTML = 'Your cookie preferences were successfully saved. These preferences will be valid for 1 year.'
      saveButton.insertAdjacentElement('afterend', message)

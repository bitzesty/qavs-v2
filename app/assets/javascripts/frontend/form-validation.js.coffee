window.FormValidation =
  validates: true
  # validates numbers, including floats and negatives
  numberRegex: /^-?\d*\,?\d*\,?\d*\,?\d*\,?\d*\.?\,?\d*$/

  clearAllErrors: ->
    @validates = true
    $(".govuk-form-group--error").removeClass("govuk-form-group--error")
    $(".govuk-error-message").empty()
    $(".steps-progress-bar .js-step-link").removeClass("step-errors")

  clearErrors: (container) ->
    if container.closest(".question-financial").length > 0
      container.closest("label").find(".govuk-error-message").empty()
    else if container.closest('.question-block').data('answer') && container.closest('.question-block').data('answer').indexOf('address') > -1
      container.closest(".govuk-form-group").find(".govuk-error-message").empty()
    else
      container.closest(".question-block").find(".govuk-error-message").empty()
    container.closest(".govuk-form-group--error").removeClass("govuk-form-group--error")

  addErrorMessage: (question, message) ->
    @appendMessage(question, message)
    @addErrorClass(question)

    @validates = false

  appendMessage: (container, message) ->
    container.find(".govuk-error-message").first().append(message)
    @validates = false

  addErrorClass: (container) ->
    container.addClass("govuk-form-group--error")
    page = container.closest(".step-article")
    if !page.hasClass("step-errors")
      # highlight the error sections in sidebar and in error message
      $(".steps-progress-bar .js-step-link[data-step=#{page.attr('data-step')}]").addClass("step-errors")
      $(".js-review-sections").empty()
      $(".steps-progress-bar .step-errors a").each ->
        stepLink = $(this).parent().html()
        stepLink = stepLink.replace("step-errors", "").replace("step-current", "")
        $(".js-review-sections").append("<li>#{stepLink}</li>")

      # uncheck confirmation of entry
      $(".question-block[data-answer='entry_confirmation-confirmation-of-entry'] input[type='checkbox']").prop("checked", false)
    @validates = false

  isTextishQuestion: (question) ->
    question.find("input[type='text'], input[type='number'], input[type='password'], input[type='email'], input[type='url'], textarea").length

  isSelectQuestion: (question) ->
    question.find("select").length

  isOptionsQuestion: (question) ->
    question.find("input[type='radio']").length

  isCheckboxQuestion: (question) ->
    question.find("input[type='checkbox']").length

  toDate: (str) ->
    moment(str, "DD/MM/YYYY")

  compareDateInDays: (date1, date2) ->
    date = @toDate(date1)
    expected = @toDate(date2)

    date.diff(expected, "days")

  validateSingleQuestion: (question) ->
    if question.find("input, select").hasClass("not-required")
      return true
    else
      if @isSelectQuestion(question)
        return question.find("select").val()

      if @isTextishQuestion(question)
        return question.find("input[type='text'], input[type='number'], input[type='password'], input[type='email'], input[type='tel'], input[type='url'], textarea").val().toString().trim().length

      if @isOptionsQuestion(question)
        return question.find("input[type='radio']").filter(":checked").length

      if @isCheckboxQuestion(question)
        return question.find("input[type='checkbox']").filter(":checked").length

  validateRequiredQuestion: (question) ->
    # if it's a conditional question, but condition was not satisfied
    conditional = true

    question.find(".js-conditional-question").each ->
      if !$(this).hasClass("show-question")
        conditional = false

    if !conditional
      return

    subquestions = question.find(".govuk-form-group .govuk-form-group")

    if subquestions.length
      for subquestion in subquestions
        if not @validateSingleQuestion($(subquestion))
          @logThis(question, "validateRequiredQuestion", "This field is required")
          @addErrorMessage($(subquestion), "This field is required")
    else
      if not @validateSingleQuestion(question)
        @logThis(question, "validateRequiredQuestion", "This field is required")
        @addErrorMessage(question, "This field is required")

  validateMatchQuestion: (question) ->
    q = question.find(".match")
    matchName = q.data("match")

    if q.val() isnt $("input[name='#{matchName}']").val()
      @logThis(question, "validateMatchQuestion", "Emails don't match")
      @addErrorMessage(question, "Emails don't match")

  # regex source: https://stackoverflow.com/questions/46155/how-to-validate-an-email-address-in-javascript/13178771#13178771
  validateEmailQuestion: (question) ->
    val = String(question.find("input[type='email']").val()).toLowerCase()


    if not /^([a-zA-Z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+\/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?)$/.test(val) && val != ""
      @logThis(question, "validateEmailQuestion", "Not a valid email")
      @addErrorMessage(question, "Not a valid email")

  validateMaxDate: (question) ->
    val = question.find("input[type='text']").val()

    questionYear = parseInt(question.find(".js-date-input-year").val())
    questionMonth = parseInt(question.find(".js-date-input-month").val())
    questionDay = parseInt(question.find(".js-date-input-day").val())
    questionDate = "#{questionDay}/#{questionMonth}/#{questionYear}"

    if not val
      return

    expDate = question.data("date-max")
    diff = @compareDateInDays(questionDate, expDate)

    if not @toDate(questionDate).isValid()
      @logThis(question, "validateMaxDate", "Not a valid date")
      @addErrorMessage(question, "Not a valid date")
      return

    if diff > 0
      @logThis(question, "validateMaxDate", "Date cannot be after #{expDate}")
      @addErrorMessage(question, "Date cannot be after #{expDate}")

  validateDynamicMaxDate: (question) ->
    val = question.find("input[type='text']").val()

    questionYear = parseInt(question.find(".js-date-input-year").val())
    questionMonth = parseInt(question.find(".js-date-input-month").val())
    questionDay = parseInt(question.find(".js-date-input-day").val())
    questionDate = "#{questionDay}/#{questionMonth}/#{questionYear}"

    if not val
      return

    if !$(".js-entry-period input:checked").length
      return

    entryPeriodVal = $(".js-entry-period input:checked").val()

    if !entryPeriodVal
      return

    settings = question.data("dynamic-date-max")

    expDate = settings.dates[entryPeriodVal]

    diff = @compareDateInDays(questionDate, expDate)

    if not @toDate(questionDate).isValid()
      @logThis(question, "validateMaxDate", "Not a valid date")
      @addErrorMessage(question, "Not a valid date")
      return

    if diff > 0
      @logThis(question, "validateMaxDate", "Date cannot be after #{expDate}")
      @addErrorMessage(question, "Date cannot be after #{expDate}")

  validateMinDate: (question) ->
    val = question.find("input[type='text']").val()

    questionYear = parseInt(question.find(".js-date-input-year").val())
    questionMonth = parseInt(question.find(".js-date-input-month").val())
    questionDay = parseInt(question.find(".js-date-input-day").val())
    questionDate = "#{questionDay}/#{questionMonth}/#{questionYear}"

    if not val
      return

    expDate = question.data("date-min")
    diff = @compareDateInDays(questionDate, expDate)

    if not @toDate(questionDate).isValid()
      @logThis(question, "validateMinDate", "Not a valid date")
      @addErrorMessage(question, "Not a valid date")
      return

    if diff > 0
      @logThis(question, "validateMinDate", "Date cannot be before #{expDate}")
      @addErrorMessage(question, "Date cannot be before #{expDate}")

  validateBetweenDate: (question) ->
    val = question.find("input[type='text']").val()

    questionYear = parseInt(question.find(".js-date-input-year").val())
    questionMonth = parseInt(question.find(".js-date-input-month").val())
    questionDay = parseInt(question.find(".js-date-input-day").val())
    questionDate = "#{questionDay}/#{questionMonth}/#{questionYear}"

    if not val
      return

    dates = question.data("date-between").split(",")
    expDateStart = dates[0]
    expDateEnd = dates[1]
    diffStart = @compareDateInDays(questionDate, expDateStart)
    diffEnd = @compareDateInDays(questionDate, expDateEnd)

    if not @toDate(questionDate).isValid()
      @logThis(question, "validateBetweenDate", "Not a valid date")
      @addErrorMessage(question, "Not a valid date")
      return

    if diffStart < 0 or diffEnd > 0
      @logThis(question, "validateBetweenDate", "Date should be between #{expDateStart} and #{expDateEnd}")
      @addErrorMessage(question, "Date should be between #{expDateStart} and #{expDateEnd}")

  validateYear: (question) ->
    val = question.find("input")

    if not val
      return

    if not val.val().toString().match(@numberRegex)
      @logThis(question, "validateYear", "Not a valid year")
      @addErrorMessage(question, "Not a valid year")

    if parseInt(val.val()) < parseInt(val.prop("min")) || parseInt(val.val()) > parseInt(val.prop("max"))
      @logThis(question, "validateYear", "The year needs to be between 2000 and the current year. Any project that started before that would not be considered an innovation.")
      @addErrorMessage(question, "The year needs to be between 2000 and the current year. Any project that started before that would not be considered an innovation.")


  validateNumber: (question) ->
    val = question.find("input")

    if not val
      return

    if not val.val().toString().match(@numberRegex) && val.val().toString().toLowerCase().trim() != "n/a"
      @logThis(question, "validateNumber", "Not a valid number")
      @addErrorMessage(question, "Not a valid number")

  validateEmployeeMin: (question) ->
    for subquestion in question.find("input")
      shownQuestion = true
      for conditional in $(subquestion).parents('.js-conditional-question')
        if !$(conditional).hasClass('show-question')
          shownQuestion = false

      if shownQuestion
        subq = $(subquestion)
        if not subq.val() and question.hasClass("question-required")
          @logThis(question, "validateEmployeeMin", "This field is required")
          @appendMessage(subq.closest(".span-financial"), "This field is required")
          @addErrorClass(question)
          continue
        else if not subq.val()
          continue

        if not subq.val().toString().match(@numberRegex)
          @logThis(question, "validateEmployeeMin", "Not a valid number")
          @appendMessage(subq.closest(".span-financial"), "Not a valid number")
          @addErrorClass(question)
        else
          subqList = subq.closest(".row").find(".span-financial")
          subqIndex = subqList.index(subq.closest(".span-financial"))
          employeeLimit = 2

          if parseInt(subq.val()) < employeeLimit
            @logThis(question, "validateEmployeeMin", "Minimum of #{employeeLimit} employees")
            @appendMessage(subq.closest(".span-financial"), "Minimum of #{employeeLimit} employees")
            @addErrorClass(question)

  validateCurrentAwards: (question) ->
    $(".govuk-error-message", question).empty()

    for subquestion in question.find(".list-add li")
      errorText = ""
      $(subquestion).find("select, input, textarea").each ->
        if !$(this).val()
          fieldName = $(this).data("dependable-option-siffix")
          fieldName = fieldName[0].toUpperCase() + fieldName.slice(1)
          fieldError = "#{fieldName} can't be blank. "
          errorText += fieldError
      if errorText
        @logThis(question, "validateCurrentAwards", errorText)
        @appendMessage($(subquestion), errorText)
        @addErrorClass(question)

  validateDateStartEnd: (question) ->
    if question.find(".validate-date-start-end").length > 0
      rootThis = @
      question.find(".validate-date-start-end").each () ->
        # Whether we need to validate if date is ongoing
        if $(this).find(".validate-date-end input[disabled]").length == 0
          startYear = parseInt($(this).find(".validate-date-start .js-date-input-year").val())
          startMonth = parseInt($(this).find(".validate-date-start .js-date-input-month").val())
          startDate = "01/#{startMonth}/#{startYear}"

          endYear = parseInt($(this).find(".validate-date-end .js-date-input-year").val())
          endMonth = parseInt($(this).find(".validate-date-end .js-date-input-month").val())
          endDate = "01/#{endMonth}/#{endYear}"

          diff = rootThis.compareDateInDays(startDate, endDate)

          if not rootThis.toDate(startDate).isValid()
            rootThis.logThis(question, "validateDateStartEnd", "Not a valid date")
            rootThis.addErrorMessage($(this).find(".validate-date-start").closest("span"), "Not a valid date")

          else if not rootThis.toDate(endDate).isValid()
            rootThis.logThis(question, "validateDateStartEnd", "Not a valid date")
            rootThis.addErrorMessage($(this).find(".validate-date-end").closest("span"), "Not a valid date")

          else if diff > 0
            rootThis.logThis(question, "validateDateStartEnd", "Start date cannot be after end date")
            rootThis.addErrorMessage($(this), "Start date cannot be after end date")

        return

  validateDropBlockCondition: (question) ->

    if $("[name='form[financial_year_date_changed]']:checked").val() is "yes"
      return

    drop = false
    lastVal = 0

    $.each question.find(".currency-input input"), (index, el) ->
      if $(el).val() && (!$(el).closest(".conditional-question").length || $(el).closest(".conditional-question").hasClass("show-question"))
        value = parseFloat $(el).val()
        if value < lastVal
          drop = true
        lastVal = value

    if drop
      errorMessage = "Sorry, you are not eligible. \
      You must have constant growth in overseas sales for the entire entry period to be eligible \
      for a King's Award for Voluntary Service."
      @logThis(question, "validateDropBlockCondition", errorMessage)
      @addErrorMessage(question, errorMessage)
      return

  validateSupportLetters: (question) ->
    lettersReceived = $(".js-support-letter-received").length
    if lettersReceived < 2
      @logThis(question, "validateSupportLetters", "Upload two letters of support")
      @appendMessage(question, "Upload two letters of support")
      @addErrorClass(question)

  validateSelectionLimit: (question) ->
    selection_limit = question.data("selection-limit")
    current_selection_count = question.find("input[type=checkbox]:checked").length
    if selection_limit && current_selection_count > selection_limit
      @appendMessage(question, "Select a maximum of " + selection_limit)
      @addErrorClass(question)

  validateAddressQuestion: (question, triggeringElement) ->
    return unless triggeringElement
    if not @validateSingleQuestion(triggeringElement.closest('.govuk-form-group'))
      @logThis(question, "validateRequiredQuestion", "This field is required")
      @addErrorMessage(triggeringElement.closest('.govuk-form-group'), "This field is required")


  # It's for easy debug of validation errors
  # As it really tricky to find out the validation which blocks form
  # and do not display any error massage on form
  logThis: (question, validator, message) ->
    stepData = question.closest(".js-step-condition").data("step")
    stepTitle = $.trim($("a.js-step-link[data-step='#{stepData}']").text())
    qRef = $.trim(question.find("h2 span.visuallyhidden").text())
    qTitle = $.trim(question.find("h2").first().text())

    if typeof console != "undefined"
      console.log "-----------------------------"
      console.log("[STEP]: " + stepTitle)
      console.log("  [QUESTION] " + qRef + ": "+ qTitle)
      console.log("  [" + validator + "]: " + message)
      console.log "-----------------------------"

  hookIndividualValidations: ->
    self = @

    ["change"].forEach (event) ->
      $(document).on event, ".question-block input:not(.autocomplete__input), .question-block select, .question-block textarea", ->
        self.clearErrors $(this)
        self.validateIndividualQuestion($(@).closest(".question-block"), $(@))

  validateIndividualQuestion: (question, triggeringElement) ->
    if question.hasClass("question-required") and (!question.data('answer') || question.data('answer').indexOf('address') is -1) and not question.find('input[type=email]').length
      @validateRequiredQuestion(question)

    if question.hasClass("question-required") and question.data('answer') and question.data('answer').indexOf('address') > -1
      if triggeringElement
        @validateAddressQuestion(question, triggeringElement)
      else
        @validateRequiredQuestion(question)

    if question.find('input[type=email]').length
      @validateEmailQuestion(question)

    if question.hasClass("question-number")
      # console.log "validateNumber"
      @validateNumber(question)

    if question.hasClass("question-year")
      # console.log "validateYear"
      @validateYear(question)

    if question.find(".match").length
      # console.log "validateMatchQuestion"
      @validateMatchQuestion(question)

    if question.hasClass("question-date-max")
      # console.log "validateMaxDate"
      @validateMaxDate(question)

    if question.hasClass("question-dynamic-date-max")
      @validateDynamicMaxDate(question)

    if question.hasClass("question-date-min")
      # console.log "validateMinDate"
      @validateMinDate(question)

    if question.hasClass("question-date-between")
      # console.log "validateBetweenDate"
      @validateBetweenDate(question)

    if question.hasClass("question-employee-min") &&
       question.find(".show-question").length > 0
      # console.log "validateEmployeeMin"
      @validateEmployeeMin(question)

    if question.hasClass("question-current-awards") &&
       question.find(".show-question").length > 0
      # console.log "validateCurrentAwards"
      @validateCurrentAwards(question)

    if question.find(".validate-date-start-end").length > 0
      # console.log "validateDateStartEnd"
      @validateDateStartEnd(question)

    if question.hasClass("js-conditional-drop-block-answer")
      # console.log "validateDropBlockCondition"
      @validateDropBlockCondition(question)

    if question.hasClass("question-support-requests") ||
       question.hasClass("question-support-uploads")
      # console.log "validateSupportLetters"
      @validateSupportLetters(question)

    if question.hasClass("question-limited-selections")
      @validateSelectionLimit(question)

  validate: ->
    @clearAllErrors()

    for question in $(".question-block")
      question = $(question)

      if $(".qae-form").data("skip-assessment-validation")
        step = question.closest(".step-article")

        if step.data("step") != "step-local-assessment-form"
          @validateIndividualQuestion(question)
      else
        @validateIndividualQuestion(question)

    return @validates

  validateStep: (step = null) ->
    @validates = true

    currentStep = step || $(".js-step-link.step-current").attr("data-step")

    stepContainer = $(".article-container[data-step='" + currentStep + "']")

    stepContainer.find(".govuk-form-group--error").removeClass("govuk-form-group--error")
    stepContainer.find(".govuk-error-message").empty()
    $(".steps-progress-bar .js-step-link[data-step='" + currentStep + "']").removeClass("step-errors")
    for question in stepContainer.find(".question-block")
      question = $(question)
      @validateIndividualQuestion(question)

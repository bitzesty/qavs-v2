#= require jquery
#= require jquery_ujs
#= require jquery.fileupload
#= require Countable
#= require moment.min
#= require_tree .

jQuery ->
  triggerAutosave = (e) ->
    window.autosave_timer ||= setTimeout( autosave, 15000 )

  # This is a very primitive way of testing.
  # Should be refactored once forms stabilize.
  #
  # TODO: Refactor this later on
  validate = ->
    window.FormValidation.validate()

  $(document).on "submit", ".qae-form", (e) ->
    $("body").addClass("tried-submitting")
    if not validate()
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
    $(this).closest(".hidden-hint").toggleClass("show-hint")

  # Conditional questions that appear depending on answers
  $(".js-conditional-question, .js-conditional-drop-question").addClass("conditional-question")
  # Simple conditional using a == b
  simpleConditionalQuestion = (input, clicked) ->
    answer = input.closest(".js-conditional-answer").attr("data-answer")
    question = $(".conditional-question[data-question='#{answer}']")
    answerVal = input.val()

    if input.attr('type') == 'checkbox'
      answerVal = input.is(':checked').toString()

    question.each () ->
      if $(this).attr('data-value') == answerVal || ($(this).attr('data-value') == "true" && (answerVal != 'false' && answerVal != false))
        if clicked || (!clicked && input.attr('type') == 'radio' && input.is(':checked'))
          $(this).addClass("show-question")
      else
        if clicked || (!clicked && input.attr('type') != 'radio')
          $(this).removeClass("show-question")
  $(".js-conditional-answer input, .js-conditional-answer select").each () ->
    simpleConditionalQuestion($(this), false)
  $(".js-conditional-answer input, .js-conditional-answer select").change () ->
    simpleConditionalQuestion($(this), true)
  # Numerical conditional that checks that trend doesn't ever drop
  dropConditionalQuestion = (input) ->
    drop_question = input.closest(".js-conditional-drop-answer").attr('data-drop-question')
    question = $(".js-conditional-answer[data-answer='#{drop_question}']").closest(".js-conditional-drop-question")
    drop = false

    $(".js-conditional-drop-answer[data-drop-question='#{drop_question}']").each () ->
      drop_answers = $(this).closest(".js-conditional-drop-answer")
      last_val = 0

      drop_answers.find("input").each () ->
        if $(this).val()
          value = parseFloat $(this).val()
          if value < last_val
            drop = true
          last_val = value

    if drop
      question.addClass("show-question")
    else
      question.removeClass("show-question")
  $(".js-conditional-drop-answer input").each () ->
    dropConditionalQuestion($(this))
  $(".js-conditional-drop-answer input").change () ->
    dropConditionalQuestion($(this))

  # Get the latest financial year date from input
  updateYearEndInput = () ->
    fy_latest_changed_input = $(".js-financial-year .fy-latest .date-input")
    fy_latest_changed_input.find("input").removeAttr("disabled")

    fy_day = $('.js-financial-year-latest .js-fy-day select').val()
    fy_month = $('.js-financial-year-latest .js-fy-month select').val()
    fy_year = new Date().getFullYear()
    # Conditional latest year depending on 1/10/2013 - 30/09/2014
    if fy_month >= 10
      fy_year = parseInt(fy_year) - 1

    # Updates the latest changed financial year input
    fy_latest_changed_input.find("input.js-fy-day").val(fy_day)
    fy_latest_changed_input.find("input.js-fy-month").val(fy_month)
    fy_latest_changed_input.find("input.js-fy-year").val(fy_year)
    fy_latest_changed_input.find("input").attr("disabled", "disabled")

    updateYearEnd()

  # Update the financial year labels
  updateYearEnd = () ->
    $(".js-year-end").removeClass("show-default")
    if $(".js-financial-year-latest").closest(".question-block").next().find("input:checked").val() == "no"
      # Year end hasn't changed, auto select the year
      fy_latest_changed_input = $(".js-financial-year .fy-latest .date-input")
      fy_latest_day = fy_latest_changed_input.find(".js-fy-day").val()
      fy_latest_month = fy_latest_changed_input.find(".js-fy-month").val()
      fy_latest_year = fy_latest_changed_input.find(".js-fy-year").val()

      if !fy_latest_day || !fy_latest_month || !fy_latest_year
        $(".js-year-end").addClass("show-default")
      else
        $(".js-year-end").each () ->
          year = parseInt(fy_latest_year) - parseInt($(this).attr("data-year").substr(0, 1)) + 1
          $(this).find(".js-year-text").text("Year ending in #{fy_latest_day}/#{fy_latest_month}/#{year}")
    else
      # Year has changed, use what they've inputted
      $(".js-year-end").each () ->
        fy_input = $(".js-financial-year .date-input[data-year='#{$(this).attr("data-year")}']")
        fy_day = fy_input.find(".js-fy-day").val()
        fy_month = fy_input.find(".js-fy-month").val()
        fy_year = fy_input.find(".js-fy-year").val()
        if !fy_day || !fy_month || !fy_year
          $(this).addClass("show-default")
        else
          $(this).find(".js-year-text").text("Year ending in #{fy_day}/#{fy_month}/#{fy_year}")

  updateYearEndInput()
  $(".js-financial-year input, .js-financial-year select").change () ->
    updateYearEndInput()
  $(".js-financial-year-latest").closest(".question-block").next().find("input").change () ->
    updateYearEnd()

  # Show/hide the correct step/page for the award form
  showAwardStep = (step) ->
    $(".js-step-condition.step-current").removeClass("step-current")

    window.location.hash = "##{step.substr(5)}"
    $(".js-step-condition[data-step='#{step}']").addClass("step-current")

    # Show past link status
    $(".steps-progress-bar .js-step-link.step-past").removeClass("step-past")

    current_index = $(".steps-progress-bar .js-step-link").index($(".steps-progress-bar .step-current"))
    $(".steps-progress-bar .js-step-link").each () ->
      this_index = $(".steps-progress-bar .js-step-link").index($(this))
      if this_index < current_index
        $(this).addClass("step-past")

  if window.location.hash
    showAwardStep("step-#{window.location.hash.substr(1)}")
    # Resize textareas that were previously hidden
    resetResizeTextarea()
  $(document).on "click", ".js-step-link", (e) ->
    e.preventDefault()
    if !$(this).hasClass("step-current")
      current = $(this).attr("data-step")
      if $(this).hasClass "js-next-link"
        if $("body").hasClass("tried-submitting")
          validate()
        autosave()
      showAwardStep(current)
      # Scroll to top
      $("html, body").animate(
        scrollTop: 0
      , 0)
      # Resize textareas that were previously hidden
      resetResizeTextarea()

  autosave = () ->
    window.autosave_timer = null
    url = $('form.qae-form').data('autosave-url')
    if url
      form_data = $('form.qae-form').serialize()
      $.ajax({
        url: url
        data: form_data
        type: 'POST'
        dataType: 'json'
      })
    #TODO: indicators, error handlers?

  triggerAutosave = (e) ->
    window.autosave_timer ||= setTimeout( autosave, 15000 )

  $(document).on "change", ".js-trigger-autosave", triggerAutosave
  $(document).on "keyup", "input[type='text'].js-trigger-autosave", triggerAutosave
  $(document).on "keyup", "input[type='number'].js-trigger-autosave", triggerAutosave
  $(document).on "keyup", "input[type='url'].js-trigger-autosave", triggerAutosave
  $(document).on "keyup", "input[type='tel'].js-trigger-autosave", triggerAutosave
  $(document).on "keyup", "textarea.js-trigger-autosave", triggerAutosave

  # Fade out alerts after 10sec
  $(".flash").delay(10000).fadeOut()

  $('.js-file-upload').each (idx, el) ->
    form = $(el).closest('form')
    attachments_url = form.data 'attachments-url'
    $el = $(el)

    wrapper = $el.closest('div.js-upload-wrapper')
    button = wrapper.find('span.button')
    list = wrapper.find('.js-uploaded-list')

    max = wrapper.data('max-attachments')
    name = wrapper.data('name')
    form_name = wrapper.data('form-name')
    needs_description = !!wrapper.data('description')

    progress_all = (e, data) ->
      # TODO

    reindex_inputs = () ->
      idx = 0
      list.find('li').each (i, li) ->
        process_input = (j, input_el) ->
          name = $(input_el).attr('name')
          match = /([^\[]+)\[([^\]]+)\]\[([0-9]*)\](.*)/.exec name
          if match
            $(input_el).attr('name', "#{match[1]}[#{match[2]}][#{idx}]#{match[4]}")

        $(li).find('input').each process_input
        $(li).find('textarea').each process_input
        idx++

    update_visibility = () ->
      list_elements = list.find('li')
      count = list_elements.length
      if count > 0
        list.removeClass('visuallyhidden')

      if !max || count < max
        button.removeClass('visuallyhidden')
      else
        button.addClass('visuallyhidden')

    upload_started = (e, data) ->
      button.addClass('visuallyhidden') #TODO: show progressbar

    upload_done = (e, data) ->
      new_el = $("<li>")
      div = $("<div>").text(data.result['original_filename'])

      hidden_input = $("<input>").
        prop('type', 'hidden').
        prop('name', "#{form_name}[#{name}][][file]").
        prop('value', data.result['id'])

      div.append(hidden_input)

      remove_link = $("<a>").addClass('remove-link').prop('href', '#').text('Remove')
      remove_link.click remove_link_clicked

      div.append(remove_link)
      new_el.append(div)

      if needs_description
        desc_div = $("<div>")
        label = ($("<label class=\"small\">").text('Description (optional)'))
        label.append($("<textarea class=\"js-char-count\" rows=\"2\" maxlength=\"600\" data-word-max=\"100\">").attr("name", "#{form_name}[#{name}][][description]"))
        desc_div.append(label)
        new_el.append(desc_div)

      remove_link_clicked = (e) ->
        e.preventDefault()
        new_el.remove()
        update_visibility()
        reindex_inputs
        false

      
      list.append(new_el)
      list.removeClass('visuallyhidden')
      update_visibility()
      reindex_inputs()

    wrapper.find('a.remove-link').each (idx, el) ->
      $(el).click (e) ->
        e.preventDefault()
        li = $(el).closest 'li'
        li.remove()
        update_visibility()
        false

    update_visibility()

    $el.fileupload(
      url: attachments_url
      formData: () -> {}
      done: upload_done
      progressall: progress_all
      send: upload_started
    )


#        progressall: function (e, data) {
#            var progress = parseInt(data.loaded / data.total * 100, 10);
#            $('#progress .progress-bar').css(
#                'width',
#                progress + '%'
#            );
#        })

  # Show current holder info when they are a current holder on basic eligibility current holder question
  if $(".eligibility_current_holder").size() > 0
    $(".eligibility_current_holder input").change () ->
      if $(this).val() == "true"
        $("#current-holder-info").removeClass("visuallyhidden")
      else
        $("#current-holder-info").addClass("visuallyhidden")

  # Show innovation amount info when the amount is greater than 1 on innovation eligibility
  if $(".innovative_amount_input").size() > 0
    $(".innovative_amount_input").bind "propertychange change click keyup input paste", () ->
      if $(this).val() > 1
        $("#innovative-amount-info").removeClass("visuallyhidden")
      else
        $("#innovative-amount-info").addClass("visuallyhidden")

  # Show the eligibility failure contact message
  if $("#basic-eligibility-failure-submit").size() > 0
    $(document).on "click", "#basic-eligibility-failure-submit", (e) ->
      e.preventDefault()
      if $(this).closest("form").find("input:checked").val()
        $("#basic-eligibility-failure-answered").addClass("visuallyhidden")
        $("#basic-eligibility-failure-show").removeClass("visuallyhidden")

  # Change your eligibility answers for award eligibility
  if $(".award-finish-previous-answers").size() > 0
    $(document).on "click", ".award-finish-previous-answers a", (e) ->
      e.preventDefault()
      $("#form_eligibility_show").addClass("visuallyhidden")
      $("#form_eligibility_questions").removeClass("visuallyhidden")

  # Clicking `+ Add` on certain questions add fields
  $(document).on "click", ".question-block .js-button-add", (e) ->
    e.preventDefault()

    question = $(this).closest(".question-block")
    add_example = question.find(".js-add-example").html()

    # If there is a specific add_example use that
    add_example_attr = $(this).attr("data-add-example")
    if ((typeof(add_example_attr) != typeof(undefined)) && add_example_attr != false)
      add_example = question.find(".js-add-example[data-add-example=#{add_example_attr}]").html()

    if question.find(".list-add").size() > 0
      can_add = true

      # Are there add limits
      add_limit_attr = question.find(".list-add").attr("data-add-limit")
      if ((typeof(add_limit_attr) != typeof(undefined)) && add_limit_attr != false)
        list_size = question.find(".list-add > li").not(".js-add-example").size() + question.find(".list-add > li.js-add-example.js-add-default").size()

        if list_size >= add_limit_attr
          can_add = false

        if list_size + 1 >= add_limit_attr
          question.find(".js-button-add").addClass("visuallyhidden")

      if can_add
        question.find(".list-add").append("<li>#{add_example}</li>")
  # Removing these added fields
  $(document).on "click", ".question-group .list-add .js-remove-link", (e) ->
    e.preventDefault()
    $(this).closest(".question-group").find(".js-button-add").removeClass("visuallyhidden")
    $(this).closest("li").remove()

  # Disable copy/pasting in confirmation fields
  $('.js-disable-copy').bind "cut copy", (e) ->
    e.preventDefault()
  $('.js-disable-paste').bind "paste", (e) ->
    e.preventDefault()
  $('.js-disable-copy, .js-disable-paste').bind "contextmenu", (e) ->
      e.preventDefault();

  # Change the entry period text dependion on entry period chosen
  # 2/5 years for Innovation and Sustainable development
  # 3/6 years for International Trade
  replaceEntryPeriodText = () ->
    new_text = ""
    if $(".js-entry-period input:checked").val() == "2 to 4"
      new_text = 2
    else if $(".js-entry-period input:checked").val() == "5 plus"
      new_text = 5
    else if $(".js-entry-period input:checked").val() == "3 to 5"
      new_text = 3
    else if $(".js-entry-period input:checked").val() == "6 plus"
      new_text = 6
    $(".js-entry-period-subtext").each () ->
      $(this).text(new_text)
  if $(".js-entry-period input:checked").size() > 0
    # find all instances of 2/5 or 3/6 and encapsulate them in a span so that we can target this to update the text
    $(".js-entry-period-substitute-text h2, .js-entry-period-substitute-text p").each () ->
      capture = $(this).html().replace(/2\/5/g, "<span class='js-entry-period-subtext'>2/5</span>").replace(/3\/6/g, "<span class='js-entry-period-subtext'>3/6</span>")
      $(this).html(capture)
    $(".js-entry-period input").change () ->
      replaceEntryPeriodText()
    replaceEntryPeriodText()

  # Auto tab on date input entry
  $(".date-input input").on 'keyup', (e) ->
    this_label = $(this).closest("label")
    new_input = ""
    # if it isn't the year input accept 2 numbers (48-57) or moving right (39)
    if this_label.index() != $(this).closest(".date-input").find("label:last-child").index()
      if (e.keyCode >= 48 && e.keyCode <= 57) || e.keyCode == 39
        if $(this).val().length == 2
          # focus on the next input
          new_input = this_label.next().find("input")
    # if it isn't the day input you can go backwards by backspacing (8) or moving left (37)
    if this_label.index() != $(this).closest(".date-input").find("label:first-child").index()
      if e.keyCode == 8 || e.keyCode == 37
        if $(this).val().length == 0
          # focus on the next input
          new_input = this_label.prev().find("input")
    if new_input != ""
      new_input_text = new_input.val()
      new_input.val("")
      new_input.focus()
      new_input.val(new_input_text)
  # only accept numbers(48-47), backspace(8), tab(9), cursor keys left(37) and right(39) and enter for submitting
  $(".date-input input").on 'keypress keydown keyup', (e) ->
    if !((e.keyCode >= 48 && e.keyCode <= 57) || (e.keyCode >= 96 && e.keyCode <= 105) || e.keyCode == 8 || e.keyCode == 9 || e.keyCode == 37 || e.keyCode == 39 || e.keyCode == 13)
      e.preventDefault()
      return false

  # Remove alerts from registration page as soon as user starts typing
  $(".page-devise input").on 'keypress keydown keyup change', () ->
    $(this).closest(".question-body").find(".error").remove()

  # Disable using enter key to submit on the form
  $("form").on 'keypress', (e) ->
    if e.keyCode == 13
      target = $(e.target)
      if !target.is("textarea") && !target.is(":button,:submit")
        $(this).find(":input:visible:not([disabled],[readonly]), a").each () ->
          return false;
        return false;

  # Dropdowns for nav
  $(document).on "click", ".dropdown > a", (e) ->
    e.preventDefault()
    $(this).closest(".dropdown").toggleClass("dropdown-open")
  $(document).on 'click', (e) ->
    if !$(e.target).closest('.dropdown').length
      $(".dropdown.dropdown-open").removeClass("dropdown-open")


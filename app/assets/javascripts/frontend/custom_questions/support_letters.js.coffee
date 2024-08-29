window.SupportLetters =
  init: ->
    $('.js-support-letter-attachment').each (idx, el) ->
      SupportLetters.fileupload_init(el)

    $(document).on 'change', '.js-trigger-autosave', debounce(SupportLetters.submit, 1000)

    $(document).on 'click', '.js-remove-support-letter-attachment', (e) ->
      e.preventDefault()
      SupportLetters.removeFile($(this).closest('.govuk-form-group').find('input:first'), e)

  new_item_init: (el) ->
    SupportLetters.clean_up_system_tags(el)
    SupportLetters.enable_item_fields_and_controls(el)
    SupportLetters.fileupload_init(el.find('.js-support-letter-attachment'))
    el.find('input,textarea,select').first().focus()

  fileupload_init: (el) ->
    $el = $(el)
    parent = $el.closest('.govuk-form-group')

    upload_done = (e, data) ->
      SupportLetters.clean_up_system_tags(parent)

      if data.result['original_filename']
        filename = data.result['original_filename']
      else
        filename = 'File uploaded'

      parent.find('.govuk-error-message').html('')
      parent.find('.govuk-error-message').closest('.govuk-form-group').removeClass('govuk-form-group--error')
      
      textContainer = parent.find('.support-letter-attachment-container')
      textContainer.removeClass('govuk-!-display-none')
      scanningText = '<p class="govuk-hint">(File uploaded and is being scanned for viruses. Preview available once the scan is complete. You may need to refresh this page.)</p>'
      textContainer.prepend('<div class="support-letter-attachment-filename"><p class="govuk-body">' + filename + '</p>' + scanningText + '</div>')
      hiddenInput = $("<input class='js-support-letter-attachment-id' type='hidden' name='#{$el.attr("name")}' value='#{data.result['id']}' />")
      parent.append(hiddenInput)
      parent.find('.js-support-letter-attachment').addClass('govuk-!-display-none')
      SupportLetters.autosave()
      SupportLetters.submit(e)

    failed = (error_message) ->
      SupportLetters.clean_up_system_tags(parent)
      parent.find('.govuk-error-message').html(error_message)
      parent.closest('.govuk-form-group').addClass('govuk-form-group--error')

    success_or_error = (e, data) ->
      errors = data.result.errors

      if errors
        failed(errors.toString())
      else
        upload_done(e, data)

    $el.fileupload(
      url: $el.closest('.list-add').data('attachments-url') + '.json'
      forceIframeTransport: true
      dataType: 'json'
      formData: [
        { name: 'authenticity_token', value: $('meta[name="csrf-token"]').attr('content') }
      ]
      always: success_or_error
    )

  clean_up_system_tags: (parent) ->
    parent.find('input[type="hidden"]').remove()
    parent.find('.support-letter-attachment-filename').remove()

  removeFile: (el, e) ->
    $el = $(el)
    $el.val('')
    $el.siblings('.js-support-letter-attachment-id').first().val('')
    $el.siblings('.support-letter-attachment-container').addClass('govuk-!-display-none')
    $el.removeClass('govuk-!-display-none')
    SupportLetters.autosave()
    SupportLetters.submit(e)

  enable_item_fields_and_controls: (parent) ->
    parent.find('.govuk-error-message').html('')
    prefixed = parent.find('.js-system-tag').data('new-hidden-input-name')
    hiddenInput = $('<input class="js-support-entry-id">').prop('type', 'hidden').prop('name', prefixed)
    parent.append(hiddenInput)

  autosave: () ->
    url = $('form.qae-form').data('autosave-url')
    if url
      # Setting current_step_id to form as we updating only current section form_data (not whole form)
      $('#current_step_id').val($('.js-step-condition.step-current').attr('data-step'))

      form_data = $('form.qae-form').serialize()
      $.ajax({
        url: url
        data: form_data
        type: 'POST'
        dataType: 'json'
      })

  submit: (e) ->
    e.preventDefault()
    e.stopPropagation()

    target = $(e.target)
    parent = target.closest("li")

    data = {'support_letter': {}}
    data['support_letter']['first_name'] = parent.find('.js-support-letter-first-name').val()
    data['support_letter']['last_name'] = parent.find('.js-support-letter-last-name').val()
    data['support_letter']['relationship_to_nominee'] = parent.find('.js-support-letter-relationship-to-nominee').val()

    attachmentId = parent.find('.js-support-letter-attachment-id').val()
    if attachmentId
      data['support_letter']['attachment'] = attachmentId

    email = parent.find('.js-support-letter-email').val()
    if email
      data['support_letter']['email'] = email

    createUrl = parent.data('create-url')
    updateUrl = parent.data('update-url')
    persistUrl = updateUrl || createUrl

    type = if !!updateUrl 
      'put'
    else
      'post'

    if persistUrl
      $.ajax
        url: persistUrl
        type: type
        data: data
        dataType: 'json'
        success: (response) ->
          parent.find('.js-support-entry-id').prop('value', response['id'])
          parent.find('.govuk-error-message').html('')
          parent.removeClass('govuk-form-group--error')
          parent.addClass('js-support-letter-received')
          parent.attr('data-update-url', response['update_url'])
          window.FormValidation.validateStep()
          SupportLetters.autosave()

          return
        error: (response) ->
          parent.find('.govuk-error-message').html('')
          parent.removeClass('govuk-form-group--error')
          msg = response.responseText
          $.each $.parseJSON(response.responseText), (key, msg) ->
            selector = '.js-support-letter-' + key.replace(/_/g, '-')

            errorContainer = parent.find(selector).closest('.govuk-form-group').find('.govuk-error-message')
            errorContainer.html(msg[0])
            errorContainer.closest('.govuk-form-group').addClass('govuk-form-group--error')

          return

debounce = (fn, wait = 500) ->
  last = (new Date) - wait
  ->
    now = new Date

    # Return if we haven't waited long enough
    return if wait > (now - last)

    fn.apply null, arguments
    last = now
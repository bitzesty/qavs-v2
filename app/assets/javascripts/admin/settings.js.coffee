# require jquery-ui
window.__settings_modal_id = 1

class DeadlineForm
  constructor: (el) ->
    @form = el
    @hasChanged = false
    @modal_id = window.__settings_modal_id + 1
    window.__settings_modal_id += 1
    @init()

  init: ->
    @createModal()
    @gatherInitialValues()
    @bindEvents()

  createModal: ->
    html = """
<div class="mm-modal" id="#{@modal_id}" aria-hidden="true">
  <div class="mm-modal__overlay" tabindex="-1" data-micromodal-close>
    <div class="mm-modal__container" role="dialog" aria-modal="true" aria-labelledby="#{@modal_id}-title">
      <header class="mm-modal__header">
        <h2 class="govuk-heading-l mm-modal__title" id="#{@modal_id}-title">
          Are you sure you want to change the date?
        </h2>
        <button class="govuk-button mm-modal__close" aria-label="Close modal" data-micromodal-close></button>
      </header>
      <div class="mm-modal__content" id="#{@modal_id}-content">
        <p class="govuk-body">
          This could change the current status of the application and affect all users.
        </p>

        <div class="govuk-button-group">
          <button type="button" class="govuk-button confirm-date-change">Yes, change the date</button>
          <button class="govuk-button govuk-button--secondary" data-micromodal-close>
            Cancel
          </button>
        </div>
      </div>
    </div>
  </div>
</div>
    """

    @modal = $(html)
    $("body").append(@modal)

  gatherInitialValues: ->
    @date = @form.find("input.datepicker").val()
    @time = @form.find("input.timepicker").val()

  bindEvents: ->
    @form.find("input.datepicker").on "change", (e) =>
      if e.target.value != @date and @date
        @hasChanged = true

    @form.find("input.timepicker").on "change", (e) =>
      if e.target.value != @time and @time
        @hasChanged = true

    @form.on "click", ".govuk-button", (e) =>
      if @hasChanged
        e.preventDefault()

        @showConfirmationModal()
      else
        @form.submit()

    @modal.on "click", ".confirm-date-change", (e) =>
      e.preventDefault()

      MicroModal.close(@modal_id)

      @form.submit()

    @form.on "ajax:saved", =>
      @reset()

  showConfirmationModal: ->
    MicroModal.show(@modal_id)

  reset: ->
    @hasChanged = false
    @gatherInitialValues()
    wrapper = @form.closest('.deadline')
    ($ ".form-value", wrapper).removeClass("govuk-!-display-none")
    ($ ".deadline-form", wrapper).addClass("govuk-!-display-none")
    ($ ".edit-deadline", wrapper).removeClass("govuk-!-display-none")


jQuery ->
  if (settingsWrapper = ($ "#admin-settings-parent")).length
    ($ ".deadline-form").addClass("govuk-!-display-none")
    ($ ".notification-edit-form, .notification-form").addClass("govuk-!-display-none")
    ($ ".email-example").addClass("govuk-!-display-none")

    ($ "form.edit_deadline").each ->
      new DeadlineForm($(@))

    settingsWrapper.on "click", ".edit-deadline", (e) ->
      e.preventDefault()

      wrapper = ($ e.currentTarget).closest('.deadline')

      ($ ".form-value", wrapper).addClass("govuk-!-display-none")
      ($ ".deadline-form", wrapper).removeClass("govuk-!-display-none")
      ($ ".deadline-form", wrapper).find('input:visible,select:visible').first().focus()
      ($ e.currentTarget).addClass("govuk-!-display-none")

    settingsWrapper.on "click", ".edit-notification", (e) ->
      e.preventDefault()

      wrapper = ($ e.currentTarget).closest('li')

      ($ ".form-value", wrapper).addClass("govuk-!-display-none")
      ($ ".notification-edit-form", wrapper).removeClass("govuk-!-display-none")
      ($ ".actions", wrapper).addClass("govuk-!-display-none")
      ($ ".notification-edit-form", wrapper).find('input:visible,select:visible,textarea:visible').first().focus()

    settingsWrapper.on "click", ".btn-add-schedule", (e) ->
      e.preventDefault()
      wrapper = ($ e.currentTarget).closest('.panel-section')
      ($ ".notification-form", wrapper).toggleClass("govuk-!-display-none")
      ($ ".notification-form", wrapper).find('input:visible,select:visible,textarea:visible').first().focus()

    settingsWrapper.on "click", ".link-email-example", (e) ->
      e.preventDefault()
      wrapper = ($ e.currentTarget).closest('.panel-section')
      ($ ".email-example", wrapper).toggleClass("govuk-!-display-none")

    settingsWrapper.on "click", ".btn-cancel", (e) ->
      e.preventDefault()

      form_well = ($ e.currentTarget).closest('.govuk-inset-text')

      if form_well.hasClass("deadline-form")
        wrapper = ($ e.currentTarget).closest('.deadline')
        ($ ".form-value", wrapper).removeClass("govuk-!-display-none")
        ($ ".deadline-form", wrapper).addClass("govuk-!-display-none")
        ($ ".edit-deadline", wrapper).removeClass("govuk-!-display-none")
        ($ ".edit-deadline", wrapper).focus()

      else if form_well.hasClass("notification-edit-form")
        wrapper = ($ e.currentTarget).closest('li')
        ($ ".form-value", wrapper).removeClass("govuk-!-display-none")
        ($ ".notification-edit-form", wrapper).addClass("govuk-!-display-none")
        ($ ".actions", wrapper).removeClass("govuk-!-display-none")
        ($ ".actions", wrapper).find('a').focus()

      else if form_well.hasClass("notification-new-form")
        wrapper = ($ e.currentTarget).closest('.panel-section')
        ($ ".notification-form", wrapper).addClass("govuk-!-display-none")

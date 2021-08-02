# require jquery-ui

class DeadlineForm
  constructor: (el) ->
    @form = el
    @hasChanged = false
    @init()

  init: ->
    @createModal()
    @gatherInitialValues()
    @bindEvents()

  createModal: ->
    html = """
<div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body">
        <p>
          This could change the current status of the application and affect all users.
        </p>
        <p>
          Are you sure you want to change the date?
        </p>

        <br />

        <p>
          <button type="button" class="btn btn-primary confirm-date-change">Yes, change the date</button>
          <button type="button" class="btn btn-link" data-dismiss="modal">Cancel</button>
        </p>
      </div>
    </div>
  </div>
</div>
    """

    @modal = $(html)

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

    @form.on "click", ".btn-submit", (e) =>
      if @hasChanged
        e.preventDefault()

        @showConfirmationModal()
      else
        @form.submit()

    @modal.on "click", ".confirm-date-change", (e) =>
      e.preventDefault()

      @modal.modal("hide")

      @form.submit()

    @form.on "ajax:saved", =>
      @reset()

  showConfirmationModal: ->
    @modal.modal("show")

  reset: ->
    @hasChanged = false
    @gatherInitialValues()


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
      ($ e.currentTarget).addClass("govuk-!-display-none")

    settingsWrapper.on "click", ".edit-notification", (e) ->
      e.preventDefault()

      wrapper = ($ e.currentTarget).closest('li')

      ($ ".form-value", wrapper).addClass("govuk-!-display-none")
      ($ ".notification-edit-form", wrapper).removeClass("govuk-!-display-none")
      ($ ".actions", wrapper).addClass("govuk-!-display-none")

    settingsWrapper.on "click", ".btn-add-schedule", (e) ->
      e.preventDefault()
      wrapper = ($ e.currentTarget).closest('.panel-section')
      ($ ".notification-form", wrapper).toggleClass("govuk-!-display-none")

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

      else if form_well.hasClass("notification-edit-form")
        wrapper = ($ e.currentTarget).closest('li')
        ($ ".form-value", wrapper).removeClass("govuk-!-display-none")
        ($ ".notification-edit-form", wrapper).addClass("govuk-!-display-none")
        ($ ".actions", wrapper).removeClass("govuk-!-display-none")

      else if form_well.hasClass("notification-new-form")
        wrapper = ($ e.currentTarget).closest('.panel-section')
        ($ ".notification-form", wrapper).addClass("govuk-!-display-none")

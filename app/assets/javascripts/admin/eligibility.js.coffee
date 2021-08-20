$(document).ready () ->
  $(".admin-eligibility-option").on "change", (e) ->
    if $(e.currentTarget).is(':checked') && $(e.currentTarget).val() == "admin_not_eligible_nominator"
      $(".nominator-ineligible-reasons").show()
      $(".group-ineligible-reasons").hide()

    else if $(e.currentTarget).is(':checked') && $(e.currentTarget).val() == "admin_not_eligible_group"
      $(".group-ineligible-reasons").show()
      $(".nominator-ineligible-reasons").hide()
    else
      $(".nominator-ineligible-reasons").hide()
      $(".group-ineligible-reasons").hide()

  if $(".admin-eligibility-option:checked").val() == "admin_not_eligible_nominator"
    $(".nominator-ineligible-reasons").show()
    $(".group-ineligible-reasons").hide()

  else if $(".admin-eligibility-option:checked").val() == "admin_not_eligible_group"
    $(".group-ineligible-reasons").show()
    $(".nominator-ineligible-reasons").hide()

jQuery ->
  if !Cookies.get("general_cookie_consent_status")
    $(".govuk-cookie-banner").attr("tabindex", "-1")
    $(".govuk-cookie-banner").attr("aria-live", "polite")
    $(".govuk-cookie-banner").removeAttr("hidden")
    $(".govuk-cookie-banner").attr("role", "alert")

    $(".govuk-cookie-banner .cookies-action").on "click", (e) ->
      e.preventDefault()

      Cookies.set("general_cookie_consent_status", 'yes', { expires: 3650 })
      Cookies.set("analytics_cookies_consent_status", $(@).val(), { expires: 3650 })
      $(".govuk-cookie-banner .initial-message").attr("hidden", "true")

      if $(@).val() == "yes"
        $(".govuk-cookie-banner .accept-message").removeAttr("hidden")
      else
        $(".govuk-cookie-banner .reject-message").removeAttr("hidden")

    $(".govuk-cookie-banner .hide-message").on "click", (e) ->
      e.preventDefault()
      $(".govuk-cookie-banner").attr("hidden", "true")

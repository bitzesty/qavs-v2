/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

const frontend = require("govuk-frontend/govuk/all")
require.context('govuk-frontend/govuk/assets/images', true)
import './application.scss';

import MicroModal from 'micromodal';

import AccessibleAutocomplete from '../vendor/accessible-autocomplete.min';
import CheckboxMultiselect from '../vendor/checkbox-multiselect';

import Cookies from 'js-cookie'

import SessionTimeout from '../components/session_timeout';

SessionTimeout();

frontend.initAll()

$(document).on('click', 'button[data-micromodal-close]', function(e) {
  e.preventDefault();
  e.stopPropagation()
  $("html").removeClass('modal-open');
})

if ($('.bulk-assignment-container').length > 0) {
  $("#check_all").on("click", function() {
    var select_all_value = $(this).prop("checked");
    $(this).closest("table").find(".form-answer-check").prop("checked", select_all_value)
  });
}

var dropdowns = $('select[multiple]');
if (dropdowns.length > 0) {
  dropdowns.each(function() {
    var dropdown = $(this)[0];
    var multiselect = new CheckboxMultiselect(dropdown, {
      singleSelectionShowDirectly: true,
      includeBlank: true,
      search: {
        enabled: false
      }
    })

    multiselect.enable()
  })
}

$(".toggable-form").each(function() {
  var form = $(this);

  (function(form) {
    form.on('click', '.toggable-form__trigger', function(e) {
      e.preventDefault();
      e.stopPropagation();

      form.attr("aria-expanded", "true");

      form.find('input,select,textarea').first().focus();
    });

    form.on('click', '.toggable-form__save', function(e) {
      if (form.closest("form").hasClass("assessment-togglable")) {
        return // skipping all this, use standard remote: true
      }

      if (form.closest("form").hasClass("final-verdict-togglable")) {
        return // skipping all this, use standard remote: true
      }

      e.preventDefault();
      e.stopPropagation();

      form.closest('form').find('[type="submit"]').trigger('click');

      if (form.find('textarea.assessor-notes-input').length) {
        form.find('p.assessor-notes').text(form.find('textarea.assessor-notes-input').first().val());
        form.find('p.assessor-notes').removeClass('govuk-hint');

      } else {
        form.find('.toggable-form__read .toggable-form__content:first').text(form.find('textarea').first().val());
        form.find('.toggable-form__read .toggable-form__content:last').text(form.find('textarea').last().val());
      }

      if (form.find('select.evaluation-rate-input').length) {
        var val = form.find('select.evaluation-rate-input').first().val();
        form.find('span.evaluation-rate').text(val);
        form.find('p.evaluation-rate').removeClass("govuk-!-display-none");

      }

      form.attr("aria-expanded", "false");
      form.find('.toggable-form__trigger').focus();
    });

    form.on('click', '.toggable-form__cancel', function(e) {
      e.preventDefault();
      e.stopPropagation();

      form.attr("aria-expanded", "false");
      form.find('.toggable-form__trigger').focus();
    });

    if (form.attr("aria-expanded") == "true") {
      $(".toggable-form__trigger", form).click()
    }
  })(form);
})

$('.autosubmit-on-change').each(function() {
  var form = $(this);

  form.find('input, select').on('change', function() {
    form.submit();
  });
})

$(".custom-select").each(function() {
  var field = $(this)[0];

  if ($(this).is(":disabled") || $(this).is("[readonly]")) {
    return;
  }

  AccessibleAutocomplete.enhanceSelectElement({
    selectElement: field,
    showAllValues: true,
    dropdownArrow: function() {
      return "<span class='autocomplete__arrow'></span>";
    }
  })
});

for (let i = 0; i < 2; i++) {
  if ($(`#palace_invite_palace_attendees_attributes_${i}_disabled_access_true:checked`).length > 0) {
    $(`.disabled-access-banner-${i}`).removeClass('govuk-!-display-none');
  };

  $(document).on('change', 'input.disabled-access-radio[type=radio]', function() {
    if ($(`#palace_invite_palace_attendees_attributes_${i}_disabled_access_true:checked`).length > 0) {
      $(`.disabled-access-banner-${i}`).removeClass('govuk-!-display-none');
    } else {
      $(`.disabled-access-banner-${i}`).addClass('govuk-!-display-none');
    };
  });
};

$(document).on('click', 'input[name=accept-award]', function() {
  if ($(this).val() == 'yes') {
    $('#accept_award').val("true")
    $('.citation').removeClass('govuk-!-display-none')
  } else {
    $('#accept_award').val("false")
    $('input.citation').removeClass('govuk-!-display-none')
    $('div.citation').addClass('govuk-!-display-none')
  }
})



function AddTableARIA() {
  try {
    var allTables = document.querySelectorAll('table');
    for (var i = 0; i < allTables.length; i++) {
      allTables[i].setAttribute('role','table');
    }
    var allCaptions = document.querySelectorAll('caption');
    for (var i = 0; i < allCaptions.length; i++) {
      allCaptions[i].setAttribute('role','caption');
    }
    var allRowGroups = document.querySelectorAll('thead, tbody, tfoot');
    for (var i = 0; i < allRowGroups.length; i++) {
      allRowGroups[i].setAttribute('role','rowgroup');
    }
    var allRows = document.querySelectorAll('tr');
    for (var i = 0; i < allRows.length; i++) {
      allRows[i].setAttribute('role','row');
    }
    var allCells = document.querySelectorAll('td');
    for (var i = 0; i < allCells.length; i++) {
      allCells[i].setAttribute('role','cell');
    }
    var allHeaders = document.querySelectorAll('th');
    for (var i = 0; i < allHeaders.length; i++) {
      allHeaders[i].setAttribute('role','columnheader');
    }
    // this accounts for scoped row headers
    var allRowHeaders = document.querySelectorAll('th[scope=row]');
    for (var i = 0; i < allRowHeaders.length; i++) {
      allRowHeaders[i].setAttribute('role','rowheader');
    }
  } catch (e) {
    console.log("AddTableARIA(): " + e);
  }
}

AddTableARIA();


function ResponsiveCellHeaders(table) {
  try {
    var styleElm = document.createElement("style"), styleSheet;
    document.head.appendChild(styleElm);
    styleSheet = styleElm.sheet;
    var THarray = [];
    var ths = table.querySelector('.govuk-table__head').getElementsByTagName("th");
    for (var i = 0; i < ths.length; i++) {
      var headingText = ths[i].innerText;
      THarray.push(headingText);
    }

    for (var i = 0; i < THarray.length; i++) {
      styleSheet.insertRule(
        "#" +
          table.id +
          " tbody td:nth-child(" +
          (i + 1) +
          ')::before {content:"' +
          THarray[i] +
          ': ";}',
        styleSheet.cssRules.length
      );

      styleSheet.insertRule(
        "#" +
          table.id +
          " tbody th:nth-child(" +
          (i + 1) +
          ')::before {content:"' +
          THarray[i] +
          ': ";}',
        styleSheet.cssRules.length
      );
    }
  } catch (e) {
    console.log("ResponsiveCellHeaders(): " + e);
  }
}

Array.prototype.slice.call(document.querySelectorAll('table')).forEach(function(table) {
  ResponsiveCellHeaders(table);
})

if (!Cookies.get("general_cookie_consent_status")) {
  $(".govuk-cookie-banner").attr("tabindex", "-1")
  $(".govuk-cookie-banner").attr("aria-live", "polite")
  $(".govuk-cookie-banner").removeAttr("hidden")
  $(".govuk-cookie-banner").attr("role", "alert")

  $(".govuk-cookie-banner .cookies-action").on("click", function(e) {
    e.preventDefault()

    Cookies.set("general_cookie_consent_status", 'yes', { expires: 3650 })
    Cookies.set("analytics_cookies_consent_status", $(this).val(), { expires: 3650 })
    $(".govuk-cookie-banner .initial-message").attr("hidden", "true")

    if ($(this).val() == "yes") {
      $(".govuk-cookie-banner .accept-message").removeAttr("hidden")
    } else {
      $(".govuk-cookie-banner .reject-message").removeAttr("hidden")
    }
  })

  $(".govuk-cookie-banner .hide-message").on("click", function(e) {
    e.preventDefault()
    $(".govuk-cookie-banner").attr("hidden", "true")
  })
}

$('.question-required').find('input,select,textarea').each(function() {
  $(this).prop('required', true);
  $(this).attr('aria-required', 'true');
});

$('.qae-form').find('input[type="number"]').each(function() {
  $(this).attr('pattern', '[0-9]*');
  $(this).attr('inputmode', 'decimal');
});

if ($('.submitted-view').length > 0) {
  var hash = window.location.hash;

  if (hash) {
    var heading = $(hash);

    if (heading) {
      var waitForAccordionAndClickIt = function() {
        var button = heading.find('button.govuk-accordion__section-button');

        if (button.length > 0) {
          setTimeout(function() {
            if (button.first().attr('aria-expanded') !== 'true') {
              button.first().trigger('click');
            }

            button.first().focus();
          }, 1000);
          return;
        }

        setTimeout(waitForAccordionAndClickIt, 2000);
      }

      waitForAccordionAndClickIt();
    }
  }
}

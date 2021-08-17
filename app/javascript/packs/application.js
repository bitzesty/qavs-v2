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

import 'jquery/src/jquery';
import MicroModal from 'micromodal';

import Accordion from '../components/accordion';
import AccessibleAutocomplete from '../vendor/accessible-autocomplete.min';
import CheckboxMultiselect from '../vendor/checkbox-multiselect';

frontend.initAll()

$('.bulk-assign-lieutenants-link').on('click', function(e) {
  e.preventDefault();
  e.stopPropagation();

  MicroModal.show('modal-bulk-assign-lieutenants');
})

$(document).on('click', 'button[data-micromodal-close]', function(e) {
  e.preventDefault();
  e.stopPropagation()
})

if ($('.bulk-assignment-container').length > 0) {
  $("#check_all").on("change", function() {
    var select_all_value = $(this).prop("checked");
    $(this).closest("table").find(".form-answer-check").prop("checked", select_all_value)
  });

  $(".form-answer-check, #check_all").on("change", function() {
    var show_button = false;

    $(".form-answer-check").each(function() {
      if ($(this).prop("checked")) {
        show_button = true
      }
    })

    if (show_button) {
      $(".bulk-assignment-container").addClass("show-container")
      $(".bulk-assignment-help").addClass("govuk-!-display-none")
      var selected_count = $('input[type=checkbox].form-answer-check:checked').length
      if (selected_count > 1) {
        $('.nominations-checked-total').text(selected_count +' groups selected')
      } else {
        $('.nominations-checked-total').text(selected_count +' group selected')
      }
    } else {
      $(".bulk-assignment-container").removeClass("show-container")
      $(".bulk-assignment-help").removeClass("govuk-!-display-none")
    }
  })
}

var dropdowns = $('select[multiple]');
if (dropdowns.length > 0) {
  dropdowns.each(function() {
    var dropdown = $(this)[0];
    var multiselect = new CheckboxMultiselect(dropdown, {
      singleSelectionShowDirectly: true,
      search: {
        enabled: false
      }
    })

    multiselect.enable()
  })
}

$(".toggable-form").each(function() {
  var form = $(this);

  form.on('click', '.toggable-form__trigger', function(e) {
    e.preventDefault();
    e.stopPropagation();

    form.attr("aria-expanded", "true");

    form.find('input,select,textarea').first().focus();
  });

  form.on('click', '.toggable-form__save', function(e) {
    e.preventDefault();
    e.stopPropagation();

    form.closest('form').find('[type="submit"]').trigger('click');

    form.find('.toggable-form__read .toggable-form__content:first').text(form.find('textarea').first().val())
    form.find('.toggable-form__read .toggable-form__content:last').text(form.find('textarea').last().val())

    form.attr("aria-expanded", "false");
    form.find('.toggable-form__trigger').focus();
  });

  form.on('click', '.toggable-form__cancel', function(e) {
    e.preventDefault();
    e.stopPropagation();

    form.attr("aria-expanded", "false");
    form.find('.toggable-form__trigger').focus();
  });
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

$("#accept-award").on('click', function() {
  $('.citation').removeClass('govuk-!-display-none')
  $('.award-acceptance-container').addClass('govuk-!-display-none')
})

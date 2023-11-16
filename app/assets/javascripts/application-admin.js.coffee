#= require jquery3
#= require jquery-ujs
#= require bootstrap-sprockets
#= require vendor/file_upload/jquery.ui.widget
#= require vendor/file_upload/jquery.iframe-transport
#= require vendor/file_upload/jquery.fileupload
#= require vendor/file_upload/jquery.fileupload-process
#= require vendor/file_upload/jquery.fileupload-validate
#= require select2.full.min
#= require moment.min
#= require Countable

# crypt.io: secures browser storage with the SJCL crypto library
#= require vendor/sjcl
#= require vendor/crypt.io.min

#= require ./frontend/local_storage
#= require ./frontend/password-strength-indicator
#= require ./frontend/textarea-autoResize
#= require ./frontend/text-character-count
#= require js.cookie
#= require_tree ./admin
#= require search
#= require jquery-ui
#= require vendor/zxcvbn
#= require vendor/jquery-debounce
#= require clean-paste

$( ->
  $("html").removeClass("no-js").addClass("js")
  ($ ".datepicker").datepicker({dateFormat: "dd/mm/yy"})
  ($ ".timepicker").timePicker()
  ($ "select.select2").select2({width: "style"})
)

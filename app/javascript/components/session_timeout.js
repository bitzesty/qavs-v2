import MicroModal from 'micromodal';

export default function() {
  var dialogElement = document.getElementById("timeout_dialog");

  if (!dialogElement) return;

  var continueButtonElement = document.getElementById("timeout-continue");
  var warningTimeInMinutes = dialogElement.getAttribute("data-warning-in-minutes");
  var timeoutInMinutes = dialogElement.getAttribute("data-timeout-in-minutes");
  var refreshSessionPath = dialogElement.getAttribute("data-refresh-session-path");
  var timeoutInMilliseconds = (timeoutInMinutes - warningTimeInMinutes) * 60 * 1000;
  var timeoutPath = dialogElement.getAttribute("data-timeout-path");
  var dialog = new window.A11yDialog(dialogElement);

  continueButtonElement.onclick = function () {
    MicroModal.hide('timeout_dialog');
    document.querySelector("html").classList.remove('modal-open');
    refreshSession();
  };

  dialog.on("hide", function () {
    dialogElement.setAttribute("aria-hidden", "true");
    
  });

  function refreshSession() {
    Rails.ajax({
      url: refreshSessionPath,
      type: "get",
      success: function () {
        clearInterval(window.sessionTimeoutTimer);
        clearTimeout(window.sessionTimeout);
        window.sessionTimeoutTimer = setInterval(showTimeoutDialog, timeoutInMilliseconds);
      }
    });
  }

  function sessionTimedOut() {
    clearInterval(window.sessionTimeoutTimer);
    window.location = timeoutPath;
  }

  function showTimeoutDialog() {
    document.querySelector("html").classList.add('modal-open');
    MicroModal.show('timeout_dialog');
    window.sessionTimeout = setTimeout(sessionTimedOut, warningTimeInMinutes * 60 * 1000);
  }

  window.sessionTimeoutTimer = setInterval(showTimeoutDialog, timeoutInMilliseconds);
};
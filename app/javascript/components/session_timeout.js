import MicroModal from 'micromodal';

export default function() {
  var dialogElement = document.getElementById("timeout_dialog");

  if (!dialogElement) return;

  var continueButtonElement = document.getElementById("timeout-continue");
  var warningTimeInMinutes = 5;
  var timeoutInMinutes = dialogElement.getAttribute("data-timeout-in-minutes");
  var refreshSessionPath = dialogElement.getAttribute("data-refresh-session-path");
  var timeoutInMilliseconds = (timeoutInMinutes - warningTimeInMinutes) * 60 * 1000;
  var timeoutPath = dialogElement.getAttribute("data-timeout-path");

  continueButtonElement.onclick = function () {
    MicroModal.close('timeout_dialog');
    document.querySelector("html").classList.remove('modal-open');
    refreshSession();
  };

  function refreshSession() {
    $.ajax({
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
    if (document.querySelector('.qae-form')) {
      document.querySelector('.message-outside-form').style.display = 'none';
    } else {
      document.querySelector('.message-inside-form').style.display = 'none';
    }
    MicroModal.show('timeout_dialog');
    window.sessionTimeout = setTimeout(sessionTimedOut, warningTimeInMinutes * 60 * 1000);
  }

  window.sessionTimeoutTimer = setInterval(showTimeoutDialog, timeoutInMilliseconds);
};

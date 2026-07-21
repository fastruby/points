// Single source of truth for the unsaved-changes wording. It is shown for
// every in-app link the user might leave through. The native beforeunload
// prompt (reload / closing the tab) always uses the browser's own generic
// text; browsers ignore any custom string there, so that one case aside, this
// keeps the wording consistent everywhere we can control it.
const UNSAVED_CHANGES_MESSAGE =
  "You have unsaved changes. Are you sure you want to leave?";

// Init on turbolinks:load (not DOMContentLoaded) so it also runs on Turbolinks
// visits, matching project.js. reloadable state lives at module scope so the
// delegated click handler can be added by reference and de-duplicated across
// visits instead of stacking a new listener each time.
let editForm = null;
let editFormInitialState = null;
let editFormDirty = false;

document.addEventListener("turbolinks:load", () => {
  document.querySelectorAll("[data-has-preview]").forEach((element) => {
    let debounceTimer;

    element.addEventListener("input", (e) => {
      const updateMarkdown = () => {
        const form = element.closest("form");
        const preview = form.querySelector(
          "." + element.dataset.previewTarget + " .content"
        );
        if (preview) {
          Rails.ajax({
            type: "POST",
            url: "/stories/render_markdown",
            data: `markdown=${encodeURIComponent(element.value)}`,
            dataType: "text",
            success: (response) => {
              preview.innerHTML = response;
            },
          });
        }
      };

      window.clearTimeout(debounceTimer);
      debounceTimer = window.setTimeout(updateMarkdown, 300);
    });
  });

  initUnsavedChangesGuard();
});

function initUnsavedChangesGuard() {
  editForm = document.querySelector(".edit_story");
  editFormDirty = false;
  // Start each visit from a clean slate; drop any beforeunload guard carried
  // over from a previous page.
  addBeforeUnloadEventListener(false);

  if (!editForm) {
    return;
  }

  // Snapshot the initial form state so we can compare against it. Tracking a
  // plain "changed at least once" flag reported the form as dirty even after
  // the user undid their edits (e.g. typed some text and then deleted it).
  editFormInitialState = serializeForm(editForm);

  // "input" covers text fields; "change" covers selects like the status.
  editForm.addEventListener("input", refreshEditFormDirtyState);
  editForm.addEventListener("change", refreshEditFormDirtyState);
  editForm.addEventListener("submit", clearEditFormDirtyState);

  // Same warning for every in-app link that leaves the page (Back, the logo,
  // Sign out, ...), not just a couple of buttons. Added by reference so it is
  // de-duplicated if turbolinks:load fires again.
  document.addEventListener("click", confirmLeaveIfUnsavedEdits);
}

function refreshEditFormDirtyState() {
  editFormDirty = serializeForm(editForm) !== editFormInitialState;
  addBeforeUnloadEventListener(editFormDirty);
}

function clearEditFormDirtyState() {
  editFormDirty = false;
  addBeforeUnloadEventListener(false);
}

function confirmLeaveIfUnsavedEdits(event) {
  if (!editFormDirty) {
    return;
  }

  const link = event.target.closest("a[href]");
  if (!link) {
    return;
  }

  // Links that do not actually leave the page (new tab, in-page anchors,
  // javascript: handlers) should not trigger the warning.
  const href = link.getAttribute("href") || "";
  if (link.target === "_blank" || href.startsWith("#") || href.startsWith("javascript:")) {
    return;
  }

  if (window.confirm(UNSAVED_CHANGES_MESSAGE)) {
    clearEditFormDirtyState();
  } else {
    event.preventDefault();
  }
}

function serializeForm(form) {
  return new URLSearchParams(new FormData(form)).toString();
}

function addBeforeUnloadEventListener(isDirty) {
  if (isDirty) {
    window.addEventListener("beforeunload", warnUserIfUnsavedEdits);
  } else {
    window.removeEventListener("beforeunload", warnUserIfUnsavedEdits);
  }
}

function warnUserIfUnsavedEdits(event) {
  event.preventDefault();
  event.returnValue = UNSAVED_CHANGES_MESSAGE;
}

function updateStatusButton(color, status) {
  const button = document.querySelector(".story-title .dropdown-wrapper > button");
  button.className = `button ${color}`;

  const span = button.querySelector("span");
  span.textContent = status;

  document.querySelector(":focus").blur();
}

function updateStatusLabel(status, storyId) {
  let row = document.getElementById(`story_${storyId}`)
  status_label = row.querySelector(".status > .story-status-badge")
  status_label.textContent = status
  status_label.classList.value = `story-status-badge ${status}`
}

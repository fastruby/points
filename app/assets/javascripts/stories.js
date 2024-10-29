document.addEventListener("DOMContentLoaded", () => {
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

  const form = document.querySelector('.edit_story');
  const backButton = document.getElementById('back');
  const logo = document.getElementById('logo');
  let isDirty = false;

  // Mark the form as dirty when any input changes
  form.addEventListener('input', function () {
    isDirty = true;
  });

  // Attach a click event to the custom back button
  [backButton, logo].forEach(element => {
    element.addEventListener('click', function (event) {
      if (isDirty) {
        const confirmLeave = confirm("You have unsaved changes. Are you sure you want to go back?");
        if (!confirmLeave) {
          // Prevent navigation if the user chooses not to leave
          event.preventDefault();
        } else {
          // Optionally, reset isDirty if leaving
          isDirty = false;
        }
      }
    })
  });

  // Reset isDirty on form submission
  form.addEventListener('submit', function () {
    isDirty = false;
  });

  if (isDirty) {
    window.addEventListener("beforeunload", warnUserifUnsavedEdits);
  } else {
    window.removeEventListener("beforeunload", warnUserifUnsavedEdits);
  }
});

function warnUserifUnsavedEdits(event) {
  event.preventDefault();
  event.returnValue = '';
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

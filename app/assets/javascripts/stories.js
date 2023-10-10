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
});

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

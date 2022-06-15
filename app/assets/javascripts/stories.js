document.addEventListener("input", (e) => {
  const updateMarkdown = () => {
    document.querySelectorAll("[data-has-preview]").forEach((element) => {
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
    });
  };

  var debounceTimer;
  window.clearTimeout(debounceTimer);
  debounceTimer = window.setTimeout(updateMarkdown, 300);
});

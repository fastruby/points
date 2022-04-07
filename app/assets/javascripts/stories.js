document.addEventListener("turbolinks:load", function () {
  document.addEventListener("input", (e) => {
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
  });
});

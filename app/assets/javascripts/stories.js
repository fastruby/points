document.addEventListener("input", (e) => {
  function preview_setup(text_area_class, preview_class) {
    if (e.target.classList.contains(text_area_class)) {
      const desc = e.target;
      const form = desc.closest("form");
      const preview = form.querySelector(preview_class  + " .content");
      if (preview) {
        Rails.ajax({
          type: "POST",
          url: "/stories/render_markdown",
          data: `markdown=${encodeURIComponent(desc.value)}`,
          dataType: "text",
          success: (response) => {
            preview.innerHTML = response;
          },
        });
      }
    }
  }

  preview_setup("story-description", ".story_preview")
  preview_setup("story-extra-info", ".extra_info_preview")
});

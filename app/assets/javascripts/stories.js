document.addEventListener("input", (e) => {
  if (e.target.classList.contains("story-description")) {
    const desc = e.target;
    const form = desc.closest("form");
    const preview = form.querySelector(".story_preview .content");
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
});

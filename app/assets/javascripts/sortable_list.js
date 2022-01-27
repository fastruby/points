document.addEventListener("turbolinks:load", function () {
  $("#stories, .sortable-projects").sortable({
    update: function (e, ui) {
      const project = ui.item[0].closest("div.project-card");
      project.classList.add("sorting");
      Rails.ajax({
        type: "PATCH",
        url: this.dataset.url,
        data: $(this).sortable("serialize"),
        complete: () => {
          project.classList.remove("sorting");
        },
      });
    },
  });
});

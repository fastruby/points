document.addEventListener("turbolinks:load", function () {
  $("#stories, .sortable-projects").sortable({
    update: function (e, ui) {
      const parent = ui.item[0].closest("div.project-card, .project-table");
      parent.classList.add("sorting");
      Rails.ajax({
        type: "PATCH",
        url: this.dataset.url,
        data: $(this).sortable("serialize"),
        complete: () => {
          parent.classList.remove("sorting");
        },
      });
    },
  });
});

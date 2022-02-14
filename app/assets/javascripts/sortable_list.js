document.addEventListener("turbolinks:load", function () {
  $("#stories, .sortable-projects").sortable({
    update: function (e, ui) {
      const parent = ui.item[0].closest("div.project-card, .project-table");
      if (parent) parent.classList.add("sorting");
      Rails.ajax({
        type: "PATCH",
        url: this.dataset.url,
        data: $(this).sortable("serialize"),
        complete: () => {
          if (parent) parent.classList.remove("sorting");
        },
      });
    },
  });
});

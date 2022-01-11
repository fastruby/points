document.addEventListener("turbolinks:load", function() {
  $("input[name='stories[]']").click(() => {
    const selected = $("input[name='stories[]']:checked");

    if (selected.length > 0) {
      const ending = selected.length == 1 ? "y" : "ies";
      $("#bulk_delete")
        .text(`Bulk Delete (${selected.length} Stor${ending})`)
        .attr("aria-disabled", "false")
        .prop("disabled", false);
    } else {
      $("#bulk_delete")
        .text("Bulk Delete")
        .attr("aria-disabled", "true")
        .prop("disabled", true)
    }
  })

  $(".import-export-header").click(function () {
    $(this).children(".rotate").toggleClass("left");
  })

  $("#bulk_delete").click((event) => {
    let stories_ids = []
    $("input[name='stories[]']:checked").each((_, checkbox) => {
      stories_ids.push($(checkbox).val())
    })

    $(event.target)
      .text("Bulk Delete")
      .attr("aria-disabled", "true")
      .prop("disabled", true)

    let token = $("meta[name='csrf-token']").attr("content")
    $.ajaxSetup({
      beforeSend: function (xhr) {
        xhr.setRequestHeader("X-CSRF-Token", token);
      }
    });

    $.ajax({
      url: "/stories/bulk_destroy",
      data: {ids: stories_ids},
      type: "POST",
      success: () => {
        $(stories_ids).each((_, id) => {
          console.log(id)
          $("#story_" + id).remove();
        })
      },
      error: (result) => {
        console.log("There was an error destroying the stories")
      }
    })
  })
})

window.addEventListener("load", () => {
  const links = document.querySelectorAll(".project-table__row--story a.delete");
  links.forEach((element) => {
    element.addEventListener("ajax:success", () => {
      document.getElementById(`story_${element.dataset.storyId}`).remove()
      console.log("The story was deleted.");
    });
  });
});

const filterStories = () => {
  const searchTerm = document.getElementById("title_contains").value.toLowerCase().trim();
  if (searchTerm.length == 0) {
    $("#stories").sortable("enable");
  } else {
    $("#stories").sortable("disable");
  }

  document.querySelectorAll("#stories tr").forEach(function(element) {
    const cl = element.classList
    const storyTitle = element.querySelector("td:first-child").innerText.toLowerCase()
    if (storyTitle.includes(searchTerm)) {
      cl.remove("hidden")
    } else {
      cl.add("hidden")
    }
  })
};

$(() => {
  const token = $("meta[name='csrf-token']").attr("content")
  $.ajaxSetup({
    beforeSend: function (xhr) {
      xhr.setRequestHeader("X-CSRF-Token", token);
    }
  });

  $(document).on("click", "#bulk_delete",() => {
    let stories_ids = []
    $("input[name='stories[]']:checked").each((_, checkbox) => {
      stories_ids.push($(checkbox).val())
    })

    $.ajax({
      url: "/stories/bulk_destroy",
      data: {ids: stories_ids},
      type: "POST",
      success: () => {
        $(stories_ids).each((_, id) => {
          console.log(id)
          $("#story_" + id).remove()
        })
      },
      error: () => {
        console.log("There was an error destroying the stories")
      }
    })
  })

  $(document).on("click", ".delete", (e) => {
    let element = $(e.target)

    if (!confirm("Are you sure?")) { return }

    $.ajax({
      url: element.data("delete-url"),
      type: "DELETE",
      error: () => {
        console.log("There was an error destroying the story")
      }
    })
  })
})






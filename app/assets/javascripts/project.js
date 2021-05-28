$(() => {
  $("input[name='stories[]']").click(() => {
    let selected = $("input[name='stories[]']:checked");

    if (selected.length > 0) {
      let ending = selected.length == 1 ? "y" : "ies";
      $("#bulk_delete")
        .text(`Bulk Delete (${selected.length} Stor${ending})`)
        .removeAttr("aria-disabled");
    } else {
      $("#bulk_delete")
        .text(`Bulk Delete`)
        .attr("aria-disabled", "true");
    }
  })

  $("#bulk_delete").click(() => {
    let stories_ids = []
    $("input[name='stories[]']:checked").each((_, checkbox) => {
      stories_ids.push($(checkbox).val())
    })

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

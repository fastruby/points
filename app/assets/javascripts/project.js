$(() => {
  $("input[name='stories[]']").click(() => {
    let selected = $("input[name='stories[]']:checked");
    let ending = selected.length == 1 ? "y" : "ies";
    $(".number-of-stories-selected")
      .text(`${selected.length} stor${ending} selected`)
      .removeClass("alert");
  })

  $("#bulk_delete").click(() => {
    let stories_ids = []
    $("input[name='stories[]']:checked").each((_, checkbox) => {
      stories_ids.push($(checkbox).val())
    })

    if (stories_ids.length === 0) {
      $(".number-of-stories-selected")
        .text("Please select 1 or more stories")
        .addClass("alert");
    }

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
          $(".number-of-stories-selected").text("");
          $("#story_" + id).remove();
        })
      },
      error: (result) => {
        console.log("There was an error destroying the stories")
      }
    })
  })
})

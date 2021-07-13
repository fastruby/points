document.addEventListener("turbolinks:load", function() {
  $(".import-export-header").click(function () {
    $(this).children(".rotate").toggleClass("left");
  })
})

$(() => {
    let stories_ids = []
  $("#bulk_delete").click(() => {
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






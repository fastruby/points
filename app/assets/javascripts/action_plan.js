document.addEventListener("turbolinks:load", function() {
  $("#action-plan-prefix").keyup(function(event) {
    const prefix = event.target.value.trim()

    $("h3.action-plan_heading > span").each(function(index) {
      const suffix = prefix.length === 0 ? "" : `${index+1}`
      $(this).text(`${prefix}.${suffix} `)
    })
  })
})

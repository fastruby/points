document.addEventListener("turbolinks:load", function() {
  $("input[name='action-plan_prefix']").keyup(function(event) {
    const prefix = event.target.value.trim();

    $("h3.action-plan_heading").each(function(index) {
      $(this).children("span").remove();
      $(this).prepend(`<span>${prefix}${prefix == "" ? "" : index + 1} </span>`);
    });
  });
});

document.addEventListener("turbolinks:load", function() {
  $("input[name='action-plan_prefix']").keyup(function(event) {
    let prefix = event.target.value;

    $("h3.action-plan_heading").each(function(index) {
      $(this).children("span").remove();
      $(this).prepend(`<span>${prefix}${prefix.trim() == "" ? "" : index + 1} </span>`);
    });
  });
});

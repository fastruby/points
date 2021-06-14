document.addEventListener("turbolinks:load", function() {
  $("input[name='action-plan_prefix']").keyup(function(event) {
    let prefix = event.target.value;

    $("h3.action-plan_heading").each(function(index) {
      let prevHeader = $(this).text();
      prevHeader = prevHeader.substring(prevHeader.indexOf(" ") + 1);

      $(this).text(`${prefix}.${index + 1} ${prevHeader}`);
    })
  });
});

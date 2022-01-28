document.addEventListener("turbolinks:load", function () {
  $("#action-plan-prefix").keyup(function (event) {
    const prefix = event.target.value.trim();

    document
      .querySelectorAll(".action-plan_heading > span.index")
      .forEach((el) => {
        const suffix = prefix.length === 0 ? "" : `.${el.dataset.idx}`;
        el.innerText = `${prefix}${suffix} `;
      });
  });

  const toggleBack = function (id) {
    setTimeout(() => {
      $(`#story_${id} .popup`).toggle(300);
    }, 1000);
  };

  let clipboard = new ClipboardJS(".btn-clipboard");
  clipboard.on("success", function (e) {
    const id = e.text.split("/").slice(-1);

    $(`#story_${id} .popup`).toggle(300, toggleBack(id));
    e.clearSelection();
  });
});

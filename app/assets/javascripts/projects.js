document.addEventListener("turbolinks:load", function () {
  const projectTitle = document.querySelector(".project-title");
  if (projectTitle) {
    const titleButton = projectTitle.querySelector("button");
    const titleForm = projectTitle.querySelector("form");
    const titleInput = titleForm.querySelector("#project_title");

    titleButton.addEventListener("click", () => {
      projectTitle.classList.toggle("editing");

      // focus input and move caret at the end of text
      titleInput.focus();
      titleInput.select();
      titleInput.selectionStart = titleInput.selectionEnd =
        titleInput.value.length;
    });

    titleForm.querySelector("button.cancel").addEventListener("click", (e) => {
      e.preventDefault();
      projectTitle.classList.toggle("editing");
      titleInput.value = titleButton.innerText;
    });

    // trim input on blur to prevent empty values
    titleInput.addEventListener("blur", (e) => {
      let val = e.target.value;
      val = val.trim();
      e.target.value = val;
    });
  }
});

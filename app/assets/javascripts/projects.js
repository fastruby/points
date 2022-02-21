document.addEventListener("turbolinks:load", function () {
  const projectTitle = document.querySelector(".project-title");
  if (projectTitle) {
    const titleButton = projectTitle.querySelector("button");
    const titleForm = projectTitle.querySelector("form");
    const titleInput = titleForm.querySelector("#project_title");

    titleButton.addEventListener("click", () => {
      projectTitle.classList.toggle("editing");
    });

    titleForm.querySelector("button.cancel").addEventListener("click", (e) => {
      e.preventDefault();
      projectTitle.classList.toggle("editing");
      titleInput.value = titleButton.innerText;
    });

    titleInput.addEventListener("blur", (e) => {
      let val = e.target.value;
      val = val.trim();
      e.target.value = val;
    });
  }
});

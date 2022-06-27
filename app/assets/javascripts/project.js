document.addEventListener("turbolinks:load", function () {
  $("input[name='stories[]']").click(() => {
    const selected = $("input[name='stories[]']:checked");
    const is_unlocked = $("#stories").data("unlocked");
    if (!is_unlocked) {
      return;
    }

    if (selected.length > 0) {
      const ending = selected.length == 1 ? "y" : "ies";
      $("#bulk_delete")
        .text(`Bulk Delete (${selected.length} Stor${ending})`)
        .attr("aria-disabled", "false")
        .prop("disabled", false);
    } else {
      $("#bulk_delete")
        .text("Bulk Delete")
        .attr("aria-disabled", "true")
        .prop("disabled", true);
    }
  });

  $(".import-export-header").click(function () {
    $(this).children(".rotate").toggleClass("left");
  });

  $("#bulk_delete").click((event) => {
    let stories_ids = [];
    $("input[name='stories[]']:checked").each((_, checkbox) => {
      stories_ids.push($(checkbox).val());
    });

    const ending = stories_ids.length == 1 ? "y" : "ies";
    let user_confirmation = confirm(
      `Are you sure you want to delete ${stories_ids.length} stor${ending}?`
    );
    if (!user_confirmation) return;

    $(event.target)
      .text("Bulk Delete")
      .attr("aria-disabled", "true")
      .prop("disabled", true);

    let token = $("meta[name='csrf-token']").attr("content");
    $.ajaxSetup({
      beforeSend: function (xhr) {
        xhr.setRequestHeader("X-CSRF-Token", token);
      },
    });

    $.ajax({
      url: "/stories/bulk_destroy",
      data: { ids: stories_ids },
      type: "POST",
      success: () => {
        $(stories_ids).each((_, id) => {
          console.log(id);
          $("#story_" + id).remove();
        });
      },
      error: (result) => {
        console.log("There was an error destroying the stories");
      },
    });
  });

  // bind select/unselect all when cloning projects
  document.querySelectorAll("#select-all, #unselect-all").forEach((button) => {
    const setCheck = button.id === "select-all" ? true : false;

    button.addEventListener("click", (e) => {
      e.preventDefault();
      toggleCloneSubProjects(setCheck);
    });
  });

  // unselect all if clone is not a parent
  const projectCloneParent = document.getElementById("project_parent_id");
  const subProjects = document.getElementById("sub-projects-to-clone");

  if (projectCloneParent && subProjects) {
    projectCloneParent.addEventListener("change", (e) => {
      if (projectCloneParent.value !== "") {
        subProjects.classList.add("is-not-parent");
      } else {
        subProjects.classList.remove("is-not-parent");
      }
    });
  }
});

const filterStories = () => {
  const searchTerm = document
    .getElementById("title_contains")
    .value.toLowerCase()
    .trim();
  if (searchTerm.length == 0) {
    $("#stories").sortable("enable");
  } else {
    $("#stories").sortable("disable");
  }

  document.querySelectorAll("#stories tr").forEach(function (element) {
    const cl = element.classList;
    const storyTitle = element
      .querySelector("td:first-child")
      .innerText.toLowerCase();
    if (storyTitle.includes(searchTerm)) {
      cl.remove("hidden");
    } else {
      cl.add("hidden");
    }
  });
};

function toggleCloneSubProjects(value) {
  document
    .querySelectorAll("#sub-projects-to-clone input[type='checkbox']")
    .forEach((el) => (el.checked = value));
}

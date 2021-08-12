let modal = false
document.addEventListener("turbolinks:load", () => {
  modal = document.querySelector(".modal")
})

// show a new Modal with a given title and body
function showModal(title, body) {
  updateModal(title, body)
  $(modal).modal('show')
}

// update the Modal title and body
function updateModal(title, body) {
  modal.querySelector(".modal-title").innerHTML = title
  modal.querySelector(".modal-body").innerHTML = body
}

// closes the modal
function closeModal() {
  $(modal).modal('hide')
}

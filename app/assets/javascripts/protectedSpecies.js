document.addEventListener("turbolinks:load", () => {
  if (!checkController("protected_species")) {
    return;
  } else {
    const dropdown = document.querySelector(".table .dropdown");
    dropdown.addEventListener("click", () => {
      dropdown.classList.toggle("is-active");
    });
  }
});

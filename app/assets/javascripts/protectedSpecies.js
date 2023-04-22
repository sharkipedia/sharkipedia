document.addEventListener("turbolinks:load", () => {
  if (!checkController("protected_species")) {
    return;
  } else {
    const dropdownButtons = document.querySelectorAll(".table .dropdown");
    dropdownButtons.forEach((button) => {
      button.addEventListener("click", () => {
        button.classList.toggle("is-active");
      });
    });
  }
});

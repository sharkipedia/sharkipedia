$(document).on("turbolinks:load", function () {
  if (!checkController("references")) {
    return;
  }

  runSelect2("references");

  $("#references").on("select2:select", function (e) {
    var data = e.params.data;
    Turbolinks.visit("/references/" + data.id);
  });

  const fetchAuthor = async function (inputValue, inputElement) {
    const resp = await fetch(`/search/autocomplete?klass=author&term=${inputValue}`);
    const results = await resp.json();
    if (results.length > 0) {
      console.log(results[0]);
      return results.map((author) => ({ label: author.name, value: author.name }));
    }

    return [];
  };

  // Gnarly hack to get bulmahead working with vanilla-nested
  // https://github.com/arielj/vanilla-nested/blob/cab8f390dc99eed933952f6fcc14603bad30c6a8/app/assets/javascripts/vanilla_nested.js#L10
  // Does a `data.html.replace(/_idx_placeholder_/g, Date.now());` before inserting it into the DOM
  // So we need to use the same placeholder
  bulmahead("reference_authors_attributes_0_name", "_idx_placeholder_", fetchAuthor, () => {}, 200);

  document.addEventListener("vanilla-nested:fields-added", function (e) {
    const newInput = document.querySelector(".added-by-vanilla-nested:last-of-type input");
    const inputId = newInput.getAttribute("id");
    const regex = /\d+/g;
    const menuId = inputId.match(regex)[0];
    bulmahead(inputId, menuId, fetchAuthor, () => {}, 200);
  });
});

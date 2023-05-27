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
    const resp = await fetch(`http://localhost:3000/search/autocomplete?klass=author&term=${inputValue}`);
    const results = await resp.json();
    if (results.length > 0) {
      const { name } = results[0];
      console.log(name);
    }
    // brain fried brrrmm
    // TODO: Make this work in the input and not just in the console.log
    // TODO: If author is found - associate them with reference - if author is not found, create them and then associate them with reference
    // return transformed.slice(0, 5);
  };

  // Function to add event listener for author inputs
  const addAuthorInputEventListener = (inputElement) => {
    inputElement.addEventListener("input", (e) => fetchAuthor(e.target.value, e.target));
  };
  // Attach the listener to the default author field on load
  addAuthorInputEventListener(document.getElementById("reference_authors_attributes_0_name"));

  document.addEventListener("vanilla-nested:fields-added", function (e) {
    const newInput = document.querySelector(".added-by-vanilla-nested:last-of-type input");
    addAuthorInputEventListener(newInput);
  });
});

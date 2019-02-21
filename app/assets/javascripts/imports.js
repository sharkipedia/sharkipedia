document.addEventListener("turbolinks:load", function() {
  let btns = ["reject", "request-changes", "approve"];
  if (document.getElementById(btns[0] + "-btn") === null)
  {
    return;
  }

  var btnSetup = function(name) {
    document.getElementById(name + "-btn").addEventListener("click", function() {
      var list = document.getElementsByClassName(name);
      for (let element of list) {
        element.classList.remove('is-hidden');
      }

      document.getElementsByClassName('modal')[0].classList.add('is-active')
    });
  };

  btns.forEach(function(element) {
    btnSetup(element);
  });

  var setHidden = function(name) {
    var list = document.getElementsByClassName(name);
    for (let element of list) {
      element.classList.add('is-hidden');
    }
  }

  var list = document.getElementsByClassName("close-modal");
  for (let element of list) {
    element.addEventListener("click", function() {
      document.getElementsByClassName('modal')[0].classList.remove('is-active')

      btns.forEach(function(element) {
        setHidden(element);
      });
    });
  }
});

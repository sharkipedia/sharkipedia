document.addEventListener("turbolinks:load", function() {
  if (!checkController('imports')) {
    return;
  }

  var doCheck = function() {
    let has_title = document.getElementById('import_title').value == '';
    let has_file  = document.getElementById('import_xlsx_file').value == '';
    document.getElementById("import_submit").disabled = has_title || has_file;
  }

  // new import form validation
  let import_title = document.getElementById('import_title');
  if (import_title !== null && import_title.type === "text")
  {
    import_title.onkeyup = doCheck;
    import_title.onblur = doCheck;

    import_title.focus();
    import_title.select();
  }

  let import_file = document.getElementById('import_xlsx_file');
  if (import_file !== null && import_file.type === 'file')
  {
    import_file.onclick = doCheck;
    import_file.onchange = doCheck;
  }


  // modal related
  let btns = ["reject", "request-changes", "approve"];
  if (document.getElementById(btns[0] + "-btn") !== null)
  {
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
  }

  // imports index

  let gridctr = document.getElementById('gridctr');
  if (gridctr !== null) {
    let url = gridctr.dataset.url;

    /* set up async GET request */
    var req = new XMLHttpRequest();
    req.open("GET", url, true);
    req.responseType = "arraybuffer";

    req.onload = function(e) {
      var data = new Uint8Array(req.response);
      var workbook = XLSX.read(data, {type:"array"});

      var ws = workbook.Sheets[workbook.SheetNames[0]];
      var data = XLSX.utils.sheet_to_json(ws, {header:1});

      var grid = canvasDatagrid({
        parentNode: document.getElementById('gridctr'),
        editable: false,
        data: data
      });
      grid.style.height = '100%';
      grid.style.width = '100%';
    }

    req.send();
  }

});

var spot = 0
var turn = 1

function code_or_not(is_code) {
  if (is_code == true) {
    return "code"
  } else {
    return turn.toString()
  }
}

function ball_picker(color, is_code) {
  var id = code_or_not(is_code)
  var row = document.getElementById(id)
  row.children[spot].innerHTML = "<img src='/images/" + color + "_ball.png' alt='" + color + " ball'>"
  if (spot < 3) {
    spot ++
  } else {
    spot = 0
  }
}

function turn_submit(is_code) {
  var input = ""
  var id = code_or_not(is_code)
  var row = document.getElementById(id)
  for (i = 0; i < 4; i++) {
    var input = input.concat(row.children[i].children[0].alt.charAt(0).toUpperCase())
  }
  //console.log(id)
  //console.log(guess)
  guess(input)  //ajax
}

function guess(input) {
  var xmlhttp = new XMLHttpRequest();
  xmlhttp.onreadystatechange = function() {
    if (xmlhttp.readyState == XMLHttpRequest.DONE && xmlhttp.status == 200) {
    }
  }

  xmlhttp.open("GET", input, true);
  xmlhttp.send();
}

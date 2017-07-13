var spot = 0

function ball_picker(color) {
  var row = document.getElementById(obtain_current_row())
  row.children[spot].innerHTML = "<img src='/images/" + color + "_ball.png' alt='" + color + " ball'>"
  if (spot < 3) {
    spot ++
  } else {
    spot = 0
  }
}

function turn_submit() {
  var guess = ""
  var row = document.getElementById(obtain_current_row())
  for (i = 0; i < 4; i++) {
    var guess = guess.concat(row.children[i].children[0].alt.charAt(0).toUpperCase())
    console.log(guess)
  }
  guess_and_feedback(guess)  //ajax
}

function obtain_current_row() {
  var xmlhttp = new XMLHttpRequest();
  xmlhttp.onreadystatechange = function() {
    if (xmlhttp.readyState == XMLHttpRequest.DONE && xmlhttp.status == 200) {
      meow = xmlhttp.response
      alert(meow)
    }
  }
  xmlhttp.open("GET", "current_row", true);
  xmlhttp.send();
}

function guess_and_feedback(guess) {
  var xmlhttp = new XMLHttpRequest();
  xmlhttp.onreadystatechange = function() {
    if (xmlhttp.readyState == XMLHttpRequest.DONE && xmlhttp.status == 200) {
    }
  }

  xmlhttp.open("GET", guess, true);
  xmlhttp.send();
}

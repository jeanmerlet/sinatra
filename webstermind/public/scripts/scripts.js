var spot = 0

function ball_picker(color, row) {
  var row = document.getElementById(row)
  row.children[spot].innerHTML = "<img src='/images/" + color + "_ball.png' alt='" + color + " ball'>"
  if (spot < 3) {
    spot ++
  } else {
    spot = 0
  }
}

function turn_submit(row) {
  var guess = ""
  var row = document.getElementById(row)
  for (i = 0; i < 4; i++) {
    var guess = guess.concat(row.children[i].children[0].alt.charAt(0).toUpperCase())
    console.log(guess)
  }
  //now to ajax this over to the server...
  guess_and_feedback(guess)
}

function guess_and_feedback(guess) {
  var xmlhttp = new XMLHttpRequest();
  xmlhttp.onreadystatechange = function() {
    if (xmlhttp.readyState == XMLHttpRequest.DONE && xmlhttp.status == 200) {
      //post feedback
    }
  }

  xmlhttp.open("GET", guess, true);
  xmlhttp.send();
}

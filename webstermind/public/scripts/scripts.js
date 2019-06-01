var spot = 0

function ball_picker(color) {
  var div = document.getElementById("ball_display")
  div.children[spot].innerHTML = "<img src='/images/" + color + "_ball.png' alt='" + color + " ball'>"
  if (spot < 3) {
    spot ++
  } else {
    spot = 0
  }
}

function turn_submit() {
  var guess = ""
  var ball_display = document.getElementById("ball_display")
  for (i = 0; i < 4; i++) {
    var guess = guess.concat(ball_display.children[i].children[0].alt.charAt(0).toUpperCase())
  }
  send_guess(guess)
}

function send_guess(guess) {
  var xmlhttp = new XMLHttpRequest();
  xmlhttp.onreadystatechange = function() {
    if (xmlhttp.readyState == XMLHttpRequest.DONE && xmlhttp.status == 200) {
      window.location = "/mastermind/play"
    }
  }
  xmlhttp.open("GET", guess, true);
  xmlhttp.send(null);
}

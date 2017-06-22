function ball_picker(color, row, spot) {
  row = document.getElementById(row)
  row.children[spot].innerHTML = "<img src='/images/" + color + "_ball.png' alt='" + color + " ball'>"
}

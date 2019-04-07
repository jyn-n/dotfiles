
function aur() {
	su aur -c "yay $(echo $@)"
}
compdef aur=yay


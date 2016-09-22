#!/usr/bin/zsh

function selectTrack() {
	local artist="$1"
	local album="$2"
	mpc list title artist "$artist" album "$album" | rofi -dmenu
}

function selectAlbum() {
	local artist="$1"
	mpc list album artist "$artist" | rofi -dmenu
}

function selectArtist() {
	mpc list artist | rofi -dmenu
}

function selectAction() {
	local artist="$1"
	local album="$2"
	local track="$3"
	local action=$(echo "Play now\nPlay next\nAppend to queue" | rofi -dmenu)
	local uri=$(mpc search artist "$artist" album "$album" title "$track" | head -1)
	if [[ "$action" == "Play now" ]]; then
		mpc insert "$uri"
		mpc next
	elif [[ "$action" == "Play next" ]]; then
		mpc insert "$uri"
	elif [[ "$action" == "Append to queue" ]]; then
		mpc add "$uri"
	fi
}

function selectAll() {
	local artist=$(selectArtist)
	if [[ ! $artist ]]; then
		exit
	fi
	local album=$(selectAlbum "$artist")
	if [[ ! $album ]]; then
		exit
	fi
	local track=$(selectTrack "$artist" "$album")
	if [[ ! $track ]]; then
		exit
	fi
	selectAction "$artist" "$album" "$track"
}

selectAll

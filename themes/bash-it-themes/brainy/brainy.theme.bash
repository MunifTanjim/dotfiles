#!/usr/bin/env bash

# Brainy Bash Prompt
# Screenshot: ( Under Development )

__brainy_prompt_user_info() {
	color=${bold_blue}
	if [ $THEME_SUDO_INDICATOR == "true" ]; then
		if [ $(sudo -n id -u 2>&1 | grep 0) ]; then
			color=${bold_red}
		fi
	fi
	user_info="${USER}@${HOSTNAME}"
	printf "${color}|${user_info}"
}

__brainy_prompt_dir() {
	color=${bold_yellow}
	box="[|]"
	current_dir="$(pwd | sed "s:^${HOME}:~:")"
	printf "${color}|${current_dir}|${bold_white}|${box}"
}

__brainy_prompt_scm() {
	box="$(scm_char) "
	printf "${bold_green}|$(scm_prompt_info)|${bold_white}|${box}"
}

__brainy_prompt_clock() {
	if [ "${THEME_SHOW_CLOCK}" == "true" ]; then
		color=$THEME_CLOCK_COLOR
		box="[|]"
		if [ "${THEME_SHOW_CLOCK_CHAR}" == "true" ]; then
			clock_string+="${THEME_CLOCK_CHAR} "
		fi
		clock_string+="$(date +"${THEME_CLOCK_FORMAT}")"
		printf "${color}|${clock_string}|${bold_cyan}|${box}"
	fi
}

__brainy_prompt_battery() {
	batt=$(battery_percentage)
	if [ ${#batt} -gt 0 ]; then
		color=$bold_red
		box="[|]"
		printf "${color}|${batt}|${bold_cyan}|${box}"
	fi
}

__brainy_prompt_exit_code() {
	color=$bold_cyan
	[ ${exit_code} -ne 0 ] && printf "${color}|${exit_code}"
}

__brainy_prompt_char() {
	color=$bold_white
	prompt_char="${__BRAINY_PROMPT_CHAR_PS1}"
	printf "${color}|${prompt_char}"
}

__brainy_top_left_parse() {
	ifs_old="${IFS}"
	IFS="|"
	args=( $1 )
	IFS="${ifs_old}"
	if [ -n ${args[3]} ]; then
		___TOP_LEFT+="${args[2]}${args[3]}"
	fi
	___TOP_LEFT+="${args[0]}${args[1]}"
	if [ -n ${args[4]} ]; then
		___TOP_LEFT+="${args[2]}${args[4]}"
	fi
	___TOP_LEFT+=" "
}

__brainy_top_right_parse() {
	ifs_old="${IFS}"
	IFS="|"
	args=( $1 )
	IFS="${ifs_old}"
	___TOP_RIGHT+=" "
	if [ -n ${args[3]} ]; then
		___TOP_RIGHT+="${args[2]}${args[3]}"
	fi
	___TOP_RIGHT+="${args[0]}${args[1]}"
	if [ -n ${args[4]} ]; then
		___TOP_RIGHT+="${args[2]}${args[4]}"
	fi
	___TOP_RIGHT_LEN=$(( ${#args[1]} + ___TOP_RIGHT_LEN + ${#args[3]} + ${#args[4]} ))
	(( ___SEG_AT_RIGHT += 1 ))
}

__brainy_top() {
	___TOP_LEFT=""
	___TOP_RIGHT=""
	___TOP_RIGHT_LEN=0
	___SEG_AT_RIGHT=0

	for seg in $__BRAINY_TOP_LEFT; do
		info="$(__brainy_prompt_${seg})"
		[ -n "${info}" ] && __brainy_top_left_parse "${info}"
	done

	___cursor_right="\033[500C"
	___TOP_LEFT+="${___cursor_right}"

	for seg in $__BRAINY_TOP_RIGHT; do
		info="$(__brainy_prompt_${seg})"
		[ -n "${info}" ] && __brainy_top_right_parse "${info}"
	done

	___TOP_RIGHT_LEN=$(( ___TOP_RIGHT_LEN + ___SEG_AT_RIGHT - 1 ))
	___cursor_adjust="\033[${___TOP_RIGHT_LEN}D"
	___TOP_LEFT+="${___cursor_adjust}"

	printf "${___TOP_LEFT}${___TOP_RIGHT}"
}

__brainy_bottom_parse() {
	ifs_old="${IFS}"
	IFS="|"
	args=( $1 )
	IFS="${ifs_old}"
	___BOTTOM+="${args[0]}${args[1]}"
	[ ${#args[1]} -gt 0 ] && ___BOTTOM+=" "
}

__brainy_bottom() {
	___BOTTOM=""
	for seg in $__BRAINY_BOTTOM; do
		info="$(__brainy_prompt_${seg})"
		[ -n "${info}" ] && __brainy_bottom_parse "${info}"
	done
	printf "\n${___BOTTOM}"
}

__brainy_ps1() {
	printf "$(__brainy_top)$(__brainy_bottom)$normal"
}

__brainy_ps2() {
	color=$bold_white
	printf "${color}${__BRAINY_PROMPT_CHAR_PS2}  ${normal}"
}

_brainy_prompt() {
	exit_code="$?"

  PS1="$(__brainy_ps1)"
  PS2="$(__brainy_ps2)"
}

SCM_THEME_PROMPT_PREFIX=""
SCM_THEME_PROMPT_SUFFIX=""

SCM_THEME_PROMPT_DIRTY=" ${bold_red}✗${normal}"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓${normal}"

THEME_SHOW_CLOCK=${THEME_SHOW_CLOCK:-"true"}
THEME_CLOCK_COLOR=${THEME_CLOCK_COLOR:-"$bold_white"}
THEME_CLOCK_FORMAT=${THEME_CLOCK_FORMAT:-"%H:%M:%S"}
THEME_SHOW_CLOCK_CHAR=${THEME_SHOW_CLOCK_CHAR:-"false"}
THEME_CLOCK_CHAR=${THEME_CLOCK_CHAR:-"⌚"}
THEME_SUDO_INDICATOR=${THEME_SUDO_INDICATOR:-"true"}

__BRAINY_PROMPT_CHAR_PS1=${THEME_PROMPT_CHAR_PS1:-">"}
__BRAINY_PROMPT_CHAR_PS2=${THEME_PROMPT_CHAR_PS2:-"\\"}

__BRAINY_TOP_LEFT=${__BRAINY_TOP_LEFT:-"user_info dir scm"}
__BRAINY_TOP_RIGHT=${__BRAINY_TOP_RIGHT:-"clock battery"}
__BRAINY_BOTTOM=${__BRAINY_BOTTOM:-"exit_code char"}

safe_append_prompt_command _brainy_prompt

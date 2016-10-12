# Brainy Bash Prompt
# Screenshot: 

function prompt_command() {
  PS1="${bold_blue}\u@\h ${bold_white}[${bold_yellow}\w${bold_white}] $(prompt_char) ${bold_green}$(scm_prompt_info)${bold_white}\n\$ ${normal}"
}

SCM_THEME_PROMPT_PREFIX=''
SCM_THEME_PROMPT_SUFFIX=''

safe_append_prompt_command prompt_command

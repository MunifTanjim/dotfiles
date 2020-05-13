function command_exists() {
  type ${1} >/dev/null 2>&1
}

function directory_exists() {
  [ -d "${1}" ]
}

if ! type pathmunge >/dev/null 2>&1; then
  function pathmunge() {
    if ! [[ ${PATH} =~ (^|:)${1}($|:) ]]; then
      if [ "${2}" = "after" ]; then
        export PATH=${PATH}:${1}
      else
        export PATH=${1}:${PATH}
      fi
    fi
  }
fi


function _load_modules() {
  module_type="$1"
  if [ -d "${DOTFILES_MODULES}/${module_type}" ]
  then
    FILES="${DOTFILES_MODULES}/${module_type}/*.bash"
    for file in $FILES
    do
      if [ -e "${file}" ]; then
        source $file
      fi
    done
  fi
}

function reload_aliases() {
  _load_modules "aliases"
}

function reload_completion() {
  _load_modules "completion"
}

function reload_plugins() {
  _load_modules "plugins"
}

if ! type pathmunge > /dev/null 2>&1
then
  function pathmunge () {
    if ! [[ $PATH =~ (^|:)$1($|:) ]] ; then
      if [ "$2" = "after" ] ; then
        export PATH=$PATH:$1
      else
        export PATH=$1:$PATH
      fi
    fi
  }
fi

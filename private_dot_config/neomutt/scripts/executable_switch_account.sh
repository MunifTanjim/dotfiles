#!/usr/bin/env bash

folders=$(find ~/.local/share/Mail/ -mindepth 2 -type d -name cur -exec sh -c 'echo $1 | sed "s/^.*Mail\///;s/\/cur.*//"' -- {} \;)

select_folder() {
  local -r title="Select Mail Folder:"

  local folder

  if type "fzf" >/dev/null 2>&1; then
    folder=$(echo "${folders}" | fzf --header="${title}" -i --info=hidden --layout=reverse)
  else
    PS3="${title} > "
    select f in ${folders[@]}; do
      folder=${f}
      break
    done
  fi


  echo "${folder}"
}

folder=$(select_folder)

if [ -z "${folder}" ]; then
  echo "push <change-folder>!"
else
  echo "push <change-folder>=${folder}"
fi

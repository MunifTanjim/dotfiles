export NVM_DIR="$HOME/.nvm"

if command -v brew &>/dev/null && [ -s $(brew --prefix nvm)/nvm.sh ]
then
  . $(brew --prefix nvm)/nvm.sh
else
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
fi


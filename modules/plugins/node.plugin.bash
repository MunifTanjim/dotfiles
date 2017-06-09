pathmunge ./node_modules/.bin

# Make sure the global npm prefix is on the path
[[ `which npm` ]] && pathmunge $(npm config get prefix)/bin


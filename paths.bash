export PATH="$HOME/.dotfiles/scripts/scripts.bash:$PATH"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.bin" ] ; then
    export PATH="$HOME/.bin:$PATH"
fi

# export GOPATH=$HOME/.go
# export PATH=$GOPATH:$GOPATH/bin:$PATH

# Ubuntu make installation of Android SDK
# export ANDROID_HOME="$HOME/.local/share/umake/android/android-sdk"
# PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH

# Ubuntu make installation of Ubuntu Make binary symlink
export PATH="$HOME/.local/share/umake/bin:$PATH"

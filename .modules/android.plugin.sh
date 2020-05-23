# shellcheck shell=sh

export ANDROID_SDK_ROOT="${HOME}/.local/share/android/sdk"

pathmunge "${ANDROID_SDK_ROOT}/tools"
pathmunge "${ANDROID_SDK_ROOT}/platform-tools"

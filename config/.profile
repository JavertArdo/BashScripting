# Qt5 scale fix
export QT_AUTO_SCREEN_SCALE_FACTOR=0

# .NET Core
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_ROOT="/usr/share/dotnet"
export MSBuildSDKsPath="$DOTNET_ROOT/sdk/$(${DOTNET_ROOT}/dotnet --version)/Sdks"

# Flutter
export ENABLE_FLUTTER_DESKTOP=true
export PATH="$PATH:`pwd`/Documents/SDK/flutter/bin"

# Android
export ANDROID_HOME="$PATH:`pwd`/Documents/SDK/android"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

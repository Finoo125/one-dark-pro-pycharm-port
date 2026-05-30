# One Dark Pro Pycharm Port

This project ports the VS Code **OneDark-Pro** theme by [Binaryify](https://github.com/Binaryify/OneDark-Pro) to the IntelliJ Platform as a single PyCharm-focused release built around the core One Dark Pro look.

The port includes:

- a bundled IntelliJ UI theme
- a bundled editor color scheme tuned to the upstream One Dark Pro palette
- a local PowerShell build script that packages the plugin without requiring Gradle

## Build

Run this from the project root:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_plugin.ps1
```

The packaged plugin will be written to `dist\`.

## Install in PyCharm

1. Build the plugin jar.
2. Open **Settings** -> **Plugins** -> the gear icon -> **Install Plugin from Disk...**
3. Select the jar from `dist\`.
4. Restart PyCharm.
5. Select **One Dark Pro Pycharm Port** in **Settings** -> **Appearance & Behavior** -> **Appearance**.

## Notes

- The UI layer is mapped as closely as practical to JetBrains theme keys.
- The editor schemes follow the upstream One Dark Pro palette for comments, strings, keywords, numbers, functions, types, and common markup.
- Some VS Code-specific token scopes do not have a one-to-one IntelliJ equivalent, so those are approximated with the closest bundled editor attributes.

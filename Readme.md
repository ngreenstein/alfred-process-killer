# Description
Kill Process is an Alfred 3 workflow that makes it easy to kill misbehaving processes. It is, in essence, a way to easily find processes by name and kill them using `kill -9`.

# Features
* Autocompletes process names
* Supports argument filtering (`process:arg`)
* Learns and prioritizes processes you kill frequently
* Shows icons when possible
* Shows CPU usage
* Shows process paths
* Ignores case
* Kills all processes with matching names on <kbd>cmd</kbd>+<kbd>return</kbd>
* Kills and relaunches a process on <kbd>shift</kbd>+<kbd>return</kbd>
* Supports [Alleyoop updating](http://www.alfredforum.com/topic/1582-alleyoop-update-alfred-workflows/).

![screenshot: `kill it`](screenshot1.png)
![screenshot: `kill chr:type=pp`](screenshot2.png)

# Usage
1. Type `kill` into Alfred followed by a space.
2. Begin typing the name of the process you want to kill.
3. When you see the process you want to kill, select it from the list as usual.
4. Press return to kill the selected process. Alternatively: 
  - Press <kbd>cmd</kbd>+<kbd>return</kbd> to kill all processes with the same name as the selected one.
  - Press <kbd>shift</kbd>+<kbd>return</kbd> to relaunch the selected process after killing it.

To filter by argument, add a colon and the argument you want to target (or a snippet of it) after your processes name (see the [second screenshot](screenshot2.png)).

# Installation
Download [version 1.2](https://github.com/ngreenstein/alfred-process-killer/blob/master/Kill%20Process.alfredworkflow?raw=true). Open `Kill Process.alfredworkflow` and Alfred will walk you through the installation process. No configuration is necessary.

# Making Changes
## Editing the Script
The ruby script that powers Kill Process is `script.rb`. For testing, add a value for `theQuery` in the first line. Be sure that the subsequent `theQuery = "{query}"` is commented out. This allows you to hard-code a search query instead of taking what the user has typed from Alfred. See the comments in the script for more info.

## Applying Changes to the Workflow
1. Be sure that the first line in the script setting `theQuery` is commented out and that the second line (`theQuery = "{query}"`) is not commented out.
2. Open the Workflows tab of Alfred's Preferences.
3. Select the Kill Process workflow on the left.
4. Double click the first box ('kill Script Filter').
5. Paste your script into the 'Script' box at the bottom.
6. Click Save.

## Alleyoop Support
If your updates are big enough to justify a new release, please update the Alleyoop support files for auto-updating.

1. Update `current-version.json` with the new version number (a float) and a short description of the changes.
2. Update `update.json` with the new version number.
3. **Copy the new update.json into the workflow's folder in Finder.**

# License
[WTFPL](http://www.wtfpl.net/about/), of course.

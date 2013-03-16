#Description
Kill Process is an Alfred 2 workflow that makes it easy to kill misbehaving processes. It is, in essence, a way to easily find processes by name and kill them using `kill -9`.

#Features
* Autocompletes process names
* Learns and prioritizes processes you kill frequently
* Shows icons when possible
* Shows CPU usage
* Shows process paths
* Ignores case
* Kills all processes with matching names on <kbd>cmd</kbd>+<kbd>return</kbd>

![screenshot: `kill it`](screenshot.png)

#Usage
1. Type `kill` into Alfred followed by a space.
2. Begin typing the name of the process you want to kill.
3. When you see the process you want to kill, select it from the list as usual.
4. Press return to kill the selected process.  
Alternatively, press <kbd>cmd</kbd>+<kbd>return</kbd> to kill all processes with the same name as the selected one.

#Installation
Open `Kill Process.alfredworkflow` and Alfred will walk you through the installation process. No configuration is necessary.

#Making Changes
##Editing the Script
The ruby script that powers Kill Process is `script.rb`. For testing, add a value for `theQuery` in the first line. Be sure that the subsequent `theQuery = "{query}"` is commented out. This allows you to hard-code a search query instead of taking what the user has typed from Alfred. See the comments in the script for more info.

##Applying Changes to the Workflow
1. Be sure that the first line in the script setting `theQuery` is commented out and that the second line (`theQuery = "{query}"`) is not commented out.
2. Open the Workflows tab of Alfred's Preferences.
3. Select the Kill Process workflow on the left.
4. Double click the first box ('kill Script Filter').
5. Paste your script into the 'Script' box at the bottom.
6. Click Save.

#License
[WTFPL](http://www.wtfpl.net/about/), of course.
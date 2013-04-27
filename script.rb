# Type a query to test with here.
# !!!!! Comment this line out when pasting into alfred preferences.
theQuery = "chr"
# Grab the query that the user typed (this is provided by Alfred).
# !!!!! Uncomment this line when pasting into Alfred Preferences.
#theQuery = "{query}"
# Search the query string for an argument filter (in the form of 'process:arg').
argsQuery = nil
if theQuery.include? ":"
  theQuery, argsQuery = theQuery.split(":")
end
# Assemble an array of each matching process. It will contain the process's path and percent CPU usage.
# The -A flag shows all processes. The -o pid, -o %cpu, and -o comm show only the process's PID, CPU usage and path, respectively.
# Grep for processes whose name contains the query. The regex isolates the name by only searching characters after the last slash in the path.
#  The -i flag ignores case.
processes = `ps -A -o pid -o %cpu -o comm | grep -i [^/]*#{Regexp.quote(theQuery)}[^/]*$`.split("\n")
# Start the XML string that will be sent to Alfred. This just uses strings to avoid dependencies.
xmlString = "<?xml version=\"1.0\"?>\n<items>\n"
processes.each do | process |
	# Extract the PID, CPU usage, and path from the line (lines are in the form of `123 12.3 /path/to/process`).
	processId, processCpu, processPath = process.match(/(\d+)\s+(\d+[\.|\,]\d+)\s+(.*)/).captures
	# If an argument filter has been specified, get the arguments and search for the filter.
	matchedArgs = []
  if argsQuery != nil
	  # Get the executable path and arguments for this process. Make an array with each argument that matches the search.
    matchedArgs = `ps -p #{processId} -o command`.scan(/\s+-{1,2}[^\s]*#{Regexp.quote(argsQuery)}[^\s]*/i)
    if matchedArgs.length < 1
	    next
	  end
  end
	# Use the same expression as before to isolate the name of the process.
	processName = processPath.match(/[^\/]*#{theQuery}[^\/]*$/i)
	# Search for an application bundle in the path to the process.
	iconValue = processPath.match(/.*?\.app\//)
	# The icon type sent to Alfred is 'fileicon' (taken from a file). This assumes that a .app was found.
	iconType = "fileicon"
	# If no .app was found, use OS X's generic 'executable binary' icon.
	# An empty icon type tells Alfred to load the icon from the file itself, rather than loading the file type's icon.
	if !iconValue
		iconValue = "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ExecutableBinaryIcon.icns"
		iconType = ""
	end
	# Assemble this item's XML string for Alfred. See http://www.alfredforum.com/topic/5-generating-feedback-in-workflows/
	thisXmlString = "\t<item uid=\"#{processName}\" arg=\"#{processId}\">
		<title>#{processName}#{matchedArgs.join(" ")}</title>
		<subtitle>#{processCpu}% CPU @ #{processPath}</subtitle>
		<icon type=\"#{iconType}\">#{iconValue}</icon>
	</item>\n"
	# Append this process's XML string to the global XML string.
	xmlString += thisXmlString
end
# Finish off and echo the XML string to Alfred.
xmlString += "</items>"
puts xmlString
#!/usr/bin/env ruby

class String
    # See https://www.unicode.org/versions/Unicode15.0.0/UnicodeStandard-15.0.pdf#page=355
    COMBINING_DIACRITICS = [*0x1DC0..0x1DFF, *0x0300..0x036F, *0xFE20..0xFE2F].pack('U*')

    def removeaccents
      self
        .unicode_normalize(:nfd) # Decompose characters
        .tr(COMBINING_DIACRITICS, '')
        .unicode_normalize(:nfc) # Recompose characters
    end
end

# ========================================

# Type a query to test with here.
# theQuery = "chröme"

# Comment this line if you are testing the script
theQuery = ARGV.join(" ")

# Search the query string for an argument filter (in the form of 'process:arg').
argsQuery = nil
if theQuery.include? ":"
    theQuery, argsQuery = theQuery.split(":")
end

# Make sure that searching for "Übersicht" matches "Ubersicht"
theQuery = theQuery.removeaccents

# Get list of processes, and skip the first entry (headers)
psOutput = `ps -A -o pid -o %cpu -o comm | tail -n +2`
psOutputFiltered = psOutput.removeaccents

# 29278   0.0 Core Audio Driver (NMAudioMic.driver)
processes = psOutputFiltered.scan(/^\s*\d+\s+(?:\d+[\.|\,]\d+)\s+[^\n]*#{Regexp.quote(theQuery)}[^\n]*$/im)

# Start the XML string that will be sent to Alfred. This just uses strings to avoid dependencies.
xmlString = "<?xml version=\"1.0\"?>\n<items>\n"

# Only iterate over the first 20 matched processes for performance reasons
processes.first(20).each do | process |
    processId = process.match(/^\s*(\d+)\s+[^\n]+$/m).captures.first

    # psOutput has the original name containing diacritics (e.g. Übersicht instead of Ubersicht)
    processCpu, processPath, processName = psOutput.match(/^\s*#{processId}\s+(\d+[\.|\,]\d+)\s+([^\n]*?\/?([^\n\/]+))$/im).captures

    # If an argument filter has been specified, get the arguments and search for the filter.
    matchedArgs = []

    if argsQuery != nil
        # Get the executable path and arguments for this process. Make an array with each argument that matches the search.
        matchedArgs = `ps -p #{processId} -o command`.scan(/\s+-{1,2}[^\s]*#{Regexp.quote(argsQuery)}[^\s]*/i)

        if matchedArgs.length < 1
            next
        end
    end
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

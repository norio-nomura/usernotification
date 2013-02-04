usernotification
================
Demonstrate how to post NSUserNotification from CLI(without Application Bundle) on OS X 10.8.

Install
-------
Clone repository and install `/usr/local/bin/usernotification`

	git clone https://github.com/norio-nomura/usernotification.git
	cd usernotification
	sudo xcrun xcodebuild clean install DSTROOT=/

Usage
-----

	Usage: usernotification [-identifier <identifier>] [-title <title>] [-subtitle <subtitle>] [-informativeText <text>]
	
	Options:
	    -identifier NAME        some existing app identifier(default: com.apple.finder)
	    -title TEXT             title text
	    -subtitle TEXT          subtitle text
	    -informativeText TEXT   informative text

License
-------

	(The WTFPL)
	
	            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
	                    Version 2, December 2004
	
	 Copyright (C) 2013 Norio Nomura
	
	 Everyone is permitted to copy and distribute verbatim or modified
	 copies of this license document, and changing it is allowed as long
	 as the name is changed.
	
	            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
	   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
	
	  0. You just DO WHAT THE FUCK YOU WANT TO.

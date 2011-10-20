ServerTools
===========

A ruby gem with useful tools for managing my, and probably also your, server.

virtualhosts
------------
Manage virtual hosts for Apache with ease.

This tool automates the steps described on [debian-administration.org](http://www.debian-administration.org/articles/412)
with a few simple commands:

	virtualhosts add VHOSTNAME
	virtualhosts enable VHOSTNAME
	virtualhosts disable VHOSTNAME
	virtualhosts remove VHOSTNAME
	
	
Dependencies
------------
ServerTools is builded on Thor. Make sure you have its gem installed, otherwise
do it with `gem install thor`

Credits
-------
Since I'm fairly new to Ruby, I'd like to thank espacially
[meskyanichi](https://github.com/meskyanichi) for sharing the code of
[meskyanichi/backup](https://github.com/meskyanichi/backup) which helped me
when I tried to understand some basic Ruby and Ruby Gem concepts.
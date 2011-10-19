ServerTools
===========

A small collection of useful (ruby) scripts which help to manage my vServer
instance.

VirtualHost.rb
--------------
This script supports the creation of virtual hosts for the Apache web server.
It automates the steps from the [Debian Administration article](http://www.debian-administration.org/articles/412)

Usage:

	ruby VirtualHost.rb --add www.myhost.com --serveradmin admin@myhost.com [--aliases myhost.com,...]

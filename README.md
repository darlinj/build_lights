build_lights
============

A small project to make build lights

The project is made up of 2 parts:
1. A sinatra app that reads a jenkins xml output and turns it into a single web page containing the word "red" or the word "green"
2. The arduino code to read the web page and show the correct light (in progress)

installation of sinatra app
===========================

1. Create an instance of an Ubuntu server on the cloud of your choice
2. SCP the install/install.sh script to the server
3. Run the script as root
4. Set up git?
5. On your local machine set up a remote for your server
6. git push build_lights_server master
7. Set the Url of your jenkins server xml feed in the config/config.rb file




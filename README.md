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
5. SCP the install/post-receive file to /home/build_lights/www/.git/hooks/
6. On your local machine set up a remote for your server
git remote add build_lights_server build_lights@<server>:www/
7. git push build_lights_server master
8. Set the Url of your jenkins server xml feed in the config/config.rb file




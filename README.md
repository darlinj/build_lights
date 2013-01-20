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
git push build_lights_server master
8. Set the Url of your jenkins server, the proxy and the proxy port in the config/config.yml file. There is a config/config.yml.example file to copy
9. As root, install thin
# thin install
10. install the version of rack that is included in your Gemfile
# gem install rack -v 1.4.1
11. copy the thin config file to the thin config directory
# cp /home/build_lights/www/thin_config/build_lights.yml /etc/thin/
12. start thin
#/etc/init.d/thin start




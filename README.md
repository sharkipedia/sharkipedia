# README

## Development setup

1. Ensure you have ruby (version 2.7.2) installed, for instructions see the
   [Install Rails Howto](http://installrails.com).
1. Ensure you have [node.js](https://nodejs.org/en/) installed
1. Ensure you have the postgresql database installed 
    - macOS: `brew install postgresql` then follow instructions
    - windows: https://www.postgresql.org/download/windows/, then follow
      instructions and make a note of the username & password
    - Linux: depending on your distribution install, configure and start
      postgresql:
	  	 1. Create user in posgres: `sudo -u postgres createuser username`
		 1. Give permission to user to create database:  `sudo -u postgres psql` and in the postgres terminal: `ALTER USER username CREATEDB;`

1. Clone the repository to your computer
   ```
   git clone https://github.com/sharkipedia/sharkipedia.git
   ```
1. Move into the project folder (`cd sharkipedia`)
1. Install project dependencies: `bundle install`
1. Windows/Linux: in the `config/database.yml` configure the username and
   password under development which you set during the installation of
   postgresql.
   macOS: if you installed postgres with `brew` you don't need to do anything,
   if you installed postgres in another way you might have to configure
   a username and password
1. Initialize the database `rake db:setup` (if this command throws an `role "username" does not exist` or `permission denied to create database` error, see above to create postgres user and give permission)
1. Run the rails server `rails server`
1. Connect to the application in your browser at `http://localhost:3000`


## Attributions

The original logo was taken from https://svgsilh.com/image/1085669.html

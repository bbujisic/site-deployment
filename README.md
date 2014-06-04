site-deployment
===============

Shell script for automated site deployment

The script is intended to automate following processes:
  * Creation of directory structure within /var/www for the site
  * Creation of appropriate config file in /etc/apache2/sites-available
  * Enabling the site in Apache2
  * Adding the site to the list of sites that need scheduled backup (@todo: add the backup script to this repo)
  * Creation of git repository in git user's home folder /home/git/
  * Creation of detached head logic in post-receive hook
  
Thing is still experimental.. use it for academic purposes only.

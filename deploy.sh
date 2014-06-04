#!/bin/sh

WWW_ROOT=/var/www
SITES_AVAILABLE=/etc/apache2/sites-available


GROUP="misc"
read -p "Enter site group [$GROUP]: " G
GROUP="${G:-$GROUP}"

NAME="test"
read -p "Enter site name [$NAME]: " N
NAME="${N:-$NAME}"

URL="$NAME.circlewf.com"
read -p "Enter site URL [$URL]: " U
URL="${U:-$URL}"

SITE="$GROUP/$URL"
WWW_DIRECTORY="$WWW_ROOT/$SITE"

echo "URL: $URL"
echo "DIR: $WWW_DIRECTORY"

# Check if site already exists in our little list
for DIRECTORY in `awk -F: '{print $1}' /root/sh/folders.txt`
do
 if [ $DIRECTORY = $SITE ]; then
   echo "[CRAP] Site already exists. Nothing happened. Choose another name and start over."
   exit
 fi

done

# Check if site definition in sites-available exists

if [ -f $SITES_AVAILABLE/$URL ]; then
  echo "[CRAP] Site alias already exists. Nothing happened. Consider another URL and start over."
  exit
fi

# create entry in our folders.txt file (for backup purposes)
echo "$SITE" >> /root/sh/folders.txt

# Create a directory for the site
mkdir -p $WWW_DIRECTORY
chmod 777 -R $WWW_DIRECTORY

# Create virtual host

cat > $SITES_AVAILABLE/$URL << EOF
<VirtualHost *:80>
  DocumentRoot $WWW_DIRECTORY
  ServerName $URL
  <Directory $WWW_DIRECTORY>
    allow from all
    Options +Indexes
  </Directory>
</VirtualHost>
EOF

a2ensite $URL
service apache2 reload


# Create a git repository repository
GIT="/home/git"
mkdir -p $GIT/$NAME.git
cd $GIT/$NAME.git
git init --bare
cat > $GIT/$NAME.git/hooks/post-receive << EOF
#!/bin/sh
GIT_WORK_TREE=$WWW_DIRECTORY git checkout -f
cowsay -f "$(ls /usr/share/cowsay/cows/ | sort -R | head -1)" "$(fortune -s)"
EOF
chmod +x $GIT/$NAME.git/hooks/post-receive
chown -R git:git $GIT/$NAME.git

# Print clone instructions



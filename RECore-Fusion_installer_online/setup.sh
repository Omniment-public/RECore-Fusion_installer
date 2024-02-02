#!/bin/bash
# RECore Fusion Init setup script

DUMMY_VERSION="v0.0.0"

NAME_SYS="RECore-Fusion_sys"
SYS_REPO_INFO="Omniment-public/RECore-Fusion_sys"

NAME_JUPYTER="recore-jupyter"
NAME_APP="recore-jupyter"
JUPYTER_REPO_INFO="Omniment-public/RECore-Fusion_jupyter"

RECORE_DIR="/usr/local/bin/recore"
SYS_DIR=$RECORE_DIR"/files"
INSTALL_DIR="/usr/local/bin/recore/install"
REGIST_DIR=$SYS_DIR"/app"
INSTALL_QUEUE=$INSTALL_DIR"/install_queue"

# check root
if [ "$(id -u)" -ne 0 ]; then
	echo "Please run root user"
	exit 1
fi

echo "make dir"
mkdir $RECORE_DIR
mkdir $SYS_DIR
mkdir $INSTALL_DIR
mkdir $REGIST_DIR

sudo bash -c "echo '' > $INSTALL_QUEUE"
chmod 777 $INSTALL_QUEUE

# set permission
chmod 777 /etc/hosts
chmod 777 /etc/hostname
chmod 777 /usr/local/bin/recore/install
chmod 777 /usr/local/bin/recore/install/install_queue

#move sys file
echo "move sys file"
chmod +x ./boot_recore.sh
chmod +x ./update.sh
chmod +x ./blink.sh
chmod +x ./rc.local
chmod +x ./exec_update.py

mv -f ./boot_recore.sh $SYS_DIR
mv -f ./update.sh $SYS_DIR
mv -f ./blink.sh $SYS_DIR
mv -f ./rc.local /etc/

# write dummy version
sudo bash -c "echo 'version=\"'$DUMMY_VERSION'\"' > $REGIST_DIR/$NAME_SYS"
sudo bash -c "echo 'repo=\"'$SYS_REPO_INFO'\"' >> $REGIST_DIR/$NAME_SYS"

sudo bash -c "echo 'version=\"'$DUMMY_VERSION'\"' >> $REGIST_DIR/$NAME_APP"
sudo bash -c "echo 'repo=\"'$JUPYTER_REPO_INFO'\"' >> $REGIST_DIR/$NAME_APP"

python ./exec_update.py

rm ../RECore-Fusion_setup_online.tar.gz
rm -rf ../RECore-Fusion_setup_online

reboot

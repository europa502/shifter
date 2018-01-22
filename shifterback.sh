#! /bin/bash

$folderpath
$change
images=`ls $folderpath`
while true ;
	do
		for image in $images ; do
			gsettings set org.gnome.desktop.background picture-uri file://$folderpath/$image
			sleep $change
		done
	done

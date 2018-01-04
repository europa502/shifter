#! /bin/bash

echo "					        ______________________________________________  "
echo "					      /|					      | "
echo "					     / |  ___					/\    | "
echo "					    |  | |				       /  \   | "
echo "					    |  | |___	      __ _ _  __  __	      /_  _\  |	"
echo "					    |  |     | |_| | |_   |  |_	 |__)	        ||    | "
echo "					    |  |  ___| | | | |    |  |__ | \            ||    | "
echo "					    |  |______________________________________________| "
echo "					    | /						     /	"
echo "					    |/______________________________________________/	"
echo ""
echo ""

option=$1
echo $option

echo $imagepath

if [ " $option " = ' -b ' ] || [ " $option " = ' --change-boot-background ' ] ; then

	imagepath=$2
	if [ -z " $imagepath " ] ; then
		echo $imagepath
		echo "No image path specified "
		exit 2	
	fi
	shifter_path="\/usr\/share\/shifter\/image.jpg"
	mkdir -p /usr/share/shifter/
	magick convert $imagepath -depth 8 -colorspace RGB /usr/share/shifter/image.jpg
 	#cp $imagepath /usr/share/shifter/image.jpg
 
	if [ ! -f " /boot/grub/grubcopy.cfg " ] ; then
		cp /boot/grub/grub.cfg /boot/grub/grubcopy.cfg

	fi
	line=`grep -n -r "background_image" "/boot/grub/grub.cfg"`
	lineno=${line%:*}  #take out the line number from string 
	lineno=$lineno's'
	linetext=${line##*:} # read the text in the line 
	firsttxt=${linetext% /*} #read the chars before the image path 
	lasttxt=${linetext##*;}
	sed -i "$lineno/.*/$firsttxt $shifter_path;$lasttxt/" /boot/grub/grub.cfg
	echo "Boot background has been changed. Cheers!!"

elif [[ " $option " = ' -d ' ]] || [[ " $option " = ' --change-desktop-background ' ]] ; then
	imagepath=$2	
	if [ -z " $imagepath " ] ; then
		echo $imagepath
		echo "No image path specified "

	fi
	gsettings set org.gnome.desktop.background picture-uri file://$imagepath
	echo "Desktop background has been changed"

elif [[ " $option " = ' -r ' ]] || [[ " $option " = ' --reset ' ]] ; then
	
	update-grub 

elif [[ " $option " = ' -i ' ]] || [[ " $option " = ' --install ' ]] ; then

		if [ ! -f " /usr/share/shifter/ " ] ; then
			echo "Installing packages - build-essential, checkinstall, libx11-dev, libxext-dev, zlib1g-dev, libpng12-dev, libjpeg-dev, libfreetype6-dev, libxml2-dev "
			sudo apt-get install build-essential checkinstall libx11-dev libxext-dev zlib1g-dev libpng12-dev libjpeg-dev libfreetype6-dev libxml2-dev

			echo "Setting up ImageMagick..."
			echo "It might take a while.... Go have a cup of tea, or ... coffee or.. anything..... "
			tar xvzf ImageMagick.tar.gz			
			cd ImageMagick-7.0.7-19
			./configure
			make
			sudo make install
			sudo ldconfig /usr/local/lib
			/usr/local/bin/convert logo: logo.gif
			make check
			echo "Completed Installation."	

elif [[ " $option " = ' -h ' ]] || [[ " $option " = ' --help ' ]] ; then
 	
	echo "Usage - bash ./shifter.sh [option] [imagepath]  "
	echo "Options-  "
	echo "	-b	--change-boot-backround 	- To change the boot background "
	echo "	-d	--change-desktop-background	- To change desktop background "
	echo "	-r	--reset				- To reset grub config file to the default condition "

else 
 	
	echo "Usage - bash ./shifter.sh [option] [imagepath]  "
	echo "refer bash ./shifter.sh -h for more options"


fi

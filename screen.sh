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
imagepath=$2

shifter_path="\/usr\/share\/shifter\/image.jpg"

mkdir -p /usr/share/shifter/shifter/
cp $imagepath /usr/share/shifter/image.jpg
 
if [ ! -f " /boot/grub/grubcopy.cfg " ] ; then
	cp /boot/grub/grub.cfg /boot/grub/grubcopy.cfg

fi

if [ " $option " = ' -c ' ] || [ " $option " = ' --change-background ' ] ; then
	if [ -z " $imagepath " ] ; then
		echo $imagepath
		echo "No image path specified "
		exit 2	
	fi
	

	line=`grep -n -r "background_image" "/boot/grub/grub.cfg"`
	lineno=${line%:*}  #take out the line number from string 
	lineno=$lineno's'
	linetext=${line##*:} # read the text in the line 
	firsttxt=${linetext% /*} #read the chars before the image path 
	lasttxt=${linetext##*;}
	sed -i "$lineno/.*/$firsttxt $shifter_path;$lasttxt/" /boot/grub/grub.cfg


else if [ " $option " = ' -h ' ] || [ " $option " = ' --help ' ] ; then
 	
	echo "Usage - bash ./shifter.sh [option] [imagepath]  "
	echo "Options-  "
	echo "-c	--change-backround 	- To change the boot background "

else 
 	
	echo "Usage - bash ./shifter.sh [option] [imagepath]  "


fi
fi

#! /bin/bash

echo "					        ______________________________________________  "
echo "					       |					      | "
echo "					       |  ___ 		        		/\    | "
echo "					       | |		       		       /  \   | "
echo "					       | |___	      __ _ _  __  __	      /_  _\  |	"
echo "					       |     | |_| | |_   |  |_	 |__)	        ||    | "
echo "					       |  ___| | | | |    |  |__ | \            ||    | "
echo "					       |______________________________________________| "


option=$1
imagepath=$2

if [ !/boot/grub/grubcopy.cfg ] ; then
	cp /boot/grub/grub.cfg /boot/grub/grubcopy.cfg

fi

if [ ' $option ' == " -c " ] || [ ' $option ' == " --change-background " ] ; then

	line=`grep -n -r "background_image" "/boot/grub/grub.cfg" `
	lineno= ${line%:*}  #take out the line number from string 
	linetext=${line##*:} # read the text in the line 
	firsttxt=${linetext% /*} #read the chars before the image path 
	lasttxt=${linetext##*;}
	sed -i "${lineno}s/.*/$firsttxt $imagepath ; $lasttxt/" /boot/grub/grub.cfg


else if [ ' $option ' == " -h " ] || [ ' $option ' == " --help " ] ; then
 	
	echo "Usage - bash ./shifter.sh [option] [imagepath]  "

fi


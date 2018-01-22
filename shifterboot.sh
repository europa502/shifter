#! /bin/bash

imagepath=$2
folderpath=$2
change=$4
shifter_path="\/usr\/share\/shifter\/image.jpg"
#editing grub.cfg  
currentimage=`ls $folderpath -p | grep -v / | shuf -n 1`
magick convert $currentimage -depth 8 -colorspace RGB /usr/share/shifter/image.png
line=`grep -n -r "background_image" "/boot/grub/grub.cfg"`
lineno=${line%:*}  #take out the line number from string 
lineno=$lineno's'  #add s to the line number
linetext=${line##*:} # read the text in the line 
firsttxt=${linetext% /*} #read the chars before the image path 
lasttxt=${linetext##*;}
sed -i "$lineno/.*/$firsttxt $shifter_path;$lasttxt/" /boot/grub/grub.cfg #write everything back to the grub.cfg file.
				

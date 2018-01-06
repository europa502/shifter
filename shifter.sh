#! /bin/bash
clear

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

currdir=`pwd`/shifter.sh
currdir="${currdir//\//\\/}"
echo $currdir
option=$1

if [ " $option " = ' -b ' ] || [ " $option " = ' --change-boot-background ' ] ; then
	echo "Changing boot background"
	imagepath=$2
	folderpath=$2
	change=$4
	shifter_path="\/usr\/share\/shifter\/image.jpg"
	if [ -z " $imagepath " ] ; then
		echo $imagepath
		echo "No image path specified "
		exit 2	
	fi

	if [ ' $change ' = ' true ' ] ; then
		images=`ls $folderpath`	

		cp shifterboot.conf /etc/init/shifterboot.conf

		sed -i "5s/.*/exec $currdir -b $folderpath -c true/" /etc/init/shifterboot.conf	#change the directory at shifterboot.conf file to the working dir
		
		#editing grub.cfg  
		currentimage=`ls -p | grep -v / | shuf -n 1`	
	
		mkdir -p /usr/share/shifter/
		magick convert $currentimage -depth 8 -colorspace RGB /usr/share/shifter/image.png
		line=`grep -n -r "background_image" "/boot/grub/grub.cfg"`
		lineno=${line%:*}  #take out the line number from string 
		lineno=$lineno's'  #add s to the line number
		linetext=${line##*:} # read the text in the line 
		firsttxt=${linetext% /*} #read the chars before the image path 
		lasttxt=${linetext##*;}
		sed -i "$lineno/.*/$firsttxt $shifter_path;$lasttxt/" /boot/grub/grub.cfg #write everything back to the grub.cfg file.
				
		
	elif [ ' $change ' = ' false ' ] ; then
		rm -f /etc/init/shifterboot.conf 
		mkdir -p /usr/share/shifter/
		magick convert $imagepath -depth 8 -colorspace RGB /usr/share/shifter/image.png
		rm -f /etc/init/shifterboot.conf 	
	 
		if [ ! -f " /boot/grub/grubcopy.cfg " ] ; then
			cp /boot/grub/grub.cfg /boot/grub/grubcopy.cfg

		fi
		line=`grep -n -r "background_image" "/boot/grub/grub.cfg"`
		lineno=${line%:*}  #take out the line number from string 
		lineno=$lineno's'
		linetext=${line##*:} # read the text in the line 
		firsttxt=${linetext% /*} #read the chars before the image path 
		lasttxt=${linetext##*;}
		sed -i "$lineno/.*/$firsttxt $shifter_path;$lasttxt/" /boot/grub/grub.cfg #write everything back to the grub.cfg file.
		echo "Boot background has been changed. Cheers!! "	
	fi

	mkdir -p /usr/share/shifter/
	magick convert $imagepath -depth 8 -colorspace RGB /usr/share/shifter/image.png
	rm -f /etc/init/shifterboot.conf 	
 
	if [ ! -f " /boot/grub/grubcopy.cfg " ] ; then
		cp /boot/grub/grub.cfg /boot/grub/grubcopy.cfg

	fi
	line=`grep -n -r "background_image" "/boot/grub/grub.cfg"`
	lineno=${line%:*}  #take out the line number from string 
	lineno=$lineno's'
	linetext=${line##*:} # read the text in the line 
	firsttxt=${linetext% /*} #read the chars before the image path 
	lasttxt=${linetext##*;}
	sed -i "$lineno/.*/$firsttxt $shifter_path;$lasttxt/" /boot/grub/grub.cfg #write everything back to the grub.cfg file.
	echo "Boot background has been changed. Cheers!! "
#..........................................................................................................................................

elif [[ " $option " = ' -d ' ]] || [[ " $option " = ' --change-desktop-background ' ]] ; then
	echo "Changing desktop background."
	folderpath=$2
	imagepath=$2
	ol=$3
	change=0	
	change=`expr $4 + 0`
	
	if [ -z " $imagepath " ] ; then
		echo $imagepath
		echo "No image path specified "

	fi
	
	
	if [ " $change " -gt  " 0 " ] ; then
		
		cp shifterback.conf /etc/init/shifterback.conf
		images=`ls $folderpath`
		folderpath="${folderpath//\//\\/}"

		sed -i "5s/.*/exec $currdir -d $folderpath -c $change/" /etc/init/shifterback.conf	#change the directory at shifterboot.conf file to the working dir

		
		while true ;
			do

				for image in $images ; do
					gsettings set org.gnome.desktop.background picture-uri file://$imagepath/$image
					sleep $change
				done
		done
	
	fi

	gsettings set org.gnome.desktop.background picture-uri file://$imagepath
	echo "Desktop background has been changed"
#...........................................................................................................................................
elif [[ " $option " = ' -r ' ]] || [[ " $option " = ' --reset ' ]] ; then
	
	update-grub 
#............................................................................................................................................
elif [[ " $option " = ' -i ' ]] || [[ " $option " = ' --install ' ]] ; then

		if [ ! -f " /usr/share/shifter/ " ] ; then
			echo "Installing packages - build-essential, checkinstall, libx11-dev, libxext-dev, zlib1g-dev, libpng12-dev, libjpeg-dev, libfreetype6-dev, libxml2-dev "
			sudo apt-get install build-essential checkinstall libx11-dev libxext-dev zlib1g-dev libpng12-dev libjpeg-dev libfreetype6-dev libxml2-dev

			echo "Setting up ImageMagick..."
			echo "It might take a while.... Go have a cup of tea, or... coffee or... anything..... "
			tar xvzf ImageMagick.tar.gz			
			cd ImageMagick-7.0.7-19
			./configure
			make
			sudo make install
			sudo ldconfig /usr/local/lib
			/usr/local/bin/convert logo: logo.gif
			make check
			echo "Completed Installation."
		#else echo "Install  build-essential, checkinstall, libx11-dev, libxext-dev, zlib1g-dev, libpng12-dev, libjpeg-dev, libfreetype6-dev, libxml2-dev and ImageMagick-7.0.7-19 manually"


		fi
			

elif [[ " $option " = ' -h ' ]] || [[ " $option " = ' --help ' ]] ; then
 	
	echo "Usage - bash ./shifter.sh [option] [imagepath/folderpath] [suboption]  "
	echo "Options-  "
	echo "	-b	--change-boot-backround 	- To change the boot background "
	echo "	-d	--change-desktop-background	- To change desktop background "
	echo "	-r 	--reset				- To reset grub configurations "
	echo "	-i	--install			- To install ImageMagic and other prerequisites"
	echo ""
	echo "Suboptions-	"
	echo ""
	echo "	with -b[option] /path/to/image/folder/ -c 4[value > 0]		- To change the desktop background in n seconds	"
	echo "		Example- 	bash ./shifter.sh -b /absolute/path/to/images/folder/ -c 20 	-Changes background in every 20 seconds"
	echo ""
	echo "	with -d[option] /path/to/image/folder/ -c true			- To change the boot background everytime you boot"
	echo "	with -d[option] /path/to/image/folder/ -c false			- To keep the boot background static."
 	echo "		Example-	bash ./shifter.sh -d /absolute/path/to/images/folder/ -c true	"

else 
 	
	echo "Usage - bash ./shifter.sh [option] [imagepath]  "
	echo "refer bash ./shifter.sh -h for more options"


fi

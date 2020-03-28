#! /bin/sh
start=$SECONDS

git_repo=(
'https://aur.archlinux.org/stm32cubemx.git'             # STM32CubeMX
'https://aur.archlinux.org/ncurses5-compat-libs.git' # ncurses5-compat-libs
'https://aur.archlinux.org/google-chrome.git'           # Google-Chrome
'https://aur.archlinux.org/stm32pio.git'                # STM32pio
)               

need_package=(
'java-environment-common' 
'jre8-openjdk'
'jre8-openjdk-headless' 
'jdk8-openjdk' 
'c-ares' 
'electron6' 
'ripgrep' 
'jre11-openjdk' 
'code' 
'linux-virtualbox-host'
)
tool_chain=(
'openocd' 
'gdb' 
'arm-none-eabi-gcc'
'arm-none-eabi-gdb' 
'python-pyserial' 
'arm-none-eabi-newlib'
)

software_list=(
'vim' 'octave' 'arduino' 'gimp' 'stlink' 'code' 'qbittorrent' 'wireshark-qt' 'virtualbox'
'mutt' 'neomutt' 'cheese' 'timeshift' 'etcher' 'gparted' 'grub-customizer' 'clementine'
)

remove_list=(
'hplip' 'thunderbird' 'yakuake' 'skanlite' 'firefox' 'konversation' 
)

pip_list=(
'pwerline-shell' 'platformio'
)

# Afiliate command
UPDATE="update"
installing_deps(){
    for package in ${need_package[@]}
    do
        install --needed $package --noconfirm
    done
}

installing_toolchain(){
    for list in ${tool_chain[@]}
    do
        install --needed $list --noconfirm
    done    
}

installing_software(){
    for id in ${software_list[@]}
    do
        install --needed $id --noconfirm
    done
}

removing_software(){
    for item in ${remove_list[@]}
    do
        install --needed $item --noconfirm
    done    
}

installing_pip_package(){
    for pip in ${pip_list[@]}
    do
        sudo pip install -U 
    done  
}

aur_clone(){
    for repo in ${git_repo[@]}
    do
    git clone $repo
    # New way of using shell parameter expansion
    name=$(echo "${repo##*/}" | cut -f1 -d".") # Basically echo the repo url. With 2 ##
                                               # it skip  until it reach / 2 times then pipe it to cut command 
                                               #using -d to choose the dot as field seperator and -f1 to choose field 1
                                               # " * " mean to  
    cd $name 
    makepkg -si
    cd ..
    sudo rm -r $name
    done
}

bash_command(){
    echo -e 'alias install="sudo pacman -S"\nalias update="sudo pacman -Syu"\nalias remove="sudo pacman -Rs"\nalias search="pacman -Ss"\nalias st="st-flash"'>>.bash_aliases
    echo -e 'function_update_ps1() {\n    PS1=$(powerline-shell $?)\n}\n'>>.bashrc
    echo -e 'if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then\n    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND" \nfi\n'>>.bashrc
    echo -e 'if [ -f ~/.bash_aliases ]; then\n. ~/.bash_aliases\nfi\n'>>.bashrc
}

#bash_command                                    # Add some pre-define alias and edit bashrc
#sudo modprobe cdc_acm vboxdrv                   # Loading kernel module
#sudo usermod -aG uucp,lock john                 # Adding user to group

# Update Manjaro 

#removing_software
#update -Syu --noconfirm
#sudo pip install --upgrade pip

#installing_deps                                 # Install dependencies
#installing_toolchain                            # Toolchain
#aur_clone                                       # Clonning stuff from git and start installing
#installing_pip_package                          # Installing pip packages
#installing_software                             # Some software that I like to use

# Remove some left over cache

#sudo pacman -Sc --noconfirm

######################################################### Dialog #######################################################################################################################


declare PACKAGES=("installing_deps"  "installing_toolchain"  "installing_pip_package"  "installing_software")
NUM_PACKAGES=${#PACKAGES[*]} # no. of packages to update (#packages in the array $PACKAGES)
step=$((100/$NUM_PACKAGES))  # progress bar step
cur_file_idx=0
counter=0
(
# infinite while loop
while :
do
    cat <<EOF
XXX
$counter
$counter% upgraded

$COMMAND
XXX
EOF
    COMMAND="${PACKAGES[$cur_file_idx]} $DEST &>/dev/null" # sets/updates command to exec.
    [[ $NUM_PACKAGES -lt $cur_file_idx ]] && $COMMAND # executes command

    (( cur_file_idx+=1 )) # increase counter
    (( counter+=step ))
    [ $counter -gt 100 ] && break  # break when reach the 100% (or greater
                                   # since Bash only does integer arithmetic)
    sleep 10 # delay it a specified amount of time i.e. 1 sec
done
) |



intro_setup (){
	exec 3>&1
	status=$(dialog --backtitle 'Embedded Wizard ' \
		--title 'Setup' \
		--menu 'Hi, Welcome to the Embedded Wizard. This wizard will automate the process of upgrading the system, downloading all necessary repository and remove all unecessary stuff from your system please choose the following option:' 20 70 20 "I" "Update the system" "II" "Initialize the wizard" "III" "Remove stuff" 2>&1 1>&3 );	
}

wizard_setup(){
    exec 3>&1
    choices=$(dialog --separate-output \
        --checklist 'Select Option' 22 76 16 1 'Download git repository and install' off 2 'Loading Kernel Module' off 3 'Download packages and install' off 4 'Clean Cache' off  2>&1 1>&3)
    for choice in $choices
    do
        case $choice in
            1) aur_clone;
			dialog --title 'Status' --msgbox 'Done';; 
            2) sudo modprobe cdc_acm vboxdriver &>> module.tmp 
			dialog --title 'Progress' --textbox module.tmp 10 55;;
            3) dialog --clear --title 'Processing' \
            --gauge 'Please wait...' 10 70 0;;
            4) sudo pacman -Sc --noconfirm &>> clean.tmp
            dialog --msgbox 'Done' 10 30;;
	        255) dialog --msgbox 'Noticed' 10 30;;
        esac
    done
}

## User code begin ##

while : 
do
	intro_setup
	if [ "$status" == "I" ]
	then
		dialog --clear --title 'Processing' \
			--infobox 'Updating...' 10 50
		
					$UPDATE &> update.tmp && dialog --clear --title 'Progress' --textbox update.tmp 10 55
				
	elif [ "$status" == "II"  ]
	then
		dialog --clear --title 'Processing' \
			--sleep 2\
			--infobox 'Working right now' 10 30
					wizard_setup
					dialog --msgbox 'Done' 10 30;clear
	elif [ "$status" == "III"  ]
	then
		dialog --clear --title 'Processing'\
			-sleep 2\
			--infobox 'Removing right now' 10 30
            removing_software &> remove.tmp && dialog --sleep 2 --infobox 'Finished removing stuff' 10 30;clear
	else
	       dialog --infobox 'Have a nice day' 10 30	
		break;
	fi
done

clear



 

#! /bin/sh
# Begin code
start=$SECONDS

git_repo=(
'https://aur.archlinux.org/stm32cubemx.git'             # STM32CubeMX
'https://aur.archlinux.org/ncurses5-compat-libs.git'    # ncurses5-compat-libs
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

# Start doing shit
bash_command                                    # Add some pre-define alias and edit bashrc
sudo modprobe cdc_acm vboxdrv                   # Loading kernel module
sudo usermod -aG uucp,lock john                 # Adding user to group

# Update Manjaro 

removing_software
update -Syu --noconfirm
sudo pip install --upgrade pip
#############################################################################################################################################################################

installing_deps                                 # Install dependencies
installing_toolchain                            # Toolchain
aur_clone                                       # Clonning stuff from git and start installing
installing_pip_package                          # Installing pip packages
installing_software                             # Some software that I like to use

# Remove some left over cache

sudo pacman -Sc --noconfirm
echo "All completed it took $((SECONDS - start)) seconds to complete"
 
#####################################################################################################################################################################################################

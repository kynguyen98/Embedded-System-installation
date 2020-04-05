 ________  _________ _________________ ___________   _______   _______ _____ ________  ___  _____ _   _  _____ _____ ___   _      _      ___________ 
|  ___|  \/  || ___ \  ___|  _  \  _  \  ___|  _  \ /  ___\ \ / /  ___|_   _|  ___|  \/  | |_   _| \ | |/  ___|_   _/ _ \ | |    | |    |  ___| ___ \
| |__ | .  . || |_/ / |__ | | | | | | | |__ | | | | \ `--. \ V /\ `--.  | | | |__ | .  . |   | | |  \| |\ `--.  | |/ /_\ \| |    | |    | |__ | |_/ /
|  __|| |\/| || ___ \  __|| | | | | | |  __|| | | |  `--. \ \ /  `--. \ | | |  __|| |\/| |   | | | . ` | `--. \ | ||  _  || |    | |    |  __||    / 
| |___| |  | || |_/ / |___| |/ /| |/ /| |___| |/ /  /\__/ / | | /\__/ / | | | |___| |  | |  _| |_| |\  |/\__/ / | || | | || |____| |____| |___| |\ \ 
\____/\_|  |_/\____/\____/|___/ |___/ \____/|___/   \____/  \_/ \____/  \_/ \____/\_|  |_/  \___/\_| \_/\____/  \_/\_| |_/\_____/\_____/\____/\_| \_|
                                                                                                                                                     
                                                                                                                                                     
                                                                                                                                                     
                                                                                                                                                     
                                                                                                                                                     
                                                                                                                                                     
                                                                                                                                                     
                                                                                                                                                     
                                                                                                                                                     
                                                                                                                                                     
 _             _   __        _   _                                                                                                                   
| |           | | / /       | \ | |                                                                                                                  
| |__  _   _  | |/ / _   _  |  \| | __ _ _   _ _   _  ___ _ __                                                                                       
| '_ \| | | | |    \| | | | | . ` |/ _` | | | | | | |/ _ \ '_ \                                                                                      
| |_) | |_| | | |\  \ |_| | | |\  | (_| | |_| | |_| |  __/ | | |                                                                                     
|_.__/ \__, | \_| \_/\__, | \_| \_/\__, |\__,_|\__, |\___|_| |_|                                                                                     
        __/ |         __/ |         __/ |       __/ |                                                                                                
       |___/         |___/         |___/       |___/                                                                                                 





#! /bin/sh
# Begin code
start=$SECONDS

git_repo=(
'https://aur.archlinux.org/stm32cubemx.git'             # STM32CubeMX
'https://aur.archlinux.org/ncurses5-compat-libs.git'    # ncurses5-compat-libs
'https://aur.archlinux.org/google-chrome.git'           # Google-Chrome
'https://aur.archlinux.org/stm32pio.git'                # STM32pio
'http://aur.archlinux.org/packages/cpupower-gui'	    # cpu power control	
'http://aur.archlinux.org/packages/cattle'	            # toolkit for brainfuck programing language
'http://aur.archlinux.org/packages/mdk4'                # exploit common IEEE 802.11 protocol weaknesses
			
)               

need_package=(
'java-environment-common' 
'jre8-openjdk'
'jre8-openjdk-headless' 
'jdk8-openjdk' 
'c-ares'  
'ripgrep' 
'jre11-openjdk'  
'linux-virtualbox-host'
'nvim'
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
'vim' 'octave' 'code' 'unrar' 'arduino' 'gimp' 'stlink' 'code' 'qbittorrent' 'wireshark-qt' 'virtualbox'
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
    echo -e "call plug#begin('~/local/share/nvim/plugged')\nPlug 'neoclide/coc.nvim', {'branch': 'release'}\ncall plug#end()"\
	    >>~/.config/nvim/init.vim

}

initializing_setup(){
su
curl -sL install-node.now.sh/lts | bash --noconfirm
bash_command                                    # Add some pre-define alias and edit bashrc
sudo modprobe cdc_acm vboxdrv                   # Loading kernel module
sudo usermod -aG uucp,lock john                 # Adding user to group
}

initializing_setup 				# Start doing shit

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

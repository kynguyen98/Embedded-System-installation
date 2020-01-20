#! /bin/sh
# Begin code
start=$SECONDS

# Loading kernel module
sudo modprobe cdc_acm vboxdrv

# Adding user to group
sudo usermod -aG uucp,lock john

# Update Manjaro
sudo pacman -Rs hplip thunderbird yakuake skanlite firefox konversation --noconfirm
sudo pacman -Syu --noconfirm

# Install dependencies
sudo pacman -S java-environment-common jre8-openjdk jre8-openjdk-headless jdk8-openjdk c-ares electron6 ripgrep jre11-openjdk code linux54-virtualbox-host-modules linux54-headers --noconfirm

# Toolchain
sudo pacman -S openocd gdb arm-none-eabi-gcc arm-none-eabi-gdb python-pyserial arm-none-eabi-newlib --noconfirm

# Clonning stuff from git 
git clone https://aur.archlinux.org/stm32cubemx.git
git clone https://aur.archlinux.org/sw4stm32.git
git clone https://aur.archlinux.org/ncurses5-compat-libs.git
git clone https://github.com/kynguyen98/Simple-Mutt-config.git
git clone https://aur.archlinux.org/google-chrome.git

# Start installing 
cd stm32cubemx
makepkg -si --noconfirm
cd ..

cd sw4stm32
makepkg -si --noconfirm
cd ..

cd ncurses5-compat-libs
makepkg -si --noconfirm
cd..

mkdir ~/.config/mutt

cd Simple-Mutt-config
sudo cp color.muttrc mailcap muttrc ~/.config/mutt
cd ..

cd google-chrome
makepkg -si --noconfirm
cd ..

# Some software that I like to use
sudo pacman -S vim octave arduino gimp stlink code qbittorrent wireshark-qt virtualbox mutt neomutt --noconfirm

# Remove some left over folder 
sudo rm -r -f stm32cubemx
sudo rm -r -f sw4stm32
sudo rm -r -f Simple-Mutt-config
sudo rm -r -f google-chrome
sudo pacman -Sc --noconfirm
echo "All completed it took $((SECONDS - start)) seconds to complete"
 

#! /bin/sh
# Begin code
start=$SECONDS
# Update Manjaro
echo "Removing all bloatware"
sudo pacman -Rs hplip thunderbird yakuake skanlite firefox konversation --noconfirm
sudo pacman -Syu --noconfirm

# Install dependencies
sudo pacman -S java-environment-common jre8-openjdk jre8-openjdk-headless jdk8-openjdk c-ares electron6 ripgrep jre11-openjdk code linux54-virtualbox-host-modules linux54-headers --noconfirm

echo "Updating completed"

# Toolchain
echo "Installing ARM toolchain......"
sudo pacman -S openocd gdb arm-none-eabi-gcc arm-none-eabi-gdb python-pyserial arm-none-eabi-newlib --noconfirm
echo "Toolchain completed"

# IDE
echo "Installing Embedded System IDE"
echo "Installing STM32CubeMX"
git clone https://aur.archlinux.org/stm32cubemx.git
cd stm32cubemx
makepkg -si
cd ..
echo "STM32CubeMX installed"

echo "Installing Arduino..."
sudo pacman -S arduino --noconfirm
sudo usermod -aG uucp,lock john
sudo modprobe cdc_acm vboxdrv
echo "Arduino installed"
echo "Installing stlink..."
sudo pacman -S stlink --noconfirm
echo "STlink installed"
echo "Installing VSCode..."
sudo pacman -S code --noconfirm
echo "VSCode installed"
echo "Installing SW4STM32..."
git clone https://aur.archlinux.org/sw4stm32.git
cd sw4stm32
makepkg -si
cd ..
echo "SW4STM32 installed"
echo "Installing Daily stuff..."
sudo pacman -S qbittorrent wireshark-qt virtualbox mutt neomutt --noconfirm

# Generating neomutt config file
mkdir ~/.config/mutt
git clone https://github.com/kynguyen98/Simple-Mutt-config.git
cd Simple-Mutt-config
sudo cp color.muttrc mailcap muttrc ~/.config/mutt
cd ..

# Daily stuff installing
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome
makepkg -si
cd ..
echo "Chrome installed"
sudo pacman -S gimp --noconfirm
echo "Daily stuff installed"
echo "Installing Octave..."
sudo pacman -S octave --noconfirm
echo "Octave installed"
sudo rm -r stm32cubemx
sudo rm -r sw4stm32
sudo rm -r Simple-Mutt-config
sudo rm -r google-chrome
echo "cleaning cache"
sudo pacman -Sc --noconfirm
echo "All completed it took $((SECONDS - start)) seconds to complete"
 

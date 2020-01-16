#! /bin/sh
# Begin code

# Update Manjaro
sudo pacman -Syu --noconfirm

echo "Updating completed"
sleep 3
# Toolchain
echo "Installing ARM toolchain......"
sudo pacman -S openocd gdb arm-none-eabi-gcc arm-none-eabi-gdb python-pyserial arm-none-eabi-newlib --noconfirm
echo "Toolchain completed"
sleep 3
# IDE
echo "Installing Embedded System IDE"
echo "Installing STM32CubeMX"
git clone https://aur.archlinux.org/stm32cubemx.git
cd stm32cubemx
makepkg -si
cd ..
m -r stm32cubemx
echo "STM32CubeMX installed"
sleep 1
echo "Installing Arduino..."
sudo pacman -S arduino --noconfirm
sudo usermod -aG uucp, lock john
sudo modprobe cdc_acm
echo "Arduino installed"
sleep 1
echo "Installing stlink..."
sudo pacman -S stlink --noconfirm
echo "STlink installed"
sleep 1
echo "Installing VSCode..."
sudo pacman -S code --noconfirm
echo "VSCode installed"
sleep 1
echo "Installing SW4STM32..."
git clone https://aur.archlinux.org/sw4stm32.git
cd sw4stm32
makepgk -si
cd ..
rm -r sw4stm32
echo "SW4STM32 installed"
sleep 1
echo "Installing Daily stuff..."
sudo pacman -S qbittorrent wireshark-qt virtualbox mutt neomutt --noconfirm

# Generating neomutt config file
mkdir ~/.config/mutt
git clone https://github.com/kynguyen98/Simple-Mutt-config.git
cd Simple-Mutt-config
sudo cp color.muttrc mailcap muttrc ~/.config/mutt

echo "Daily stuff installed"
sleep 1
echo "Installing Octave..."
sudo pacman -S octave --noconfirm
echo "Octave installed"
sleep 1
echo "Removing all bloatware"
sudo pacman -Rs hplip thunderbird yakuake skanlite --noconfirm

echo "All completed"
 

#!/bin/bash

install_flatpak_apps() {
    flatpak install io.github.prateekmedia.appimagepool -y
    flatpak install com.github.tchx84.Flatseal -y
    flatpak install us.zoom.Zoom -y
    flatpak install org.apache.netbeans -y

}

#install_flatpak_apps

update_filen() {

    wget -O $HOME/filen_x86_64.AppImage cdn.filen.io/desktop/release/filen_x86_64.AppImage
    mkdir $HOME/Applications
    mkdir $HOME/Filen
    mv $HOME/filen_x86_64.AppImage $HOME/Applications/filen_x86_64.AppImage
    echo "Integrate filen app in the installed option of appimagepool"
    sleep 3
    flatpak run io.github.prateekmedia.appimagepool
    $HOME/Applications/filen_x86_64_1865bf4573445333f7aa8a632046b834.AppImage --no-sandbox %U

}
#update_filen

update_tutanota() {
    wget -O $HOME/tuta_nota_x86_64.AppImage https://app.tuta.com/desktop/tutanota-desktop-linux.AppImage
    mv $HOME/tuta_nota_x86_64.AppImage $HOME/Applications/tuta_nota_x86_64.AppImage
    echo "Integrate tutanota app in the installed option of appimagepool"
    sleep 3
    flatpak run io.github.prateekmedia.appimagepool
    $HOME/Applications/tuta_nota_x86_64_4bb743d7b78fb9e78f7690a4f0455d1e.AppImage --no-sandbox %U

}
#time update_tutanota

update_rclone_browser() {
    wget -O $HOME/rclone_browser.AppImage https://github.com/kapitainsky/RcloneBrowser/releases/download/1.8.0/rclone-browser-1.8.0-a0b66c6-linux-x86_64.AppImage
    mv $HOME/rclone_browser.AppImage $HOME/Applications/rclone_browser.AppImage
    echo "Integrate rclone app in the installed option of appimagepool"
    sleep 3
    flatpak run io.github.prateekmedia.appimagepool
    $HOME/Applications/rclone_browser_33127ffffce83a80e357a98e2ed19883.AppImage
}
#time update_rclone_browser

update_virtualbox () {
    wget -O $HOME/Oracle_VM_VirtualBox_Extension_Pack-7.0.14.vbox-extpack https://download.virtualbox.org/virtualbox/7.0.14/Oracle_VM_VirtualBox_Extension_Pack-7.0.14.vbox-extpack
    echo "Install extension pack"
    sleep 3
    VirtualBox %U
    rm $HOME/Oracle_VM_VirtualBox_Extension_Pack-7.0.14.vbox-extpack
    sudo usermod -aG vboxusers $USER
}
time update_virtualbox

enable_services() {

    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service
    echo ""
    sudo systemctl enable firewalld.service
    sudo systemctl start firewalld.service
    echo ""
    sudo systemctl enable cups
    sudo systemctl start cups
    echo ""
    sudo systemctl enable cronie.service
    sudo systemctl start cronie.service

    if [ "$HOSTNAME" = "lenovo-330" ]; then
        sudo systemctl enable touchegg.service
        sudo systemctl start touchegg.service

    fi
}

#enable_services

enable_postgres(){
    echo "Paste the following command on the other window that is going to open, then type exit:"
    echo "initdb --locale=C.UTF-8 --encoding=UTF8 -D /var/lib/postgres/data --data-checksums"
    sleep 5
    bash -c 'kitty sudo -iu postgres'
    sudo systemctl enable postgresql.service
    sudo systemctl start postgresql.service
}

#enable_postgres

enable_mariadb() {

    if sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql; then
        sudo systemctl enable mariadb.service
        sudo systemctl start mariadb.service
        sudo mariadb-secure-installation
    fi
}

#enable_mariadb

install_aur_yay() {

    sudo pacman -S --needed base-devel git go
    cd $HOME && git clone https://aur.archlinux.org/yay.git
    cd yay/ && makepkg -si
    rm -r yay
    #yay --save --answerclean None --answerdiff None
}

#install_aur_yay

install_yay_apps() {

    clear

    local errors=0

    local packages=("ancient-packages" "brave-bin" "cpu-x" "protonvpn" "vscodium" "swift-bin"
                    "ttf-ms-win11-auto" "javafx-scenebuilder" "onlyoffice-bin" "informant"
                    "teams-for-linux" "whatsie" "stremio" "peazip-qt5" "virtualfish")

    if [ "$HOSTNAME" = "ga-a320m-s2h" ]; then

        local desktop_packages=("vkbasalt" "lib32-vkbasalt" "protonup-qt" "protontricks"
                                "heroic-games-launcher-bin")

        for pkg in "${desktop_packages[@]}"; do
            if ! yay -S --needed --answerclean All --answerdiff None --noconfirm "$pkg"; then
                ((errors++))
            fi
        done
    fi

    for pkg in "${packages[@]}"; do
        if ! yay -S --needed --answerclean All --answerdiff None --noconfirm "$pkg"; then
            ((errors++))
        fi
    done

    sudo informant read

    echo ""
    echo "$errors packages failed to install."
}

#time install_yay_apps

#Kdeconnect firewalld fix
#sudo nvidia-xconfig
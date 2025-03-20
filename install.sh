#!/bin/bash

# Função para exibir mensagens formatadas
echo_message() {
  echo -e "\e[1;32m$1\e[0m"
}

# Alterar o arquivo /etc/dnf/dnf.conf para incluir max_parallel_downloads=20
echo_message "Verificando e aplicando configuração de max_parallel_downloads=20"
if ! grep -q '^max_parallel_downloads=20' /etc/dnf/dnf.conf; then
  echo 'max_parallel_downloads=20' | sudo tee -a /etc/dnf/dnf.conf
else
  echo_message "Configuração já aplicada."
fi

# Verificar e instalar atualizações
echo_message "Verificando e instalando atualizações do sistema"
sudo dnf upgrade -y

# Função para verificar se o pacote está instalado
is_installed() {
  sudo dnf list installed "$1" &> /dev/null
}

# Função para instalar pacotes com verificação e mensagem
install_package() {
  if is_installed "$1"; then
    echo_message "$1 já está instalado. Pulando..."
  else
    echo_message "Instalando $1..."
    sudo dnf install -y "$1"
  fi
}

# Instalar o RPM Fusion
echo_message "Adicionando RPM Fusion"
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Corrigir os problemas de codec
echo_message "Corrigindo codecs e instalando bibliotecas adicionais"
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
install_package amrnb
install_package amrwb
install_package faad2
install_package flac
install_package gpac-libs
install_package lame
install_package libde265
install_package libfc14audiodecoder
install_package mencoder
install_package x264
install_package x265
install_package ffmpegthumbnailer

# Instalar o ecossistema de virtualização
echo_message "Instalando virtualização"
sudo dnf group install -y virtualization

# Instalar monitoramento
echo_message "Instalando monitoramento"
sudo dnf install htop btop -y

# Instalar aplicativos Flatpak
echo_message "Instalando aplicativos Flatpak"
flatpak install -y flathub one.ablaze.floorp
flatpak install -y flathub org.gnome.Boxes
flatpak install -y flathub com.mattjakeman.ExtensionManager
flatpak install -y flathub com.bitwarden.desktop
flatpak install -y flathub com.todoist.Todoist
flatpak install -y flathub com.github.wwmm.easyeffects
flatpak install -y flathub org.mozilla.Thunderbird
flatpak install -y flathub de.haeckerfelix.Fragments
flatpak install -y flathub org.localsend.localsend_app
flatpak install -y flathub dev.geopjr.Collision
flatpak install -y flathub com.github.tchx84.Flatseal
flatpak install -y flathub io.github.ungoogled_software.ungoogled_chromium
flatpak install -y flathub page.codeberg.libre_menu_editor.LibreMenuEditor

echo ""
echo_message "Script de pós-instalação concluído!"
echo ""
echo_message "Lembrete: Aplicativos para instalar manualmente:"
echo "VS Code insiders"
echo "WhatsApp - Chromium"
echo "Spotify - Chromium"
echo ""
echo ""

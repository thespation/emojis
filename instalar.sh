#!/usr/bin/env bash
set -euo pipefail

# Cores
VERM="\033[1;31m"
VERD="\033[0;32m"
CIAN="\033[0;36m"
NORM="\033[0m"

# Alias e variáveis
SUDD='sudo apt install -y'
SUDF='sudo dnf install -y'
SUDA='sudo pacman -S --noconfirm --needed'
APPD='fonts-noto-color-emoji'
APPF='google-noto-emoji-color-fonts'
APPA='noto-fonts-emoji'
FONT_PATH='/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf'
CONFIG_PATH="$HOME/.config/fontconfig/fonts.conf"

# Verificação de sudo
if ! command -v sudo &>/dev/null; then
    echo -e "${VERM}[!] O comando sudo não está disponível.${NORM}"
    exit 1
fi

# Verificação de lsb_release
verificar_lsb_release() {
    if ! command -v lsb_release &>/dev/null; then
        echo -e "${CIAN}[ ] lsb_release não encontrado. Instalando...${NORM}"
        if [[ -f /etc/debian_version ]]; then
            sudo apt update && $SUDD lsb-release
        elif [[ -f /etc/redhat-release ]]; then
            $SUDF redhat-lsb
        elif [[ -f /etc/arch-release ]]; then
            $SUDA lsb-release
        else
            echo -e "${VERM}[!] Sistema não suportado${NORM}"
            exit 1
        fi
        echo -e "${VERD}[*] lsb_release instalado com sucesso!${NORM}"
    fi
}

# Funções de instalação
instalar() {
    local SU=$1 APP=$2
    if [[ -f $FONT_PATH ]]; then
        echo -e "${CIAN}[i] Fonte já instalada${NORM}"
    else
        echo -e "${CIAN}------ Instalando fonte ------${NORM}"
        $SU $APP
        echo -e "${VERD}[*] Fonte instalada com sucesso${NORM}"
    fi
    configurar_fontes
}

instalar_debian() { instalar "$SUDD" "$APPD"; }
instalar_fedora() { instalar "$SUDF" "$APPF"; }
instalar_arch()   { instalar "$SUDA" "$APPA"; }

# Configuração de fontes
configurar_fontes() {
    if [[ ! -f $CONFIG_PATH ]]; then
        echo -e "\n${CIAN}------ Criando configuração ------${NORM}"
        mkdir -p "$(dirname "$CONFIG_PATH")"
        cat > "$CONFIG_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- serif -->
  <alias>
    <family>serif</family>
    <prefer>
      <family>Noto Serif</family>
      <family>emoji</family>
      <family>Liberation Serif</family>
      <family>Nimbus Roman</family>
      <family>DejaVu Serif</family>
    </prefer>
  </alias>
  <!-- sans-serif -->
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Noto Sans</family>
      <family>emoji</family>
      <family>Liberation Sans</family>
      <family>Nimbus Sans</family>
      <family>DejaVu Sans</family>
    </prefer>
  </alias>
</fontconfig>
EOF
        fc-cache -f
        echo -e "${VERD}[*] Configuração criada com sucesso${NORM}\n"
    else
        echo -e "${CIAN}[i] Configuração já existente.${NORM}\n"
    fi
}

# Início
clear
verificar_lsb_release
ID=$(lsb_release -is)
case "$ID" in
    Debian|Ubuntu|Pop) instalar_debian ;;
    Fedora) instalar_fedora ;;
    Arch) instalar_arch ;;
    *) echo -e "${VERM}[!] Sistema não suportado${NORM}" ;;
esac

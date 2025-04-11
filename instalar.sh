#!/usr/bin/env bash

# Desenvolvido por William Santos
# contato: thespation@gmail.com ou https://github.com/thespation

# Cores
VERM="\033[1;31m"   # Vermelho
VERD="\033[0;32m"   # Verde
CIAN="\033[0;36m"   # Ciano
NORM="\033[0m"      # Padrão

# Alias e variáveis
SUDD='sudo apt install -y'
SUDF='sudo dnf install -y'
SUDA='sudo pacman -S --noconfirm --needed'
APPD='fonts-noto-color-emoji'
APPF='google-noto-emoji-color-fonts'
APPA='noto-fonts-emoji'
FONT_PATH='/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf'
CONFIG_PATH="/home/$USER/.config/fontconfig/fonts.conf"

# Verificação de Dependências
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
            echo -e "${VERM}[!] Sistema não suportado para instalação do lsb_release${NORM}"
            exit 1
        fi
        echo -e "${VERD}[*] lsb_release instalado com sucesso!${NORM}"
    fi
}

# Função principal
ATUAS() {
    case "$ID" in
        *Debian*|*Ubuntu*|*Pop*) ICOINSD ;;
        *Fedora*) ICOINSF ;;
        *Arch*) ICOINSA ;;
        *) echo -e "${VERM}[!] Sistema não suportado${NORM}" ;;
    esac
}

# Funções de instalação
INSTALAR() {
    local SU=$1 APP=$2
    if [[ -f $FONT_PATH ]]; then
        echo -e "${CIAN}[i] Fonte já instalada${NORM}"
    else
        echo -e "${CIAN}------ Instalando fonte ------${NORM}"
        $SU $APP
        echo -e "${VERD}[*] Fonte instalada com sucesso${NORM}"
    fi
    CONF
}

ICOINSD() { INSTALAR "$SUDD" "$APPD"; }
ICOINSF() { INSTALAR "$SUDF" "$APPF"; }
ICOINSA() { INSTALAR "$SUDA" "$APPA"; }

# Configuração de fontes
CONF() {
    if [[ ! -f $CONFIG_PATH ]]; then
        echo -e "\n${CIAN}------ Criando diretório e arquivo de configuração ------${NORM}"
        mkdir -p "$(dirname "$CONFIG_PATH")"  # Garante que o diretório exista
        echo -e '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE fontconfig SYSTEM "fonts.dtd">\n<fontconfig>\n
<!-- ## serif ## -->\n  <alias>\n               <family>serif</family>\n                <prefer>\n                      <family>Noto Serif</family>\n                     <family>emoji</family>\n                        <family>Liberation Serif</family>\n
        <family>Nimbus Roman</family>\n                 <family>DejaVu Serif</family>\n         </prefer>\n     </alias>\n      <!-- ## sans-serif ## -->\n       <alias>\n               <family>sans-serif</family>\n           <prefer>\n                      <family>Noto Sans</family>\n                      <family>emoji</family>\n                        <family>Liberation Sans</family>\n                        <family>Nimbus Sans</family>\n                  <family>DejaVu Sans</family>\n          </prefer>\n     </alias>\n</fontconfig>' > "$CONFIG_PATH"
        fc-cache -f
        echo -e "${VERD}[*] Configuração criada com sucesso${NORM}\n"
    else
        echo -e "${CIAN}[i] Configuração já existente, nada foi alterado.${NORM}\n"
    fi
}

# Início
clear
verificar_lsb_release
ID=$(lsb_release -i)
ATUAS

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
SUDA='sudo pacman -S --noconfirm'
APPD='fonts-noto-color-emoji'
APPF='google-noto-emoji-color-fonts'
APPA='noto-fonts-emoji'
LSBRELEASE='lsb-release'               # Pacote para lsb_release
FONT_PATH='/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf'
CONFIG_PATH='~/.config/fontconfig/fonts.conf'

# Verificação de Dependências
verificar_lsb_release() {
    if ! command -v lsb_release &>/dev/null; then
        echo -e "${CIAN}[ ] lsb_release não encontrado. Instalando...${NORM}"
        if [[ -f /etc/debian_version ]]; then
            sudo apt update && $SUDD $LSBRELEASE
        elif [[ -f /etc/redhat-release ]]; then
            $SUDF $LSBRELEASE
        elif [[ -f /etc/arch-release ]]; then
            $SUDA $LSBRELEASE
        else
            echo -e "${VERM}[!] Sistema não suportado para instalação do lsb_release${NORM}"
            exit 1
        fi
        echo -e "${VERD}[*] lsb_release instalado com sucesso!${NORM}"
    else
        echo -e "${VERD}[ ] lsb_release já está instalado.${NORM}"
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
        echo -e "${CIAN}[ ] Fontes já instaladas${NORM}"
    else
        echo -e "${CIAN}[ ] Instalando fontes...${NORM}"
        $SU $APP
        echo -e "${VERD}[*] Fontes instaladas com sucesso${NORM}"
    fi
    CONF
}

ICOINSD() { INSTALAR "$SUDD" "$APPD"; }
ICOINSF() { INSTALAR "$SUDF" "$APPF"; }
ICOINSA() { INSTALAR "$SUDA" "$APPA"; }

# Configuração de fontes
CONF() {
    if [[ ! -f $CONFIG_PATH ]]; then
        echo -e "${CIAN}[ ] Criando arquivo de configuração...${NORM}"
        mkdir -p ~/.config/fontconfig/ &&
        cat <<EOF > $CONFIG_PATH
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <alias>
        <family>serif</family>
        <prefer>
            <family>Noto Serif</family>
            <family>emoji</family>
            <family>Liberation Serif</family>
        </prefer>
    </alias>
    <alias>
        <family>sans-serif</family>
        <prefer>
            <family>Noto Sans</family>
            <family>emoji</family>
            <family>Liberation Sans</family>
        </prefer>
    </alias>
</fontconfig>
EOF
        fc-cache -f
        echo -e "${VERD}[*] Configuração concluída${NORM}"
    else
        echo -e "${CIAN}[ ] Configuração já existente${NORM}"
    fi
}

# Início
clear
verificar_lsb_release
ID=$(lsb_release -i)
ATUAS

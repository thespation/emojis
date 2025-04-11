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
FONT_PATH='/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf'
CONFIG_PATH='~/.config/fontconfig/fonts.conf'

# Verificação de Dependências
command -v lsb_release >/dev/null 2>&1 || { echo -e "${VERM}lsb_release não encontrado, instale antes de executar.${NORM}"; exit 1; }
command -v sudo >/dev/null 2>&1 || { echo -e "${VERM}sudo não encontrado, instale antes de executar.${NORM}"; exit 1; }

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
ID=$(lsb_release -i)
ATUAS

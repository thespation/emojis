#!/usr/bin/env bash
# ==============================================================================
# instalar-emoji.sh — Instalação da fonte Noto Color Emoji
# ==============================================================================
# Compatível com: Debian/Ubuntu/Pop, Fedora, Arch
# Variáveis de ambiente:
#   DRY_RUN=1   Simula sem alterar o sistema
# ==============================================================================

DRY_RUN="${DRY_RUN:-0}"

FONT_PATH='/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf'
CONFIG_PATH="$HOME/.config/fontconfig/fonts.conf"

# ==============================================================================
# CORES
# ==============================================================================
if [[ -t 1 ]]; then
    RESET=$'\033[0m'
    VERDE=$'\033[0;32m'
    AMARELO=$'\033[1;33m'
    VERMELHO=$'\033[0;31m'
    AZUL=$'\033[1;34m'
    NEGRITO=$'\033[1m'
else
    RESET='' VERDE='' AMARELO='' VERMELHO='' AZUL='' NEGRITO=''
fi

ICO_OK="✔"; ICO_ERR="✖"; ICO_WARN="⚠"; ICO_SKIP="↷"; ICO_INFO="ℹ"; ICO_SETA="➜"

log_ok()   { echo -e "${VERDE}  [${ICO_OK}]${RESET} $*"; }
log_info() { echo -e "${AZUL}  [${ICO_INFO}]${RESET} $*"; }
log_warn() { echo -e "${AMARELO}  [${ICO_WARN}]${RESET} $*"; }
log_err()  { echo -e "${VERMELHO}  [${ICO_ERR}]${RESET} $*"; }
log_skip() { echo -e "${AMARELO}  [${ICO_SKIP}]${RESET} $*"; }
log_run()  { echo -e "${AZUL}  [${ICO_SETA}]${RESET} $*"; }
separador(){ echo -e "  ──────────────────────────────────────────────"; }

# ==============================================================================
# BANNER
# ==============================================================================
clear
echo -e "${VERDE}
  ══════════════════════════════════════════════════════════
  ┌─┐┌─┐┬─┐┬─┐┌─┐┌─┐┌─┐┌─┐  ┌┬┐┌─┐  ┌─┐┌┬┐┌─┐ ┬┬┌─┐
  │  │ │├┬┘├┬┘├┤ │  ├─┤│ │   ││├┤   ├┤ ││││ │ ││└─┐
  └─┘└─┘┴└─┴└─└─┘└─┘┴ ┴└─┘  ─┴┘└─┘  └─┘┴ ┴└─┘└┘┴└─┘
  ══════════════════════════════════════════════════════════${RESET}"
echo ""
[[ "$DRY_RUN" == "1" ]] && log_skip "Modo DRY-RUN — nenhuma alteração será feita."
echo ""

# ==============================================================================
# VERIFICAR SUDO
# ==============================================================================
if ! command -v sudo >/dev/null 2>&1; then
    log_err "O comando 'sudo' não está disponível."
    exit 1
fi

# ==============================================================================
# DETECTAR DISTRO
# ==============================================================================
detectar_distro() {
    separador
    log_info "Detectando distribuição..."
    separador

    # Tenta via /etc/os-release (mais universal que lsb_release)
    if [[ -f /etc/os-release ]]; then
        # shellcheck source=/dev/null
        source /etc/os-release
        DISTRO_ID="${ID:-}"
        DISTRO_LIKE="${ID_LIKE:-}"
    fi

    # Fallback para lsb_release
    if [[ -z "${DISTRO_ID:-}" ]] && command -v lsb_release >/dev/null 2>&1; then
        DISTRO_ID="$(lsb_release -is | tr '[:upper:]' '[:lower:]')"
    fi

    if [[ -z "${DISTRO_ID:-}" ]]; then
        log_err "Não foi possível detectar a distribuição."
        exit 1
    fi

    log_ok "Distro: ${NEGRITO}${DISTRO_ID}${RESET} ${DISTRO_LIKE:+(like: ${DISTRO_LIKE})}"
}

# ==============================================================================
# INSTALAR FONTE
# ==============================================================================
instalar_fonte() {
    local cmd_install="$1"
    local pacote="$2"

    separador
    log_info "Verificando fonte Noto Color Emoji..."
    separador

    if [[ -f "$FONT_PATH" ]]; then
        log_skip "Fonte já instalada: $FONT_PATH"
    elif [[ "$DRY_RUN" == "1" ]]; then
        log_skip "[DRY-RUN] Instalaria: $pacote"
    else
        log_run "Instalando: $pacote ..."
        if eval "$cmd_install $pacote" &>/dev/null; then
            log_ok "Fonte instalada."
        else
            log_err "Falha ao instalar a fonte."
            exit 1
        fi
    fi
}

# ==============================================================================
# CONFIGURAR FONTCONFIG
# ==============================================================================
configurar_fontes() {
    separador
    log_info "Verificando configuração de fontes..."
    separador

    if [[ -f "$CONFIG_PATH" ]]; then
        log_skip "Configuração já existe: $CONFIG_PATH"
        return
    fi

    if [[ "$DRY_RUN" == "1" ]]; then
        log_skip "[DRY-RUN] Criação de $CONFIG_PATH simulada."
        return
    fi

    log_run "Criando: $CONFIG_PATH ..."
    mkdir -p "$(dirname "$CONFIG_PATH")"

    cat > "$CONFIG_PATH" << 'XMLEOF'
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
XMLEOF

    log_run "Atualizando cache de fontes (fc-cache)..."
    fc-cache -f && log_ok "Cache atualizado." || log_warn "fc-cache retornou erro (não crítico)."
    log_ok "Configuração criada: $CONFIG_PATH"
}

# ==============================================================================
# MAIN
# ==============================================================================
detectar_distro

case "${DISTRO_ID,,}" in
    debian|ubuntu|pop|linuxmint|raspbian)
        [[ "$DRY_RUN" != "1" ]] && sudo apt-get update -qq
        instalar_fonte "sudo apt-get install -y" "fonts-noto-color-emoji"
        ;;
    fedora|rhel|centos)
        instalar_fonte "sudo dnf install -y" "google-noto-emoji-color-fonts"
        ;;
    arch|manjaro|endeavouros)
        instalar_fonte "sudo pacman -S --noconfirm --needed" "noto-fonts-emoji"
        ;;
    *)
        # Tenta via ID_LIKE (ex: Ubuntu derivado que não é ubuntu no ID)
        case "${DISTRO_LIKE,,}" in
            *debian*|*ubuntu*)
                [[ "$DRY_RUN" != "1" ]] && sudo apt-get update -qq
                instalar_fonte "sudo apt-get install -y" "fonts-noto-color-emoji"
                ;;
            *fedora*|*rhel*)
                instalar_fonte "sudo dnf install -y" "google-noto-emoji-color-fonts"
                ;;
            *arch*)
                instalar_fonte "sudo pacman -S --noconfirm --needed" "noto-fonts-emoji"
                ;;
            *)
                log_err "Distribuição não suportada: ${DISTRO_ID}"
                exit 1
                ;;
        esac
        ;;
esac

configurar_fontes

echo ""
separador
log_ok "Fonte Noto Color Emoji configurada com sucesso!"
separador

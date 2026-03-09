# 🎨 Instalação de Emojis no Linux

Instala e configura a fonte **Noto Color Emoji** para exibição correta de emojis em navegadores e aplicativos.

<p align="center">
<img width="70%" src="https://user-images.githubusercontent.com/84329097/192320832-dda9e553-5d9c-48e1-b1be-f98837812764.png" alt="preview emojis" /><br><br>
</p>

---

## 📋 Distribuições suportadas

| Distro | Família | Pacote instalado |
|---|---|---|
| Debian | debian | `fonts-noto-color-emoji` |
| Ubuntu / Kubuntu / Lubuntu / Xubuntu | debian | `fonts-noto-color-emoji` |
| Pop!\_OS | debian | `fonts-noto-color-emoji` |
| Linux Mint | debian | `fonts-noto-color-emoji` |
| Raspberry Pi OS | debian | `fonts-noto-color-emoji` |
| Fedora | fedora | `google-noto-emoji-color-fonts` |
| RHEL / CentOS | fedora | `google-noto-emoji-color-fonts` |
| Arch Linux | arch | `noto-fonts-emoji` |
| Manjaro | arch | `noto-fonts-emoji` |
| EndeavourOS | arch | `noto-fonts-emoji` |

A detecção da distro é feita via `/etc/os-release`, sem dependência de `lsb_release`.  
Derivadas não listadas acima são detectadas automaticamente pelo campo `ID_LIKE`.

---

## ⚙️ O que o script faz

1. **Detecta a distribuição** automaticamente via `/etc/os-release`
2. **Instala a fonte** Noto Color Emoji pelo gerenciador de pacotes da distro
3. **Cria o arquivo de configuração** `~/.config/fontconfig/fonts.conf` com prioridade de fontes para `serif` e `sans-serif`
4. **Atualiza o cache de fontes** via `fc-cache`

### Arquivo de configuração gerado

```xml
~/.config/fontconfig/fonts.conf
```

Define a ordem de preferência das fontes para garantir que emojis sejam exibidos corretamente em todos os aplicativos que usam fontconfig (Firefox, Chromium, aplicativos GTK etc.).

---

## 🚀 Instalação

Clone o repositório e execute o script:

Execute diretamente com curl:

```bash
curl -fsSL https://raw.githubusercontent.com/thespation/emojis/refs/heads/main/instalar.sh | bash
```

---

## 🔧 Variáveis de ambiente

| Variável | Valor | Comportamento |
|---|---|---|
| `DRY_RUN` | `1` | Simula toda a execução sem instalar nem modificar nada |

Exemplo:

```bash
DRY_RUN=1 bash instalar.sh
```

---

## 📦 Pré-requisitos

- `sudo` disponível no sistema
- Conexão com a internet (para instalação do pacote)
- Bash 4+

---

## 🔍 Verificação pós-instalação

Após a instalação, verifique se a fonte foi reconhecida:

```bash
fc-list | grep -i noto | grep -i emoji
```

Para testar a exibição no terminal (requer fonte compatível):

```bash
echo "😀 🎉 🚀 ❤️ 🐧"
```

---

## 💡 Motivação

Baseado no tutorial do Diolinux:

> [Resolvendo o bug dos emojis nos navegadores no Linux](https://diolinux.com.br/tutoriais/resolvendo-o-bug-dos-emojis.html)

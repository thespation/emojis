#!/usr/bin/env bash
# Desenvolvido pelo William Santos
# contato: thespation@gmail.com ou https://github.com/thespation
# Motivação: https://diolinux.com.br/tutoriais/resolvendo-o-bug-dos-emojis.html

# Cores (tabela de cores: https://gist.github.com/avelino/3188137)
VERM="\033[1;31m"	#Deixa a saída na cor vermelho
VERD="\033[0;32m"	#Deixa a saída na cor verde
CIAN="\033[0;36m"	#Deixa a saída na cor ciano
NORM="\033[0m"		#Volta para a cor padrão
# Alias de instalação
SUDD='sudo apt install'			#Base Debian
SUDF='sudo dnf install -y' 		#Fedora
APPD='fonts-noto-color-emoji'		#Pacote de ícones para base Debian
APPF='google-noto-emoji-color-fonts'	#Pacote de ícones para Fedora
ID=`lsb_release -i`			#Obtem informações do sistema

#Responsável por verificar qual sistema em uso
ATUAS () { 
	if [[ $ID = *Debian* || $ID = *Ubuntu* || $ID = *Pop* ]]; then #Testa se é base Debian
		ICOINSD
	elif [[ $ID = *Fedora* ]]; then
		ICOINSF
	else
		echo -e "${VERM}[!] Sistema não suportado\n" ${NORM}
	fi
}

#Verifica se pacote de ícones está instalado na base Debian
ICOINSD () {
	if [[ -f /usr/share/fonts/truetype/noto/NotoColorEmoji.ttf ]]; then
		echo -e "${CIAN}[ ] Pacote de fontes já consta no sistema" ${NORM}
		CONF
	else
		echo -e "${CIAN}[ ] Instalar pacote de fontes" ${NORM}
			${SUDD} ${APPD} -y
		echo -e "${VERD}[*] Pacote de fontes instalado com sucesso" ${NORM}
		CONF
fi
}

#Verifica se pacote de ícones está instalado no Fedpra
ICOINSF () {
	if [[ -f /usr/share/fonts/truetype/noto/NotoColorEmoji.ttf ]]; then
		echo -e "${CIAN}[ ] Pacote de fontes já consta no sistema" ${NORM}
		CONF
	else
		echo -e "${CIAN}[ ] Instalar pacote de fontes" ${NORM}
			${SUDF} -y ${APPF}
		echo -e "${VERD}[*] Pacote de fontes instalado com sucesso" ${NORM}
		CONF
fi
}

#Responsável por criar arquivos de configurações e atualizar o cache das fontes
CONF () {
	if [[ ! -f ~/.config/fontconfig/fonts.conf ]]; then #verifica se já existe o arquivo
		echo -e "\n${CIAN}[ ] Criar arquivos de configuração" ${NORM}
		mkdir -p ~/.config/fontconfig/ &&
		echo -e '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE fontconfig SYSTEM "fonts.dtd">\n<fontconfig>\n
			<!-- ## serif ## -->\n  <alias>\n               <family>serif</family>\n                <prefer>\n                      <family>Noto Serif</family>\n                     <family>emoji</family>\n                        <family>Liberation Serif</family>\n
			<family>Nimbus Roman</family>\n                 <family>DejaVu Serif</family>\n         </prefer>\n     </alias>\n      <!-- ## sans-serif ## -->\n       <alias>\n               <family>sans-serif</family>\n           <prefer>\n                      <family>Noto Sans</family>\n                      <family>emoji</family>\n                        <family>Liberation Sans</family>\n                        <family>Nimbus Sans</family>\n                  <family>DejaVu Sans</family>\n          </prefer>\n     </alias>\n</fontconfig>' > ~/.config/fontconfig/fonts.conf && fc-cache -f
		echo -e "${VERD}[*] Arquivo criado com sucesso" ${NORM}
		echo -e "\n${CIAN}[ ] Pode ser necessário sair e voltar a sessão" ${NORM}
	elif  [[ -f ~/.config/fontconfig/fonts.conf ]]; then
		echo -e "${CIAN}[ ] Arquivo de configuração já está na pasta, não foi substituído" ${NORM}
	else
		echo -e "${VERM}[!] Não foi possível criar o arquivo" ${NORM}
	fi
}

# Iniciar verificação
clear; ATUAS

#!/bin/bash
# Script de instalação do GhostPDL

set -e  # Sai em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Instalador do GhostPDL 10.07.0 ===${NC}"

# Verifica se é root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Este script deve ser executado como root (use sudo)${NC}" 
   exit 1
fi

# Define diretórios
INSTALL_DIR="/usr/local/src"
GHOSTPDL_URL="https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs10070/ghostpdl-10.07.0.tar.gz"
              
# Ou se o arquivo já está no repo:
# GHOSTPDL_URL="https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs10070/ghostpdl-10.07.0.tar.gz"

# Instala dependências
echo -e "${YELLOW}Instalando dependências...${NC}"
apt-get update
apt-get install -y build-essential libcups2-dev libjpeg-dev libpng-dev libtiff-dev libfreetype6-dev liblcms2-dev libopenjp2-7-dev

# Baixa o arquivo
echo -e "${YELLOW}Baixando GhostPDL 10.07.0...${NC}"
cd /tmp
if [ -f "/tmp/ghostpdl-10.07.0.tar.gz" ]; then
    rm -f /tmp/ghostpdl-10.07.0.tar.gz
fi

# Se o arquivo está no GitHub RAW
curl -fsSL -o ghostpdl-10.07.0.tar.gz "$GHOSTPDL_URL"

# Ou se você quer extrair do próprio script (embutido)
# Neste caso, você precisaria embutir o arquivo base64 no script

# Extrai
echo -e "${YELLOW}Extraindo arquivos...${NC}"
tar -xzf ghostpdl-10.07.0.tar.gz
cd ghostpdl-10.07.0

# Configura e compila
echo -e "${YELLOW}Configurando...${NC}"
./configure --prefix=/usr/local

echo -e "${YELLOW}Compilando (isso pode levar alguns minutos)...${NC}"
make -j$(nproc)

echo -e "${YELLOW}Instalando...${NC}"
make install

# Limpa
cd /tmp
rm -rf ghostpdl-10.07.0 ghostpdl-10.07.0.tar.gz

echo -e "${GREEN}GhostPDL 10.07.0 instalado com sucesso!${NC}"

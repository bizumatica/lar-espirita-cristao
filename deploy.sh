#!/bin/bash

# Author: Julio Prata
# Version: 2.1 (Double-Validated & Streamlined)
# Description: Orquestrador GitOps para Cloudflare Pages (Otimizado para Leaf Bundles)

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}--- Inicializando Validações de Ambiente e GitOps ---${NC}"

# 1. GUARDRAIL: Validação estrita da raiz do projeto para evitar execuções órfãs
if [ ! -f "hugo.toml" ]; then
    echo -e "${RED}[-][ERRO] hugo.toml não encontrado na raiz do repositório.${NC}"
    echo -e "${RED}Execute este script a partir da raiz do projeto Hugo.${NC}"
    exit 1
fi

# 2. HOUSEKEEPING: Expurgando travas de concorrência e lixo de compilação legado
rm -f .hugo_build_lock
if [ -d "docs" ]; then
    echo -e "${YELLOW}[!] Pasta legada /docs detectada no HD. Removendo do rastreamento do Git...${NC}"
    git rm -r --cached docs &> /dev/null
    rm -rf docs
    echo -e "${GREEN}[+] Histórico despoluído com sucesso.${NC}"
fi

echo -e "${GREEN}[+] Ambiente limpo e pronto para sincronização dos Leaf Bundles.${NC}"
echo -e "${CYAN}--- Sincronizando Fontes com a Cloudflare Pages ---${NC}"

# 3. INDEXAÇÃO ATÔMICA DO GIT
git add .

# Verifica mutações reais no código-fonte para evitar commits nulos
if git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}[!] Sem alterações detectadas nos arquivos-fonte. O repositório já está em sincronia.${NC}"
else
    # Mensagem padrão caso nenhuma seja passada por parâmetro
    msg="feat: nova postagem (leaf bundle) e atualização de infra"
    
    # OTIMIZAÇÃO: Captura todos os argumentos passados, eliminando a obrigatoriedade de aspas
    [ $# -gt 0 ] && msg="$*"

    echo -e "${CYAN}[->] Executando commit semântico...${NC}"
    git commit -m "$msg"
    
    echo -e "${CYAN}[->] Disparando gatilho de build remoto na Cloudflare...${NC}"
    git push origin main
    
    echo -e "${GREEN}--- Código enviado! A Cloudflare Pages iniciou a compilação e o Pagefind está indexando seu site. ---${NC}"
fi
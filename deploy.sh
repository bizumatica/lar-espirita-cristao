#!/bin/bash

# Author: Julio Prata
# Version: 1.7
# Description: Script de deploy resiliente para projetos Hugo localizados na raiz do repositório

# Cores para feedback no terminal (ANSI)
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}--- Inicializando Validações de Ambiente ---${NC}"

# 1. GUARDRAIL: Valida se o script está sendo executado na raiz correta do projeto Hugo
if [ ! -f "hugo.toml" ] && [ ! -f "config.toml" ] && [ ! -f "config.yaml" ]; then
    echo -e "${RED}[-][ERRO] Arquivo de configuração do Hugo não encontrado na raiz.${NC}"
    echo -e "${RED}Certifique-se de executar este script no mesmo diretório onde fica o seu hugo.toml.${NC}"
    exit 1
fi

# 2. SANITY CHECK: Verifica se o binário do Hugo está acessível
if ! command -v hugo &> /dev/null; then
    echo -e "${RED}[-][ERRO] O binário 'hugo' não está instalado ou não está no seu PATH.${NC}"
    exit 1
fi

echo -e "${GREEN}[+] Ambiente e estrutura de raiz validados com sucesso.${NC}"
echo -e "${CYAN}--- Iniciando Pipeline de Compilação Estática ---${NC}"

echo -e "${CYAN}[->] Expurgando caches locais e gerando build limpo em /docs...${NC}"
# Remove locks e caches do Hugo Pipes para forçar o re-processamento correto dos Leaf Bundles e Favicons
rm -rf resources/_gen/ .hugo_build_lock

# 3. GERAR O SITE (Saída direcionada para a pasta 'docs' na raiz)
if hugo --gc --minify --cleanDestinationDir -d docs; then
    echo -e "${GREEN}--> Build concluído com sucesso na pasta /docs!${NC}"
else
    echo -e "${RED}--> [ERRO] Falha crítica na compilação do Hugo.${NC}"
    exit 1
fi

echo -e "${CYAN}--- Sincronizando Alterações com o GitHub ---${NC}"

# 4. ORQUESTRAÇÃO DO GIT: Executa tudo no mesmo diretório de forma segura
git add .

# Previne falha ou commits vazios caso o build não tenha gerado modificações reais de código
if git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}[!] Sem alterações detectadas. O repositório já está em sincronia.${NC}"
else
    msg="Update $(date +'%d/%m/%Y %H:%M')"
    [ $# -eq 1 ] && msg="$1"

    echo -e "${CYAN}[->] Executando commit semântico...${NC}"
    git commit -m "$msg"
    git push origin main
    echo -e "${GREEN}--- Deploy concluído com sucesso! Verifique o Cloudflare em 1 min. ---${NC}"
fi
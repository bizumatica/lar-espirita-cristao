#!/bin/bash

# Author: Julio Prata | Version: 6.0
# Descrição: Importador com limpeza profunda de tags e correção de títulos gigantes.

DEST_DIR="./lec/content/post"
mkdir -p "$DEST_DIR"

BLOGS=(
    "https://inacioferreira-baccelli.blogspot.com/feeds/posts/default?alt=rss|Inácio Ferreira / Baccelli"
    "https://formiga-baccelli.blogspot.com/feeds/posts/default?alt=rss|Blog Formiga / Baccelli"
)

echo "Limpando posts antigos e iniciando importação..."

for ITEM in "${BLOGS[@]}"; do
    URL=$(echo $ITEM | cut -d'|' -f1)
    AUTHOR=$(echo $ITEM | cut -d'|' -f2)
    
    echo "Processando: $AUTHOR"
    
    # Baixa o feed, remove quebras de linha e separa por <item>
    FEED_DATA=$(curl -sL --max-time 15 "$URL" | tr -d '\n' | sed 's/<item>/\n<item>/g')

    echo "$FEED_DATA" | while read -r line; do
        [[ "$line" != *"<item>"* ]] && continue

        # 1. Extrair Título (e cortar se for absurdamente grande)
        RAW_TITLE=$(echo "$line" | grep -oP '(?<=<title>).*?(?=</title>)' | sed 's/<!\[CDATA\[//g; s/\]\]>//g' | head -1)
        TITLE=$(echo "$RAW_TITLE" | cut -c1-100 | sed 's/[[:space:]]*$//') # Limita a 100 caracteres
        [ -z "$TITLE" ] && TITLE="Mensagem de $(date +%d/%m/%Y)"

        # 2. Extrair Link Real
        LINK=$(echo "$line" | grep -oP '(?<=<link>).*?(?=</link>)' | grep ".html" | head -1)

        # 3. Extrair Conteúdo e LIMPAR TAGS DE ESTILO ANTES DO PANDOC
        # Removemos spans, fonts, estilos inline e divs de layout do Blogspot
        RAW_HTML=$(echo "$line" | grep -oP '(?<=<description>).*?(?=</description>)' | sed 's/&lt;/</g; s/&gt;/>/g; s/&amp;/\&/g; s/&quot;/\"/g; s/&#39;/'\''/g')
        
        # Limpeza agressiva de HTML sujo
        CLEAN_HTML=$(echo "$RAW_HTML" | sed -e 's/<span[^>]*>//g' -e 's/<\/span>//g' -e 's/<font[^>]*>//g' -e 's/<\/font>//g' -e 's/<div[^>]*>//g' -e 's/<\/div>//g' -e 's/style="[^"]*"//g')

        # 4. Conversão Pandoc para Markdown Puro
        BODY_MD=$(echo "$CLEAN_HTML" | pandoc -f html -t markdown_strict --wrap=none | sed '/^$/d' | head -c 1200)

        # 5. Criar Slug e Arquivo
        SLUG=$(echo "$TITLE" | iconv -t ascii//TRANSLIT | tr -dc '[:alnum:] ' | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | sed 's/--/-/g' | cut -c1-50)
        FILE="$DEST_DIR/importado-$SLUG.md"

        if [ ! -f "$FILE" ]; then
            echo " -> Importado: $TITLE"
            cat <<EOF > "$FILE"
---
title: "$TITLE"
date: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
draft: false
categories: ["Leitura Recomendada"]
---

###### _por $AUTHOR_

$BODY_MD...

---

### Fontes Relacionadas
* [Leia a postagem completa no Blogspot original]($LINK)
* [Chico Xavier: O Mandato de Amor](https://lecitatiba.com.br/pinga-fogo/)

---
EOF
        fi
    done
done
#!/bin/bash
# Roda na raiz da pasta 'content'

# 1. Garante que as seções principais tenham o arquivo de TÍTULO (_index.md)
for dir in $(find . -maxdepth 1 -type d ! -name "."); do
    if [ ! -f "$dir/_index.md" ]; then
        echo "---" > "$dir/_index.md"
        echo "title: \"$(basename "$dir" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')\"" >> "$dir/_index.md"
        echo "---" >> "$dir/_index.md"
        echo "✅ Criado título para a seção: $dir"
    fi
done

# 2. Transforma qualquer .md solto em uma pasta com index.md (Bundle)
# (Ignora os que já têm underline)
find . -mindepth 2 -name "*.md" ! -name "index.md" ! -name "_index.md" | while read -r file; do
    slug="${file%.md}"
    mkdir -p "$slug"
    mv "$file" "$slug/index.md"
    echo "📦 Post isolado convertido para bundle: $slug"
done
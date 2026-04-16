#!/bin/bash
# ssg-img-optimizer.sh
# Author: Julio Prata
# Version: 2.0
# Date: 16/04/2026

BASE_DIR="${1:-.}"
QUALITY="${2:-80}"

# Detectar ferramenta
CONV=$(command -v cwebp || command -v ffmpeg)
[ -z "$CONV" ] && { echo "❌ Instale cwebp ou ffmpeg."; exit 1; }

echo "🛠️  Otimizando ativos em $BASE_DIR..."

# Usamos um delimitador seguro no sed (hash #) para evitar conflitos com barras de path
find "$BASE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | while IFS= read -r -d '' IMG; do
    
    OLD_BASE=$(basename "$IMG")
    NEW_FILE="${IMG%.*}.webp"
    NEW_BASE=$(basename "$NEW_FILE")

    # Conversão silenciosa e eficiente
    if [[ "$CONV" == *"cwebp"* ]]; then
        cwebp -q "$QUALITY" "$IMG" -o "$NEW_FILE" -quiet
    else
        ffmpeg -i "$IMG" -compression_level 4 -q:v "$QUALITY" "$NEW_FILE" -loglevel quiet -y
    fi

    if [ $? -eq 0 ]; then
        echo "✅ $OLD_BASE -> $NEW_BASE"
        
        # Atualiza referências em todos os arquivos Markdown do projeto
        # Isso garante que mesmo imagens em /static/ continuem linkadas após virarem webp
        find "$BASE_DIR" -name "*.md" -type f -exec sed -i "s#$OLD_BASE#$NEW_BASE#g" {} +

        # Remoção atômica (Git-aware)
        if git rev-parse --is-inside-work-tree &>/dev/null && git ls-files --error-unmatch "$IMG" &>/dev/null; then
            git rm -f "$IMG" > /dev/null
            git add "$NEW_FILE"
        else
            rm "$IMG"
        fi
    fi
done
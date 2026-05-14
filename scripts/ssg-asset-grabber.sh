#!/bin/bash
# Author: Julio Prata
# Version: 1.1
# Date: 16/04/2026
# ---------------------------------------------------------------------
# Nome: ssg-asset-grabber.sh
# Objetivo: Localiza imagens em /static, move para o Bundle correspondente
#           e converte para WebP no processo.
# ---------------------------------------------------------------------

CONTENT_DIR="./lec/content"
STATIC_IMG_DIR="./lec/static/images"

echo "🎯 Iniciando captura de assets para Bundles..."

find "$CONTENT_DIR" -name "index.md" -type f | while read -r MD_FILE; do
    BUNDLE_PATH=$(dirname "$MD_FILE")
    
    # Busca por nomes de arquivos de imagem comuns dentro do MD
    # Procura strings que terminam em .jpg, .png, .jpeg
    IMAGES=$(grep -oE '[^/)]+\.(jpg|jpeg|png)' "$MD_FILE" | sort -u)

    for IMG_NAME in $IMAGES; do
        # O arquivo pode estar na raiz de static/images
        FULL_STATIC_PATH="$STATIC_IMG_DIR/$IMG_NAME"
        
        if [ -f "$FULL_STATIC_PATH" ]; then
            NEW_NAME="${IMG_NAME%.*}.webp"
            TARGET_PATH="$BUNDLE_PATH/$NEW_NAME"

            # Conversão para WebP
            cwebp -q 80 "$FULL_STATIC_PATH" -o "$TARGET_PATH" -quiet 2>/dev/null || \
            ffmpeg -i "$FULL_STATIC_PATH" -q:v 80 "$TARGET_PATH" -loglevel quiet -y

            # ATUALIZAÇÃO DO MD: Remove caminhos e atualiza extensão
            # Esta regex é agressiva: ela busca qualquer menção ao nome da imagem antiga 
            # (com ou sem path /images/) e substitui pelo novo nome webp relativo.
            sed -i -E "s|(/?)images/$IMG_NAME|$NEW_NAME|g" "$MD_FILE"
            sed -i -E "s|$IMG_NAME|$NEW_NAME|g" "$MD_FILE"

            echo "✅ Processado: $IMG_NAME -> $TARGET_PATH"
        fi
    done
done
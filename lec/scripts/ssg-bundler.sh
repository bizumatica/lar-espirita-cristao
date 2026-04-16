#!/bin/bash
# Author: Julio Prata
# Version: 2.0
# Date: 16/04/2026
# ---------------------------------------------------------------------
# Nome: ssg-bundler.sh
# Objetivo: Converter arquivos Markdown isolados em estruturas de Pasta (Bundles)
# Uso: ./scripts/ssg-bundler.sh [DIRETÓRIO_ALVO]
# ---------------------------------------------------------------------

TARGET_DIR="${1:-.}"

if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Erro: O diretório '$TARGET_DIR' não existe."
    exit 1
fi

echo "🔍 Analisando arquivos em: $(realpath "$TARGET_DIR")"

# Localiza arquivos .md ignorando index.md e _index.md
# O uso de -print0 lida com espaços em nomes de arquivos (robustez)
find "$TARGET_DIR" -type f -name "*.md" ! -name "index.md" ! -name "_index.md" -print0 | while IFS= read -r -d '' FILE; do
    
    BASENAME=$(basename "$FILE" .md)
    DIRNAME=$(dirname "$FILE")
    BUNDLE_DIR="$DIRNAME/$BASENAME"

    # Cria o diretório do bundle
    mkdir -p "$BUNDLE_DIR"

    # Operação Atômica: Move o arquivo para dentro da pasta como index.md
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1 && git ls-files --error-unmatch "$FILE" > /dev/null 2>&1; then
        git mv "$FILE" "$BUNDLE_DIR/index.md"
        echo "📦 [GIT] $FILE -> $BUNDLE_DIR/index.md"
    else
        mv "$FILE" "$BUNDLE_DIR/index.md"
        echo "📦 [FS]  $FILE -> $BUNDLE_DIR/index.md"
    fi
done

echo "✅ Migração para bundles concluída."
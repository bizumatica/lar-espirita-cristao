# 🏛️ Lar Espírita Cristão (LEC) — Itatiba/SP

> **Portal Institucional & Plataforma de Conteúdo Estático**  
> Aplicação Jamstack de alta performance compilada com **Hugo Extended**, busca local via **Pagefind (WebAssembly)** e deploy contínuo em borda global (**Cloudflare Pages**).

[![Hugo](https://img.shields.io/badge/SSG-Hugo_Extended_v0.110+-ff4088?logo=hugo&logoColor=white)](https://gohugo.io/)
[![Pagefind](https://img.shields.io/badge/Search-Pagefind_Wasm-05B585?logo=webassembly&logoColor=white)](https://pagefind.app/)
[![Deploy](https://img.shields.io/badge/Deployment-Cloudflare_Pages-F38020?logo=cloudflare&logoColor=white)](https://pages.cloudflare.com/)
![GitHub License](https://img.shields.io/badge/license-MIT-8532D3?logo=github&logoColor=white?style=flat-square)
![Feito com Café](https://img.shields.io/badge/feito%20com-caf%C3%A9%20%E2%98%95%20e%20canela%20🪵-brown?logo=buymeacoffee&logoColor=white)

---

## ⚡ Arquitetura & Engenharia de Performance

O ecossistema foi projetado sob a filosofia **Zero-Server / Edge-First**, garantindo pontuação máxima nos métricos do **Core Web Vitals** (LCP, INP, CLS) e custo zero de infraestrutura.


```

┌─────────────────┐      ┌─────────────────────────┐      ┌──────────────────────────────┐
│  Content (.md)  │ ───► │  Hugo SSG Compilation   │ ───► │   Pagefind WASM Indexing     │
└─────────────────┘      └─────────────────────────┘      └──────────────────────────────┘
│
▼
┌──────────────────────────────┐
│   Cloudflare Edge Network    │
└──────────────────────────────┘

```

### Principais Destaques de Arquitetura

* **Busca Estática em WebAssembly (Pagefind):** Indexação *full-text* pós-build realizada diretamente nos arquivos compilados em `public/`. Não consome APIs pagas, bancos de dados ou serviços externos de busca (como Algolia).
* **Otimização Crítica do LCP:** Layouts de listagem (`layouts/_default/list.html`) reordenados para priorizar a renderização de elementos de texto antes de mídias no viewport mobile.
* **Markdown Render Hooks:** Processamento automatizado de links e mídias (`layouts/_default/_markup/`) injetando `loading="lazy"`, `decoding="async"` e atributos de segurança (`rel="noopener"`).
* **Page Bundles:** Conteúdos organizados por pacotes autocontidos (`index.md` + mídias locais), facilitando a portabilidade e manutenção.

---

## 🛠️ Stack Tecnológica

| Camada | Tecnologia | Função |
| :--- | :--- | :--- |
| **SSG** | [Hugo Extended](https://gohugo.io/) | Gerador de sites estáticos em Go |
| **Search Engine** | [Pagefind](https://pagefind.app/) | Engine de busca estática compilada em Wasm |
| **Base Theme** | [Mainroad Custom](https://github.com/Vimux/Mainroad) | Tema base estendido via overrides locais em `/layouts` |
| **Mídia & Assets** | WebP / Bash Automation | Conversão automatizada de imagens e compressão sem perdas |
| **Edge Hosting** | [Cloudflare Pages](https://pages.cloudflare.com/) | CI/CD, SSL automatizado e CDN global |

---

## 📂 Estrutura do Repositório

```text
.
├── content/              # Artigos (.md) organizados em Page Bundles
│   ├── allan-kardec/     # Seção histórica/doutrinária
│   ├── chico-xavier/     # Obras e biografia
│   └── estudos/          # Cronogramas e material de estudo
├── data/                 # Fontes de dados estruturados (YAML/JSON)
├── layouts/              # Overrides e componentes de template
│   ├── _default/         # Layouts de páginas, listas e Render Hooks
│   ├── partials/widgets/ # Widgets (Live Audio, Spotify, Agenda, Mapa)
│   └── shortcodes/       # Componentes reusáveis em Markdown
├── scripts/              # Pipelines de automação local (Bash & Python)
│   ├── ssg-img-optimizer.sh # Otimizador de imagens para WebP
│   └── ssg-asset-grabber.sh # Download e preparação de assets
├── static/               # Arquivos estáticos servidos na raiz (favicons, CSS extra)
├── themes/mainroad/      # Tema base (submódulo Git)
├── hugo.toml             # Configuração global da aplicação
└── importar.py           # Script ETL para conversão de artigos legados

```

---

## 🚀 Ambiente de Desenvolvimento Local

### Pré-requisitos

* **Hugo Extended** ($\ge$ v0.110.0)
* **Node.js / NPX** (para execução do Pagefind)
* **Git**

### 1. Clonar o Repositório

Como o projeto utiliza o tema base como submódulo Git, inicialize com a flag `--recursive`:

```bash
git clone --recursive [https://github.com/bizumatica/lar-espirita-cristao.git](https://github.com/bizumatica/lar-espirita-cristao.git)
cd lar-espirita-cristao

```

Caso já tenha clonado sem os submódulos:

```bash
git submodule update --init --recursive

```

### 2. Iniciar Servidor de Desenvolvimento

```bash
hugo server -D --disableFastRender

```

O servidor estará acessível em `http://localhost:1313/`.

### 3. Compilar e Indexar a Busca (Pagefind Local)

Para validar o fluxo completo de build e o funcionamento da busca localmente:

```bash
# 1. Compila o site estático na pasta /public
hugo --gc --minify

# 2. Gera o índice do Pagefind dentro de /public/pagefind
npx pagefind --site public

```

---

## ⚙️ Scripts de Automação (`/scripts`)

O repositório conta com scripts utilitários para manutenção do projeto:

* **Otimização de Imagens (`scripts/ssg-img-optimizer.sh`):**
Varre o diretório `content/` e converte automaticamente imagens `.png` e `.jpg` para `.webp`, reduzindo o tamanho do build sem perda legível de qualidade.
```bash
chmod +x scripts/ssg-img-optimizer.sh
./scripts/ssg-img-optimizer.sh

```


* **Ingestão ETL (`importar.py`):**
Script em Python para importar e reestruturar postagens de sistemas legados ou fontes externas diretamente no formato de Page Bundles do Hugo.

---

## 🌐 Pipeline de CI/CD (Cloudflare Pages)

O deploy é acionado automaticamente em cada envio (*push*) para a branch `main`.

### Parâmetros do Painel Cloudflare:

* **Framework Preset:** `None` (ou `Hugo`)
* **Build Command:** `hugo --gc --minify && npx pagefind --site public`
* **Build Output Directory:** `public`
* **Environment Variables:**
* `HUGO_VERSION`: `0.110.0` (ou superior)
* `NODE_VERSION`: `18.x` (ou superior)



---

## 📝 Boas Práticas para Criadores de Conteúdo

1. **Novo Artigo:** Sempre crie uma pasta dentro do destino desejado contendo o arquivo `index.md`:
```text
content/estudos/meu-novo-estudo/
├── index.md
└── capa.jpg

```


2. **Front Matter Recomendado:**
```yaml
---
title: "Título do Estudo"
date: 2026-07-21T12:00:00-03:00
draft: false
description: "Breve resumo para SEO e meta tags."
tags: ["Doutrina", "Estudos"]
---

```



---

📫 **Lar Espírita Cristão**

📍 Itatiba/SP — Brasil

🌐 [lecitatiba.com.br](https://lecitatiba.com.br/)

---

*Feito com café ☕ e canela 🪵*

```

```
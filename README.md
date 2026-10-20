# 🏡 Lar Espírita Cristão (LEC) — Itatiba/SP

> **Portal Institucional & Plataforma de Conteúdo Estático**
> Aplicação Jamstack de alta performance compilada com **Hugo Extended**, busca local via **Pagefind (WebAssembly)** e deploy contínuo em borda global (**Cloudflare Pages**).

---

[![Hugo](https://img.shields.io/badge/SSG-Hugo_Extended_v0.110+-ff4088?style=flat-square&logo=hugo&logoColor=white)](https://gohugo.io/)
[![Pagefind](https://img.shields.io/badge/Search-Pagefind_Wasm-05B585?style=flat-square&logo=webassembly&logoColor=white)](https://pagefind.app/)
[![Deploy](https://img.shields.io/badge/Deployment-Cloudflare_Pages-F38020?style=flat-square&logo=cloudflare&logoColor=white)](https://pages.cloudflare.com/)
![GitHub License](https://img.shields.io/badge/license-MIT-8532D3?style=flat-square&logo=github&logoColor=white)
![Feito com Café](https://img.shields.io/badge/feito_com-café_☕_e_canela_🪵-brown?style=flat-square)

## ⚡ Arquitetura & Engenharia de Performance

O ecossistema foi projetado sob a filosofia **Zero-Server / Edge-First**, garantindo pontuação máxima nos métricos do **Core Web Vitals** (LCP, INP, CLS) e custo zero de infraestrutura.

```text
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

* **Busca Estática em WebAssembly (Pagefind):** Indexação *full-text* pós-build realizada diretamente nos arquivos compilados em `public/`. Não consome APIs pagas, bancos de dados ou serviços externos de busca.
* **Otimização Crítica do LCP:** Layouts de listagem (`layouts/_default/list.html`) reordenados para priorizar a renderização de elementos de texto antes de mídias no viewport mobile.
* **Markdown Render Hooks:** Processamento automatizado de links e mídias (`layouts/_default/_markup/`) injetando `loading="lazy"`, `decoding="async"` e atributos de segurança (`rel="noopener"`).
* **Page Bundles Nativos:** Arquitetura orientada 100% a pacotes autocontidos (`index.md` + imagens `.webp` locais), facilitando extrema portabilidade.

---

## 🛠️ Stack Tecnológica

| Camada | Tecnologia | Função |
| --- | --- | --- |
| **SSG** | [Hugo Extended](https://gohugo.io/) | Gerador de sites estáticos em Go |
| **Search Engine** | [Pagefind](https://pagefind.app/) | Engine de busca estática compilada em Wasm |
| **Tema & UI** | Componentes Locais | Tema 100% customizado (`/layouts`), sem dependência de submódulos |
| **Mídia & Assets** | WebP / Bash Scripts | Conversão nativa, empacotamento e otimização automatizada |
| **Edge Hosting** | [Cloudflare Pages](https://pages.cloudflare.com/) | CI/CD, SSL automatizado e CDN global |

---

## 📂 Estrutura do Repositório

```text
.
├── content/              # Artigos (.md) organizados em Page Bundles
│   ├── agenda/           # Eventos e programações
│   ├── allan-kardec/     # Seção histórica/doutrinária
│   ├── chico-xavier/     # Obras e biografia
│   ├── clube-do-livro-espirita/
│   ├── estudos/          # Cronogramas e material de estudo
│   ├── historia/         # Retrospectivas e histórico do LEC
│   └── jesus/            # Referências crísticas
├── data/                 # Fontes de dados estruturados (yaml)
├── layouts/              # Core estrutural e componentes de template (Tema próprio)
│   ├── _default/         # Layouts de páginas, listas e Render Hooks
│   ├── partials/widgets/ # Widgets (Live Audio, Rádios Espíritas, Spotify, Agenda, Mapa)
│   └── shortcodes/       # Componentes reusáveis (youtube, redes_sociais)
├── scripts/              # Pipelines de automação local (Bash & Python)
│   ├── ssg-bundler.sh    # Converte estruturas antigas em Page Bundles
│   ├── ssg-img-optimizer.sh # Automação de otimização de imagens (.webp)
│   ├── fix-my-hugo.sh    # Script utilitário de reparo
│   └── importar.py       # Script ETL para ingestão externa
├── static/               # Arquivos servidos estaticamente (favicons, css customizado)
├── deploy.sh             # Utilitário root para empacotamento e deploy
└── hugo.toml             # Configuração global da aplicação

```

---

## 🚀 Ambiente de Desenvolvimento Local

### Pré-requisitos

* **Hugo Extended** ($\ge$ v0.110.0)
* **Node.js / NPX** (para execução do Pagefind)
* **Git**

### 1. Clonar o Repositório

Como o projeto agora utiliza arquitetura de layouts totalmente independente (sem submódulos), basta clonar o repositório principal:

```bash
git clone https://github.com/bizumatica/lar-espirita-cristao.git
cd lar-espirita-cristao

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

O repositório conta com scripts utilitários focados na manutenção e otimização dos Page Bundles:

* **Otimização de Imagens (`ssg-img-optimizer.sh` / `ssg-img-optimizer2.sh`):**
Varre o diretório `content/` e converte automaticamente imagens legadas para `.webp`, reduzindo o peso do repositório sem perda legível de qualidade.
```bash
chmod +x scripts/ssg-img-optimizer.sh
./scripts/ssg-img-optimizer.sh

```

* **Gerenciamento de Bundles (`ssg-bundler.sh`):**
Utilitário de transformação de conteúdo markdown isolado em estrutura nativa de Page Bundles do Hugo (`diretorio/index.md`).
* **Ingestão ETL (`importar.py`):**
Script em Python para importar e reestruturar postagens de sistemas legados.

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

1. **Novo Artigo (Page Bundle):** Sempre crie uma pasta dentro da seção correspondente contendo o arquivo `index.md` e suas respectivas imagens em `.webp`:
```text
content/estudos/meu-novo-estudo/
├── index.md
└── capa.webp

```

2. **Front Matter Recomendado (`index.md`):**
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

🌐 [larespiritacristao.org](https://larespiritacristao.org/)

---

*Feito com café ☕ e canela 🪵*
# 🏛️ Lar Espírita Cristão (LEC) - Itatiba/SP

Este é o repositório do site oficial do **Lar Espírita Cristão**, localizado em Itatiba/SP. O projeto foi desenvolvido utilizando o gerador de sites estáticos **Hugo**, focado em velocidade, segurança e facilidade de manutenção.

## 🚀 Tecnologias Utilizadas

* [Hugo](https://gohugo.io/) - Gerador de site estático (SSG).
* [Mainroad Theme](https://github.com/Vimux/Mainroad) - Tema base (customizado).
* [Cloudflare Pages](https://pages.cloudflare.com/) - Hospedagem e Deploy contínuo.
* [GitHub](https://github.com/) - Versionamento de código.

## 📂 Estrutura do Projeto

O projeto segue a estrutura padrão do Hugo na raiz do repositório:

* `/content`: Todos os artigos, páginas e agenda do Lar.
* `/layouts`: Customizações de HTML e Shortcodes (ex: `links_uteis`).
* `/static`: Arquivos estáticos (CSS customizado, imagens, robôts.txt).
* `/themes/mainroad`: O tema visual do site.
* `/data`: Arquivos de dados (YAML/JSON) para alimentar listas dinâmicas.

## 🛠️ Como rodar localmente

Se você deseja testar alterações antes de enviar para o ar:

1.  Certifique-se de ter o **Hugo (Extended version)** instalado.
2.  Clone o repositório:
    ```bash
    git clone [https://github.com/bizumatica/lar-espirita-cristao.git](https://github.com/bizumatica/lar-espirita-cristao.git)
    cd lar-espirita-cristao
    ```
3.  Inicie o servidor de testes:
    ```bash
    hugo server -D
    ```
4.  Acesse: `http://localhost:1313`

## 🎨 Personalização Visual

O site utiliza um esquema de cores sóbrio e acolhedor:
* **Fundo:** Cosmic Latte (`#fff8e7`).
* **Destaques:** Vinho/Bordô (`#800000`) e Azul Sereno (`#4a90e2`).
* **Listagem:** Estilo zebrado automático para facilitar a leitura.

As customizações principais residem em `static/css/custom.css`.

## 🔄 Deploy

O deploy é **automático**. Qualquer alteração enviada para o branch `main` via `git push` aciona um build imediato na Cloudflare Pages.

---
📫 **Lar Espírita Cristão** *Itatiba - SP* [Visite o site oficial](https://lecitatiba.com.br/)
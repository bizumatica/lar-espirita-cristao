import feedparser
import os
import re
from bs4 import BeautifulSoup
from datetime import datetime

DEST_DIR = "./lec/content/post"
BLOGS = [
    ("https://inacioferreira-baccelli.blogspot.com/feeds/posts/default?alt=rss", "Inácio Ferreira / Baccelli"),
    ("https://formiga-baccelli.blogspot.com/feeds/posts/default?alt=rss", "Blog Formiga / Baccelli")
]

if not os.path.exists(DEST_DIR):
    os.makedirs(DEST_DIR)

def limpar_html(html_content):
    if not html_content: return ""
    soup = BeautifulSoup(html_content, "html.parser")
    for script in soup(["script", "style"]): script.decompose()
    text = soup.get_text(separator='\n')
    return '\n'.join(line.strip() for line in text.splitlines() if line.strip())

for url, author in BLOGS:
    print(f"Verificando: {author}")
    feed = feedparser.parse(url)
    
    for entry in feed.entries[:3]:
        # Tenta capturar o título de várias formas
        title = entry.get('title', '').strip()
        
        # Pega o conteúdo para limpar e usar como backup de título
        content_raw = entry.get('content', [{}])[0].get('value', entry.get('description', entry.get('summary', '')))
        clean_text = limpar_html(content_raw)

        # SE O TÍTULO VIER VAZIO: Pega a primeira linha do conteúdo
        if not title or title.lower() == "untitled" or title == "":
            primeira_linha = clean_text.split('\n')[0].strip()
            # Limita a 60 caracteres para não quebrar o layout
            title = (primeira_linha[:60] + '...') if len(primeira_linha) > 60 else primeira_linha

        # Se ainda assim estiver vazio (raro), usa um padrão datado
        if not title:
            title = f"Mensagem de {datetime.now().strftime('%d/%m/%Y')}"

        # Protege aspas para o YAML do Hugo
        title_clean = title.replace('"', '\\"')

        # Resumo do post
        summary = clean_text[:600] + "..." if len(clean_text) > 600 else clean_text

        # Gera o slug (nome do arquivo)
        slug = re.sub(r'[^a-z0-9]+', '-', title.lower()).strip('-')
        if not slug:
            slug = f"post-{datetime.now().strftime('%H%M%S')}"
            
        filepath = os.path.join(DEST_DIR, f"importado-{slug}.md")

        if not os.path.exists(filepath):
            print(f" -> Criando: {title}")
            with open(filepath, "w", encoding="utf-8") as f:
                f.write('---\n')
                f.write(f'title: "{title_clean}"\n')
                f.write(f'date: {datetime.now().strftime("%Y-%m-%dT%H:%M:%S-03:00")}\n')
                f.write(f'draft: false\n')
                f.write(f'categories: ["Leitura Recomendada"]\n')
                f.write('---\n\n')
                f.write(f'###### _por {author}_\n\n')
                f.write(f'{summary}\n\n')
                f.write('---\n\n### Fontes Relacionadas\n\n')
                f.write(f'**Postagem Original:**\n')
                f.write(f'* [Leia o texto completo no Blogspot original]({entry.link})\n\n')
                

print("Processo concluído.")
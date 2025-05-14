import csv
from pathlib import Path
from unicodedata import normalize

base = Path(__file__).parent
scores = base / "data" / "new.csv"
leaderboard = base / "data" / "leaderboard.csv"

soma_scores = {}

with scores.open(newline='', encoding='utf-8') as f:
    leitor = csv.reader(f, delimiter=',')
    next(leitor)
    for linha in leitor:
        curso = normalize("NFKD", linha[2].strip().lower()).encode('ASCII','ignore').decode()
        valor = int(linha[4].strip())

        if curso in soma_scores:
            soma_scores[curso] += valor
        else:
            soma_scores[curso] = valor

sorted_scores = sorted(soma_scores.items(), key=lambda x: x[1], reverse=True)

with leaderboard.open(mode="w", newline='', encoding='utf-8') as f:
    write = csv.writer(f, delimiter=';')
    write.writerow(['Curso', 'Pontuação'])
    for curso, score in sorted_scores:
        write.writerow([curso, score])  # <- usa as variáveis corretas aqui

from faker import Faker
import random
import json

temp = '''
INSERT INTO pessoa VALUES (1, 'João', '["futebol", "natação"]', '{"idade": 28, "time": "Chapecoense"}');
INSERT INTO pessoa VALUES (2, 'Maria', '["leitura", "programação", "dança"]', '{"idade": 39, "trabalha-com-programacao": true, "area": "back-end"}');
INSERT INTO pessoa VALUES (3, 'Ana', '["programação"]', '{"idade": 29, "trabalha-com-programacao": false, "area": "front-end", "areas-de-interesse": ["mobile",
'''

def generate_data():
    fake = Faker('pt_BR')
    data = []
    for i in range(1000):
        programador = random.choice([True, False])

        data.append({
            'nome': fake.name(),
            'idade': random.randint(18, 60),
            'interesses': [fake.word() for _ in range(random.randint(1, 5))],
            'trabalha-com-programacao': programador,
            'area': random.choice(['front-end', 'back-end', 'full-stack']),
            'products': {
                'name': fake.word(),
                'price': random.randint(1, 1000)
            }
            'areas-de-interesse': [fake.word() for _ in range(random.randint(1, 5))],
            'time': random.choice(['Chapecoense', 'Internacional', 'Grêmio', 'Flamengo', 'São Paulo', 'Palmeiras', 'Corinthians', 'Santos', 'Cruzeiro', 'Atlético-MG', 'Fluminense', 'Botafogo', 'Vasco', 'Bahia'
            ])
        })
    return data

for i in generate_data():
    print(f"INSERT INTO pessoa VALUES (1, '{i['nome']}', '{i['interesses']}', '{i['idade']}', '{i['trabalha-com-programacao']}', '{i['area']}', '{i['areas-de-interesse']}', '{i['time']}');")

from faker import Faker
import random
import json

def generate_data():
    fake = Faker('pt_BR')
    data = []
    for i in range(1000):
        programador = random.choice([True, False])

        data.append({
            'nome': fake.name(),
            'idade': random.randint(18, 60),
            'interesses': [fake.word() for _ in range(random.randint(1, 5))],
            'trabalha_com_programacao': programador,
            'area': random.choice(['front-end', 'back-end', 'full-stack']),
            'products': {
                'name': fake.word(),
                'price': random.randint(1, 1000),
            },
            'areas_de_interesse': [fake.word() for _ in range(random.randint(1, 5))],
            'time': {
                'nome_time': fake.word(),
                'esporte': random.choice(['Futebol', 'Basquete', 'Vôlei', 'Tênis', 'Handebol']),
            }
        })
    return data

for item in generate_data():
    sql = f"INSERT INTO pessoa (nome, idade, interesses, trabalha_com_programacao, area, products, areas_de_interesse, time) VALUES ("
    sql += f"'{item['nome']}', {item['idade']}, '{json.dumps(item['interesses'])}', "
    sql += f"{item['trabalha_com_programacao']}, '{item['area']}', "
    sql += f"'{json.dumps(item['products'])}', '{json.dumps(item['areas_de_interesse'])}', "
    sql += f"'{json.dumps(item['time'])}'::jsonb);"
    print(sql)

# Prática de json com Postgres

## Objetivo da prática

Apresentar o tipo JSON, um contexto útil e como usar de suas operações e funções.

## Tópico e conceitos relevantes

- Inserir e consultar campos que do tipo JSON
- Operadores JSON (->,->>,@>,?>, etc)
- Funções JSON (json_object_keys)
- Tipo JSON e JSONB

## Recursos necessários

- Docker
- Docker compose

## Materiais de apoio

Links para consulta:
[Tipo JSON](https://www.postgresql.org/docs/current/datatype-json.html)
[Funções e Operações com JSON](https://www.postgresql.org/docs/current/functions-json.html#FUNCTIONS-JSONB-OP-TABLE)
[Postgres Tutorial](https://postgresqltutorial.com/postgresql-tutorial/postgresql-json/)
[Tutorial FreeCodeCamp](https://www.freecodecamp.org/news/postgresql-and-json-use-json-data-in-postgresql/)

## Descrição das tarefas

- Dentre os produtos busque aqueles que tem a categoria "Toys & Games"
  RESPOSTA:

```sql
    SELECT \* FROM products_amazon WHERE category::jsonb @> '["Toys & Games"]'::jsonb;
```

- Busque quais são as especificações possíveis em details
  RESPOSTA:

```sql
   SELECT DISTINCT json_object_keys(details::json) FROM products_amazon;
```

- Dentre os produtos busque, se exitir, aqueles que são recomendados (manufacture_recommended_age) para pessoas acima de 14 anos. Use como valor a string "14yearsandup".
  RESPOSTA:

```sql
   SELECT \* FROM products_amazon WHERE (details->>'manufacture_recommended_age')::TEXT = '14yearsandup';
```

OU

```sql
  SELECT name
  FROM products_amazon
  WHERE details->>'manufacture_recommended_age' = '14yearsandup';
```

- Liste todas as diferentes categorias: SELECT (category) FROM products_amazon;
  RESPOSTA:

```sql
  SELECT DISTINCT json_array_elements_text(category) FROM products_amazon
```

- Liste todas as especificações distintas em details
  RESPOSTA:

```sql
SELECT DISTINCT jsonb_object_keys(details) FROM products_amazon;
```

- O setor de marketing, visando a criação de uma nova campanha para o próximo trimestre, quer saber quais categorias mais aparecem no catálogo de produtos, quantos produtos e quais são esses produtos.
  RESPOSTA:

```sql

```

- Vamos precisar transportar alguns produtos, pra isso, o setor de logistica pediu uma lista dos produtos que possuem o volume

RESPOSTA:

```sql

```

## Exemplo de entrega

## Critérios de avaliação

## Datas e prazos

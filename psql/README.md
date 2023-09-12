# Postgres SQL

## Como rodar

### Docker

```bash
docker run --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres
```

### Docker Compose

Para roda o docker compose é necessário ter o docker-compose instalado na máquina.

Para iniciar os containers:

```bash
docker compose up -d
```

Para parar os containers:

```bash
docker compose down
```

## Acessando o banco de dados

### Docker

Acessa o container e executa o psql

```bash
docker exec -it postgres psql -U postgres
```

## [Backup e Restore](https://www.postgresql.org/docs/current/app-pgdump.html)

Gera um backup do banco de dados

```bash
pg_dump -U postgres -h localhost -F p -p 5432 -d postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
```

F: formato do arquivo de backup
    - c: custom
    - d: directory
    - p: plain
    - t: tar

-U: usuário do banco de dados

-h: host do banco de dados

-p: porta do banco de dados

-d: nome do banco de dados

-c: limpa o banco de dados antes de restaurar

-t: especifica a tabela a ser restaurada

Acessa o container e executa o pg_dumpall

```bash
docker exec -t postgres pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
```

## Restore

Executa o arquivo de backup direto no banco de dados

```bash
psql -U postgres -h localhost -p 5432 -d postgres -f dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
```

## Como criar um banco de dados

Acessar o banco de dados

```bash
psql -U postgres -h localhost -p 5432 -d postgres
```

Criar o banco de dados

```sql
CREATE DATABASE database_name;
```

## Commands of PSQL

l: lista os bancos de dados

```bash
\l
```

c: conecta a um banco de dados

```bash
\c database_name
```

d: lista as tabelas

```bash
\d
```

d [table_name]: lista as colunas da tabela [table_name]

```bash
\d table_name
```

dT [type_data]: lista informações sobre o tipo de dado [type_data]

```bash
\dT type_data
```

q: sai do psql

```bash
\q
```

s: lista o histórico de comandos executados na sessão

```bash
\s
```

h: lista de comandos sql disponíveis

```bash
\h
```

?: lista de comandos psql disponíveis

```bash
\?
```

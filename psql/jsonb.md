# JSON

```sql
CREATE TABLE pessoa ( 
 id serial NOT NULL,
 nome text,
 interesses jsonb,
 informacoes_adicionais jsonb
);
```

```sql
INSERT INTO pessoa VALUES (1, 'João', '["futebol", "natação"]', '{"idade": 28, "time": "Chapecoense"}');
INSERT INTO pessoa VALUES (2, 'Maria', '["leitura", "programação", "dança"]', '{"idade": 39, "trabalha-com-programacao": true, "area": "back-end"}');
INSERT INTO pessoa VALUES (3, 'Ana', '["programação"]', '{"idade": 29, "trabalha-com-programacao": false, "area": "front-end", "areas-de-interesse": ["mobile", "design"]}');
```

```sql
SELECT informacoes_adicionais->'areas-de-interesse' FROM pessoa;
```

```sql
SELECT informacoes_adicionais->'areas-de-interesse' FROM pessoa WHERE informacoes_adicionais ? 'areas-de-interesse';
```

```sql
SELECT informacoes_adicionais->'areas-de-interesse' FROM pessoa WHERE informacoes_adicionais @> '{"areas-de-interesse": ["mobile"]}';
```

```sql
SELECT informacoes_adicionais FROM pessoa WHERE informacoes_adicionais->'area' = '"back-end"';
```

## Índice

```sql
CREATE INDEX idx_pessoa_informacoes_adicionais ON pessoa USING gin (informacoes_adicionais);
```

## Funções para json

Tem diferença entre json e jsonb

Mostrar diferença de perfomance com \timing ativado

```sql

```sql
SELECT json_object_keys(informacoes_adicionais) FROM pessoa;
```

```sql
SELECT array_elements(interesses) FROM pessoa;
```

```sql
```

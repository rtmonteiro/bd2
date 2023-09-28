# Perguntas da Aula

1. Qual o maior produto em volume?

```sql
-- Qual o maior product dimension?
WITH product_dimensions AS (
SELECT name, CAST(details->'product_dimensions' as text) as dimensions 
FROM "products_amazon"
WHERE details ? 'product_dimensions'
LIMIT 50
)

SELECT name, (regexp_replace(dimensions, '.*"(\d+\.*\d*)x(\d+\.*\d*)x(\d+\.*\d*)inches".*', E'\\1', 'g')::numeric) *
             (regexp_replace(dimensions, '.*"(\d+\.*\d*)x(\d+\.*\d*)x(\d+\.*\d*)inches".*', E'\\2', 'g')::numeric) *
             (regexp_replace(dimensions, '.*"(\d+\.*\d*)x(\d+\.*\d*)x(\d+\.*\d*)inches".*', E'\\3', 'g')::numeric) as volume
FROM product_dimensions
ORDER BY volume desc
```

\connect "postgres";

DROP TABLE IF EXISTS "products_amazon";

CREATE TABLE products_amazon (
    id TEXT, name TEXT , category JSON, price TEXT, description TEXT, details JSONB
);

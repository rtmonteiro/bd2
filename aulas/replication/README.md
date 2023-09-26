# replication

## Como rodar

```bash
docker-compose up -d
```

[replication](https://ubiq.co/database-blog/how-to-replicate-mysql-database-to-another-server/)


```sql
CREATE USER "repl"@"%" IDENTIFIED BY "12345";
GRANT REPLICATION SLAVE ON "." TO "repl"@"%";
FLUSH PRIVILEGES;
SHOW MASTER STATUS;
```

```sql
CHANGE REPLICATION SOURCE TO MASTER_HOST='principal', MASTER_USER='repl', MASTER_PASSWORD='12345';
START REPLICA;
SHOW REPLICA STATUS;
```

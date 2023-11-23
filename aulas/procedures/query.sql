SET @key = 'SELECT * FROM races;';
SET @script = 'SELECT * FROM races ORDER By `raceId` DESC;';
SET @result = 0;
call `execAndCompareSQLSelect`(@key,@script, FALSE, FALSE, @result);
select @result;

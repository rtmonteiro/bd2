-- ========================================================================
--  Copyright Universidade Federal do Espirito Santo (Ufes)
-- 
--  This program is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
-- 
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
-- 
--  You should have received a copy of the GNU General Public License
--  along with this program.  If not, see <https://www.gnu.org/licenses/>.
--  
--  This program is released under license GNU GPL v3+ license.
-- 
-- ========================================================================

DROP PROCEDURE IF EXISTS `execAndCompareSQLSelect`;

DELIMITER ;;

CREATE PROCEDURE `execAndCompareSQLSelect`(IN `key_stmt` varchar(8192), IN `user_stmt` varchar(8192), IN `chk_cols` tinyint, OUT `resp` int)
proc_verify:BEGIN
	# Exception handlher
	# https://stackoverflow.com/questions/35867207/exception-using-try-catch-in-mysql-stored-procedure
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		BEGIN
			-- body of handler
			SET resp = 2;
			#GET DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
			#SELECT CONCAT(@p1, ':', @p2);
			DROP TEMPORARY TABLE IF EXISTS temp1;
			DROP TEMPORARY TABLE IF EXISTS temp2;
		END;
-- 	DECLARE EXIT HANDLER FOR SQLWARNING
-- 		BEGIN
			-- body of handler
-- 			SET resp = 2;
-- 			DROP TEMPORARY TABLE IF EXISTS temp1;
-- 			DROP TEMPORARY TABLE IF EXISTS temp2;
-- 		END;
	DECLARE EXIT HANDLER FOR NOT FOUND
		BEGIN
			-- body of handler
			SET resp = 2;
			DROP TEMPORARY TABLE IF EXISTS temp1;
			DROP TEMPORARY TABLE IF EXISTS temp2;
		END;

	# Create Temp tables
	# http://www.mysqltutorial.org/mysql-temporary-table/
	SET @query := CONCAT('CREATE TEMPORARY TABLE temp1 ', key_stmt);
	PREPARE dynamic_statement FROM @query;
	EXECUTE dynamic_statement;

	SET @query := CONCAT('CREATE TEMPORARY TABLE temp2 ', user_stmt);
	PREPARE dynamic_statement FROM @query;
	EXECUTE dynamic_statement;

	# Count number of columns
	SET @count_columns1 = 0;
	SHOW COLUMNS FROM temp1
	WHERE @count_columns1 := @count_columns1 + 1;
	SET @count_columns2 = 0;
	SHOW COLUMNS FROM temp2
	WHERE @count_columns2 := @count_columns2 + 1;

	# Leave procedure in case number of columns differs
	IF @count_columns1 <> @count_columns2 THEN
		SET resp = 0;
		DROP TEMPORARY TABLE temp1;
		DROP TEMPORARY TABLE temp2;
		LEAVE proc_verify;
	END IF;

	# List temporary tables' columns
	# https://stackoverflow.com/questions/25138810/list-temporary-table-columns-in-mysql
	SET @columns_string1 = '';
	SHOW COLUMNS FROM temp1
	WHERE @columns_string1 := CONCAT(@columns_string1, '(a.`',`Field`, '` = b.`',`Field`, '` OR a.`',`Field`, '` IS NULL', ' OR b.`',`Field`, '` IS NULL) AND ');
	# Strip last 5 characters of a string
	# https://stackoverflow.com/questions/6080662/strip-last-two-characters-of-a-column-in-mysql
	SET @columns_string1 = LEFT(@columns_string1,length(@columns_string1)-5);
	#SELECT @columns_string1;

	SET @columns_string2 = '';
	SHOW COLUMNS FROM temp2
	WHERE @columns_string2 := CONCAT(@columns_string2, '(a.`',`Field`, '` = b.`',`Field`, '` OR a.`',`Field`, '` IS NULL', ' OR b.`',`Field`, '` IS NULL) AND ');
	# Strip last 5 characters of a string
	# https://stackoverflow.com/questions/6080662/strip-last-two-characters-of-a-column-in-mysql
	SET @columns_string2 = LEFT(@columns_string2,length(@columns_string2)-5);
	#SELECT @columns_string2;

	# Check if both queries have the same columns. If not, leave procedure
	IF chk_cols = TRUE AND @columns_string1 <> @columns_string2 THEN
		SET resp = 0;
		DROP TEMPORARY TABLE temp1;
		DROP TEMPORARY TABLE temp2;
		LEAVE proc_verify;
	END IF;

	# Necessary in case we do not look for same column names
	SET @columns = '';
	SHOW COLUMNS FROM temp1
	WHERE @columns := CONCAT(@columns, '(a.`',`Field`, '` = b. OR a.`',`Field`, '` IS NULL', ' OR b. IS NULL) AND ');
	# Strip last 5 characters of a string
	# https://stackoverflow.com/questions/6080662/strip-last-two-characters-of-a-column-in-mysql
	SET @columns = LEFT(@columns,length(@columns)-5);
	#SELECT @columns;
	# Add 2nd query's column names to string. For each column name, we need to replace it twice
	SHOW COLUMNS FROM temp2
	WHERE @columns := CONCAT(REPLACE(LEFT(CONCAT(REPLACE(LEFT(@columns, INSTR(@columns, 'b.')+1), 'b.', CONCAT('c.`',`Field`,'`')), SUBSTRING(@columns, INSTR(@columns, 'b.') + 2)), INSTR(CONCAT(REPLACE(LEFT(@columns, INSTR(@columns, 'b.')+1), 'b.', CONCAT('c.`',`Field`,'`')), SUBSTRING(@columns, INSTR(@columns, 'b.') + 2)), 'b.')+1), 'b.', CONCAT('c.`',`Field`,'`')), SUBSTRING(CONCAT(REPLACE(LEFT(@columns, INSTR(@columns, 'b.')+1), 'b.', CONCAT('c.`',`Field`,'`')), SUBSTRING(@columns, INSTR(@columns, 'b.') + 2)), INSTR(CONCAT(REPLACE(LEFT(@columns, INSTR(@columns, 'b.')+1), 'b.', CONCAT('c.`',`Field`,'`')), SUBSTRING(@columns, INSTR(@columns, 'b.') + 2)), 'b.') + 2));
	#SELECT @columns;
	SET @columns := REPLACE(@columns,'c.','b.');
	#SELECT @columns;

	# Leave procedure in case number of rows differs
	SELECT count(*) FROM temp1 INTO @num1;
	SELECT count(*) FROM temp2 INTO @num2;
	IF @num1 <> @num2 THEN
		SET resp = 0;
		DROP TEMPORARY TABLE temp1;
		DROP TEMPORARY TABLE temp2;
		LEAVE proc_verify;
	END IF;

	# Checking whether two tables have identical content
	# https://dba.stackexchange.com/questions/72641/checking-whether-two-tables-have-identical-content-in-postgresql
	# Equivalent of EXCEPT in MySQL
	# https://dba.stackexchange.com/questions/195592/what-is-an-equivalent-of-exceptin-postgresql-in-mysql
	# Storing a variable with the result of an SELECT CASE
	# https://stackoverflow.com/questions/7871014/mysql-storing-a-variable-with-the-result-of-an-select-case
	SET @query = CONCAT(
		'SELECT CASE WHEN EXISTS (SELECT DISTINCT * 
								  FROM temp1 a 
								  WHERE NOT EXISTS (SELECT 1 FROM temp2 b WHERE ', @columns, ')
								 )
					 THEN FALSE
					 ELSE TRUE
				END INTO @result');
	PREPARE dynamic_statement FROM @query;
	EXECUTE dynamic_statement;
	DEALLOCATE PREPARE dynamic_statement;

	IF @result = FALSE THEN
		SET resp = 0;
		DROP TEMPORARY TABLE temp1;
		DROP TEMPORARY TABLE temp2;
		LEAVE proc_verify;
	END IF;

	SET @query = CONCAT(
		'SELECT CASE WHEN EXISTS (SELECT DISTINCT * 
								  FROM temp2 b 
								  WHERE NOT EXISTS (SELECT 1 FROM temp1 a WHERE ', @columns, ')
								 )
					 THEN FALSE
					 ELSE TRUE
				END INTO @result');
	PREPARE dynamic_statement FROM @query;
	EXECUTE dynamic_statement;
	DEALLOCATE PREPARE dynamic_statement;
	
	IF @result = FALSE THEN
		SET resp = 0;
	ELSE
		SET resp = 1;
	END IF;

	DROP TEMPORARY TABLE temp1;
	DROP TEMPORARY TABLE temp2;
END;;

DELIMITER ;

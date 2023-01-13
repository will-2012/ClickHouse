DROP TABLE IF EXISTS table_02513;

CREATE TABLE table_02513 (n UInt64) ENGINE=MergeTree() ORDER BY tuple() SETTINGS index_granularity=100;

INSERT INTO table_02513 SELECT number+11*13*1000 FROM numbers(20);

SET allow_experimental_lightweight_delete=1;
SET mutations_sync=2;
SET max_threads=1;

DELETE FROM table_02513 WHERE n%10=0;

-- { echoOn }
SELECT * FROM table_02513;
SELECT * FROM table_02513 WHERE n%11;
SELECT * FROM table_02513 PREWHERE n%11;
SELECT * FROM table_02513 WHERE n%11 AND n%13;
SELECT * FROM table_02513 PREWHERE n%11 WHERE n%13;

SELECT * FROM table_02513 WHERE n%143011; -- { serverError ILLEGAL_TYPE_OF_COLUMN_FOR_FILTER }
SELECT * FROM table_02513 PREWHERE n%143011; -- { serverError ILLEGAL_TYPE_OF_COLUMN_FOR_FILTER }
SELECT * FROM table_02513 WHERE n%143011 AND n%13;
SELECT * FROM table_02513 PREWHERE n%143011 WHERE n%13; -- { serverError ILLEGAL_TYPE_OF_COLUMN_FOR_FILTER }
-- { echoOff }

DROP TABLE table_02513;

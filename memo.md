# MEMO

$ sudo mysqldumpslow /var/log/mysql/mysql-slow.log

Reading mysql slow query log from /var/log/mysql/mysql-slow.log  
Count: 1 Time=2.19s (2s) Lock=0.00s (0s) Rows=0.0 (0), isucon[isucon]@localhost  
 DELETE FROM visit_history WHERE created_at >= 'S'

Count: 1474 Time=0.08s (116s) Lock=0.00s (0s) Rows=80.1 (118006), isucon[isucon]@localhost  
 SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = N AND competition_id = 'S' GROUP BY player_id

Count: 1 Time=0.01s (0s) Lock=0.00s (0s) Rows=0.0 (0), isucon[isucon]@localhost  
 DELETE FROM tenant WHERE id > N

Count: 7 Time=0.01s (0s) Lock=0.00s (0s) Rows=0.0 (0), isucon[isucon]@localhost  
 INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES ('S', 'S', N, N)

Count: 774 Time=0.01s (4s) Lock=0.00s (0s) Rows=0.0 (0), isucon[isucon]@localhost  
 INSERT INTO visit_history (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('S', N, 'S', N, N)

Count: 1 Time=0.01s (0s) Lock=0.00s (0s) Rows=0.0 (0), isucon[isucon]@localhost  
 UPDATE id_generator SET id=N WHERE stub='S'

Count: 9076 Time=0.01s (47s) Lock=0.00s (34s) Rows=0.0 (0), isucon[isucon]@localhost
REPLACE INTO id_generator (stub) VALUES ('S')

Count: 2 Time=0.00s (0s) Lock=0.00s (0s) Rows=5.0 (10), root[root]@localhost
show databases

Count: 2 Time=0.00s (0s) Lock=0.00s (0s) Rows=3.0 (6), root[root]@localhost
show tables

Count: 2 Time=0.00s (0s) Lock=0.00s (0s) Rows=1.0 (2), 2users@localhost
select @@version_comment limit N

Count: 1857 Time=0.00s (0s) Lock=0.00s (0s) Rows=1.0 (1856), isucon[isucon]@localhost
SELECT \* FROM tenant WHERE name = 'S'

Count: 11 Time=0.00s (0s) Lock=0.00s (0s) Rows=105.0 (1155), isucon[isucon]@localhost
SELECT \* FROM tenant ORDER BY id DESC

Count: 1 Time=0.00s (0s) Lock=0.00s (0s) Rows=0.0 (0), root[root]@localhost
show create table tenant

Count: 1 Time=0.00s (0s) Lock=0.00s (0s) Rows=0.0 (0), root[root]@localhost  
 show create table visit_history

Count: 774 Time=0.00s (0s) Lock=0.00s (0s) Rows=1.0 (774), isucon[isucon]@localhost
SELECT \* FROM tenant WHERE id = N

Count: 1 Time=0.00s (0s) Lock=0.00s (0s) Rows=1.0 (1), root[root]@localhost
SELECT DATABASE()

Count: 28402 Time=0.00s (1s) Lock=0.00s (0s) Rows=4.2 (120637), 2users@localhost

#

Count: 3 Time=0.00s (0s) Lock=0.00s (0s) Rows=0.0 (0), root[root]@localhost

Count: 477 Time=0.00s (0s) Lock=0.00s (0s) Rows=0.0 (0), 0users@0hosts
administrator command: Quit

Count: 13962 Time=0.00s (0s) Lock=0.00s (0s) Rows=0.0 (0), 0users@0hosts
administrator command: Close stmt

Count: 13962 Time=0.00s (0s) Lock=0.00s (0s) Rows=0.0 (0), 0users@0hosts
administrator command: Prepare

+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+---------+----------+------------------------------+
| id | select_type | table | partitions | type | possible_keys | key | key_len | ref | rows | filtered | Extra |
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+---------+----------+------------------------------+
| 1 | SIMPLE | visit_history | NULL | ref | tenant_id_idx | tenant_id_idx | 8 | const | 1472380 | 10.00 | Using where; Using temporary |
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+---------+----------+------------------------------+

# index を貼る

```
alter table visit_history add index competition_id_idx(competition_id);
```

mysql> explain SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = 1 AND competition_id = '1' GROUP BY player_id;

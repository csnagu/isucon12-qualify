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
+----+-------------+---------------+------------+------+----------------------------------+--------------------+---------+-------+------+----------+------------------------------+
| id | select_type | table | partitions | type | possible_keys | key | key_len | ref | rows | filtered | Extra |
+----+-------------+---------------+------------+------+----------------------------------+--------------------+---------+-------+------+----------+------------------------------+
| 1 | SIMPLE | visit_history | NULL | ref | tenant_id_idx,competition_id_idx | competition_id_idx | 1022 | const | 1 | 50.00 | Using where; Using temporary |
+----+-------------+---------------+------------+------+----------------------------------+--------------------+---------+-------+------+----------+------------------------------+

sudo rm /var/log/mysql/mysql-slow.log
sudo mysqladmin flush-logs -p

次の調査クエリ
EXPLAIN DELETE FROM visit_history WHERE created_at >= 'S';

+----+-------------+---------------+------------+------+---------------+------+---------+------+---------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys | key | key_len | ref | rows | filtered | Extra |
+----+-------------+---------------+------------+------+---------------+------+---------+------+---------+----------+-------------+
| 1 | DELETE | visit_history | NULL | ALL | NULL | NULL | NULL | NULL | 2944769 | 100.00 | Using where |
+----+-------------+---------------+------------+------+---------------+------+---------+------+---------+----------+-------------+

alter table visit_history add index created_at_idx(created_at);

node ディレクトリを差し替える
https://github.com/csnagu/isucon12-qualify

app を git 管理する

mysql が CPU 食ってる気がする

アプリが MySQL を効率よく使えるか
コネクションプーリング
MySQL の設定見直せるか
スロークエリ
キャッシュ
delete の結果を待たずにレスポンス返してもよさそう

digest で見た怪しいクエリ
SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = 1 AND competition_id = '1a0205203' GROUP BY player_id

alter table visit_history add index player_id_idx(player_id);

インデックスの削除
ALTER TABLE <table_name> DROP INDEX <index_name>;

Using temporary ... クエリがメモリに乗り切っていない。mysql が使えるメモリサイズをチューニングする

- query_cache_size
  innodb_buffer_pool_size = 256M
  innodb_log_file_size = 64M
  SELECT @@GLOBAL.INNODB_BUFFER_POOL_SIZE/1024/1024 as メモリサイズ（単位：MB）;

CREATE INDEX idx_creat_tenid_compid_plid on visit_history (created_at, tenant_id, competition_id, player_id);

ALTER TABLE visit_history DROP INDEX competition_id_idx;
alter table visit_history add index competition_id_idx(competition_id);
alter table visit_history drop index tenant_id_idx;
alter table visit_history drop index player_id_idx;

alter table visit_history drop index idx_creat_tenid_compid_plid;
CREATE INDEX idx_tenid_compid_plid on visit_history (tenant_id, competition_id, player_id);

ベンチマークで critical なエラーが 1 件出始める

```
04:33:16.685811 error: 大会結果CSV入稿 POST /api/organizer/competition/9fa537af/score : expected([200]) != actual(500) tenant:m-gfrzya-1658550759 role:organizer playerID:organizer competitionID:9fa537af  CSV length:15bytes
04:33:40.940828 SCORE: 2055 (+2283 -228(10%))
```

早くならないクエリ ->
explain SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = 1 AND competition_id = '1a0205203' GROUP BY player_id;
BY player_id;
+----+-------------+---------------+------------+------+-----------------------+-----------------------+---------+-------------+--------+--------
--+-------+
| id | select_type | table | partitions | type | possible_keys | key | key_len | ref | rows | filtere
d | Extra |
+----+-------------+---------------+------------+------+-----------------------+-----------------------+---------+-------------+--------+--------
--+-------+
| 1 | SIMPLE | visit_history | NULL | ref | idx_tenid_compid_plid | idx_tenid_compid_plid | 1030 | const,const | 157642 | 100.0
0 | NULL |
+----+-------------+---------------+------------+------+-----------------------+-----------------------+---------+-------------+--------+--------
--+-------+
query_cache_size = 40000;
SET GLOBAL query_cache_size = 40000;

$ mysql --version  
mysql Ver 8.0.29-0ubuntu0.22.04.2 for Linux on x86_64 ((Ubuntu))

nginx の設定変えてみる
/home/isucon

location ~ ^/(favicon\.ico|css/|js/|img/) {
root: /home/isucon/public/;
expires: 1d;
}

ベンチマーク実行時のアクセスログ集計
sudo cat /var/log/nginx/access.log | sudo alp json -r -m "/api/player/competition/._","/api/player/player/._","/api/organizer/competition/._","/api/organizer/player/._"
静的なファイルを nginx から配布する（効いたかも
explain query plan SELECT \* FROM player_score WHERE tenant_id = ? AND competition_id = ? ORDER BY row_num DESC

DROP TABLE IF EXISTS competition;
DROP TABLE IF EXISTS player;
DROP TABLE IF EXISTS player_score;

CREATE TABLE competition (
id VARCHAR(255) NOT NULL PRIMARY KEY,
tenant_id BIGINT NOT NULL,
title TEXT NOT NULL,
finished_at BIGINT NULL,
created_at BIGINT NOT NULL,
updated_at BIGINT NOT NULL
);

CREATE TABLE player (
id VARCHAR(255) NOT NULL PRIMARY KEY,
tenant_id BIGINT NOT NULL,
display_name TEXT NOT NULL,
is_disqualified BOOLEAN NOT NULL,
created_at BIGINT NOT NULL,
updated_at BIGINT NOT NULL
);

CREATE TABLE player_score (
id VARCHAR(255) NOT NULL PRIMARY KEY,
tenant_id BIGINT NOT NULL,
player_id VARCHAR(255) NOT NULL,
competition_id VARCHAR(255) NOT NULL,
score BIGINT NOT NULL,
row_num BIGINT NOT NULL,
created_at BIGINT NOT NULL,
updated_at BIGINT NOT NULL
);
~

ロックをずらしてみる

06:35:57.789286 初期化リクエストに成功しました 実装言語:node
06:35:57.789309 整合性チェックを開始します
06:36:01.928200 error: 大会内のランキング取得: ページングなし,上限 100 件 GET /api/player/competition/9fa52403/ranking 大会のランキングの結果の最大は 100 件である必要があります (want: 100, got: 0) tenant:edz-sdd-1658558157 role:player playerID:9fa52406 competitionID:9fa52403 rankAfter:
06:36:03.016008 error: 大会内のランキング取得: 入稿と同時 GET /api/player/competition/9fa5252a/ranking 大会のランキング数が不足しています (expect: 99, got: 0) tenant:kddt-jvwxf-1658558157 role:player playerID:9fa52401 competitionID:9fa5252a rankAfter:
06:36:03.016134 整合性チェックを終了します
06:36:03.016145 整合性チェックに失敗しました
06:36:04.016551 ERROR[0] prepare: load-validation: GET /api/player/competition/9fa52403/ranking 大会のランキングの結果の最大は 100 件である必要があります (want: 100, got: 0) tenant:edz-sdd-1658558157 role:player playerID:9fa52406 competitionID:9fa52403 rankAfter:
06:36:04.016574 ERROR[1] prepare: load-validation: GET /api/player/competition/9fa5252a/ranking 大会のランキング数が不足しています (expect: 99, got: 0) tenant:kddt-jvwxf-1658558157 role:player playerID:9fa52401 competitionID:9fa5252a rankAfter:
06:36:04.016770 Error 2 (Critical:0)
06:36:04.016773 PASSED: false
06:36:04.016775 SCORE: 0 (+0 0(2%))

node sqlite3 in-memory
https://github.com/TryGhost/node-sqlite3/wiki/API#new-sqlite3databasefilename-mode-callback

07:33:03.244964 初期化リクエストに成功しました 実装言語:node
07:33:03.244987 整合性チェックを開始します
07:33:07.385914 error: 大会内のランキング取得: ページングなし,上限 100 件 GET /api/player/competition/9fa52406/ranking 大会のランキングの結果の最大は 100 件である必要があります (want: 100, got: 0) tenant:guwp-wc-1658561583 role:player playerID:9fa5240a competitionID:9fa52406 rankAfter:
07:33:08.741553 error: 大会内のランキング取得: 入稿と同時 GET /api/player/competition/9fa52526/ranking 大会のランキング数が不足しています (expect: 99, got: 0) tenant:tij-q-1658561583 role:player playerID:9fa52401 competitionID:9fa52526 rankAfter:
07:33:08.741700 整合性チェックを終了します
07:33:08.741711 整合性チェックに失敗しました
07:33:09.742265 ERROR[0] prepare: load-validation: GET /api/player/competition/9fa52406/ranking 大会のランキングの結果の最大は 100 件である必要があります (want: 100, got: 0) tenant:guwp-wc-1658561583 role:player playerID:9fa5240a competitionID:9fa52406 rankAfter:
07:33:09.742285 ERROR[1] prepare: load-validation: GET /api/player/competition/9fa52526/ranking 大会のランキング数が不足しています (expect: 99, got: 0) tenant:tij-q-1658561583 role:player playerID:9fa52401 competitionID:9fa52526 rankAfter:
07:33:09.742453 Error 2 (Critical:0)
07:33:09.742456 PASSED: false
07:33:09.742459 SCORE: 0 (+0 0(2%))

mysql を ↓ につないでみる
35.79.162.189

08:10:30.759613 初期化リクエストに成功しました 実装言語:node
08:10:30.759633 整合性チェックを開始します
08:10:34.938431 error: 大会結果 CSV 入稿 POST /api/organizer/competition/9fa52529/score : expected([200]) != actual(502) tenant:v-jask-1658563830 role:organizer playerID:organizer competitionID:9fa52529 CSV length:1302bytes
08:10:34.939066 error: 大会内のランキング取得: ページングあり GET /api/player/competition/9fa52405/ranking : expected([200]) != actual(502) tenant:pp-l-1658563830 role:player playerID:9fa52408 competitionID:9fa52405 rankAfter:100
08:10:34.939119 整合性チェックを終了します
08:10:34.939126 整合性チェックに失敗しました
08:10:35.939212 ERROR[0] prepare: load-validation: POST /api/organizer/competition/9fa52529/score : expected([200]) != actual(502) tenant:v-jask-1658563830 role:organizer playerID:organizer competitionID:9fa52529 CSV length:1302bytes
08:10:35.939238 ERROR[1] prepare: load-validation: GET /api/player/competition/9fa52405/ranking : expected([200]) != actual(502) tenant:pp-l-1658563830 role:player playerID:9fa52408 competitionID:9fa52405 rankAfter:100
08:10:35.939420 Error 2 (Critical:0)
08:10:35.939423 PASSED: false
08:10:35.939426 SCORE: 0 (+0 0(2%))

08:44:19.069327 error: テナントへプレイヤー追加 POST /api/organizer/players/add : expected([200]) != actual(500) tenant:zzsju-clud-1658565858 role:organizer playerID:organizer playerDisplayNames length:100
08:44:19.151829 error: テナントへプレイヤー追加 POST /api/organizer/players/add : expected([200]) != actual(500) tenant:badrequest-tenantid role:organizer playerID:organizer playerDisplayNames length:100
08:44:19.160154 error: テナントへプレイヤー 101 人追加 POST /api/organizer/players/add : expected([200]) != actual(500) tenant:nyxlm-sxlofk-1658565859 role:organizer playerID:organizer playerDisplayNames length:101
08:44:19.510209 error: テナント内の大会情報取得: 不正なリクエスト(存在しないプレイヤー) GET /api/player/competitions : expected([401]) != actual(500) tenant:bofbo-zzcw-1658565859 role:player playerID:0000000000
08:44:19.911372 整合性チェックを終了します
08:44:19.911380 整合性チェックに失敗しました
08:44:20.911527 ERROR[0] prepare: load-validation: POST /api/organizer/players/add : expected([200]) != actual(500) tenant:zzsju-clud-1658565858 role:organizer playerID:organizer playerDisplayNames length:100
08:44:20.911547 ERROR[1] prepare: load-validation: POST /api/organizer/players/add : expected([200]) != actual(500) tenant:badrequest-tenantid role:organizer playerID:organizer playerDisplayNames length:100
08:44:20.911551 ERROR[2] prepare: load-validation: POST /api/organizer/players/add : expected([200]) != actual(500) tenant:nyxlm-sxlofk-1658565859 role:organizer playerID:organizer playerDisplayNames length:101
08:44:20.911554 ERROR[3] prepare: load-validation: GET /api/player/competitions : expected([401]) != actual(500) tenant:bofbo-zzcw-1658565859 role:player playerID:0000000000

08:46:48.276803 error: プレイヤーと戦績情報取得 GET /api/player/player/9fa52463 : expected([200]) != actual(500) tenant:vzjzh-ebl-1658566004 role:player playerID:9fa52408 playerID:9fa52463
08:46:49.364144 error: プレイヤーと戦績情報取得: 入稿後 GET /api/player/player/9fa52417 : expected([200]) != actual(500) tenant:ffazs-b-1658566004 role:player playerID:9fa52401 playerID:9fa52417
08:46:49.364199 整合性チェックを終了します
08:46:49.364209 整合性チェックに失敗しました
08:46:50.365306 ERROR[0] prepare: load-validation: GET /api/player/player/9fa52463 : expected([200]) != actual(500) tenant:vzjzh-ebl-1658566004 role:player playerID:9fa52408 playerID:9fa52463
08:46:50.365326 ERROR[1] prepare: load-validation: GET /api/player/player/9fa52417 : expected([200]) != actual(500) tenant:ffazs-b-1658566004 role:player playerID:9fa52401 playerID:9fa52417
08:46:50.365504 Error 2 (Critical:0)

振り返り

- DB チューニングでもっと詰められたはず

  - SQLite ハマりすぎた
  - ライブラリの仕様わかっていなかったり
  - in-memory への載せ替え方法わからなすぎた

- 複数台構成にしたかったけどやり方わからなすぎた

- モニタリングからもっと手がかりを得たかった

  - CPU/Mem/Disk のどこで詰まっているか
  - アクセスログの良い見方
  - API 単位でどの処理が遅いのかあたりを付けれたらよかった

- UI でもう少し遊んでてもよかったかも

- ローカルで動くと良かったのかな
- live share まあまあできたけどちょっと苦しかった

  - ターミナル崩壊が厳しかった

  - git への移行、デプロイフローの整備で午前中使ってしまった

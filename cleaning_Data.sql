#Creating Table
create table player_char(
ID MEDIUMINT UNSIGNED DEFAULT 0,
short_name VARCHAR(40),
overall TINYINT UNSIGNED,
potential TINYINT UNSIGNED,
age TINYINT UNSIGNED,
international_reputation TINYINT UNSIGNED);

create table positions(
ID MEDIUMINT UNSIGNED DEFAULT 0,
club_name VARCHAR(40),
league_name VARCHAR(40),
club_position VARCHAR(5),
nationality_name VARCHAR(40),
nation_position VARCHAR(5),
player_position VARCHAR(3));

create table cost(
ID MEDIUMINT UNSIGNED DEFAULT 0,
Price BIGINT UNSIGNED DEFAULT 0,
Wage INT UNSIGNED DEFAULT 0);

#Retrieve Data From Kaggle
LOAD DATA INFILE 'player_char.csv'
INTO TABLE player_char
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
LOAD DATA INFILE 'positions.csv'
INTO TABLE positions
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
LOAD DATA INFILE 'cost.csv'
INTO TABLE cost
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

#Trimming in player_position column
update positions set player_position = TRIM(player_position);

#Change 'SUB','RES' and empty value in club_position column with value from player_position column
update positions set club_position = player_position where club_position = 'SUB';
update positions set club_position = player_position where club_position = 'RES';
update positions set club_position = player_position where club_position = '';

#Membuat kolom baru untuk klasifikasi role pemain berdasarkan posisi
#Catatan untuk role pemain 
#GK
#Defense (CB, LB, RB, RCB, LCB, RWB, LWB)
#Mid (CM,CDM,RM,LM,CAM,LCM,RCM,RDM,LDM,LAM,RAM) 
#Attack ( ST, RW, LW, RS, LS, CF, LF, RF)

update positions set role = 'GK' WHERE club_position = 'GK';
update positions set role = 'Defense' WHERE club_position IN ('CB','LB','RB','RCB','LCB','RWB','LWB');
update positions set role = 'Mid' WHERE club_position IN ('CM','CDM','RM','LM','CAM','LCM','RCM','RDM','LDM','LAM','RAM');
update positions set role = 'Attack' WHERE club_position IN ('ST','RW','LW','RS','LS','CF','LF','RF');

#drop kolom nation_position dan player_position dari tabel positions
alter table positions
    -> drop column nation_position,
    -> drop column player_position;

#ganti judul kolom pada tabel positions
alter table positions change club_position player_position VARCHAR(3);

Create DATABASE bank;

use bank;

set global local_infile =1;
# --------------------------------------------------------
drop table if exists account;

create table account (
  accountId int PRIMARY KEY,
  districtId int,
  foreign key (districtId)
      references district(districtId),
  frequency varchar(20),
  date date
);

load data local infile 'C:\\Users\\DH\\Documents\\School\\WeDataCloud\\data science\\midterm\\bank_loan\\account.asc'
into table account
    CHARACTER SET 'utf8'
    fields terminated by ';' ENCLOSED BY '"'
    lines terminated by '\n' IGNORE 1 LINES
    (accountId,districtId,frequency,@date)
    set date = str_to_date(@date,'%y%m%d')
;

select count(*) from account; #4500

select max(date) from account;

# truncate table account;

# --------------------------------------------------------
drop table if exists client;

create table client (
  clientId int primary key,
  gender varchar(20),
  birthdate date,
  districtId int,
  foreign key (districtId)
      references district(districtId)
);

load data local infile 'C:\\Users\\DH\\Documents\\School\\WeDataCloud\\data science\\midterm\\bank_loan\\client.asc'
into table client
    CHARACTER SET 'utf8'
    fields terminated by ';' ENCLOSED BY '"'
    lines terminated by '\n' IGNORE 1 LINES
    (clientid,@birthdate,districtId)
    set birthdate =
            IF(cast(substring(@birthdate, 3, 2) as UNSIGNED )> 12,
                str_to_date(CONCAT('19',substring(@birthdate, 1, 2),
                    lpad(cast((cast(substring(@birthdate, 3, 2) as UNSIGNED ) - 50) as CHAR),2,0 ),
                    substring(@birthdate, 5, 2)), '%Y%m%d'),
                str_to_date(concat('19',@birthdate), '%Y%m%d')),
        gender = IF(cast(substring(@birthdate, 3, 2) as UNSIGNED )> 12,
            'Female', 'Male')
;

select count(*) from client; #5369

select max(birthdate) from client;

# truncate table client;


# --------------------------------------------------------
drop table if exists disposition;

create table disposition (
  dispId int primary key,
  clientId int,
  accountId int,
  type varchar(20),
  foreign key (clientId) references client(clientId),
  foreign key (accountId) references account(accountId)
);

load data local infile 'C:\\Users\\DH\\Documents\\School\\WeDataCloud\\data science\\midterm\\bank_loan\\disp.asc'
into table disposition
    CHARACTER SET 'utf8'
    fields terminated by ';' ENCLOSED BY '"'
    lines terminated by '\r\n' IGNORE 1 LINES
;

select count(*) from disposition; #5369

# truncate table disposition;

# --------------------------------------------------------
drop table if exists orders;

create table orders (
  orderId int primary key,
  accountId int,
  bankTo varchar(10),
  accountTo int,
  amount decimal,
  kSymbol varchar(20),
  foreign key (accountId) references account(accountId)
);

load data local infile 'C:\\Users\\DH\\Documents\\School\\WeDataCloud\\data science\\midterm\\bank_loan\\order.asc'
into table orders
    CHARACTER SET 'utf8'
    fields terminated by ';' ENCLOSED BY '"'
    lines terminated by '\r\n' IGNORE 1 LINES
;

select count(*) from orders; #6471

# truncate table orders;

# --------------------------------------------------------
drop table if exists trans;

create table trans (
  transId int primary key,
  accountId int,
  date date,
  type varchar(20),
  operation varchar(20),
  amount decimal,
  balance decimal,
  kSymbol varchar(20),
  bankTo varchar(10),
  accountTo int,
  foreign key (accountId) references account(accountId)
);

load data local infile 'C:\\Users\\DH\\Documents\\School\\WeDataCloud\\data science\\midterm\\bank_loan\\trans.asc'
into table trans
    CHARACTER SET 'utf8'
    fields terminated by ';' ENCLOSED BY '"'
    lines terminated by '\r\n' IGNORE 1 LINES
;

select count(*) from trans; #1,056,320

select max(date) from trans;

# truncate table trans;


# --------------------------------------------------------
drop table if exists loan;

create table loan (
  loanId int primary key ,
  accountId int,
  date date,
  amount decimal,
  duration int,
  payments decimal,
  status varchar(2),
  foreign key (accountId) references account(accountId)
);

load data local infile 'C:\\Users\\DH\\Documents\\School\\WeDataCloud\\data science\\midterm\\bank_loan\\loan.asc'
into table loan
    CHARACTER SET 'utf8'
    fields terminated by ';' ENCLOSED BY '"'
    lines terminated by '\r\n' IGNORE 1 LINES
;

select count(*) from loan; #682

# truncate table loan;

# --------------------------------------------------------
drop table if exists card;

create table card (
  cardId int primary key ,
  dispId int,
  type varchar(10),
  issued date,
  foreign key (dispId) references disposition(dispId)
);

load data local infile 'C:\\Users\\DH\\Documents\\School\\WeDataCloud\\data science\\midterm\\bank_loan\\card.asc'
into table card
    CHARACTER SET 'utf8'
    fields terminated by ';' ENCLOSED BY '"'
    lines terminated by '\r\n' IGNORE 1 LINES
    (cardId,dispId,type,@date)
    set issued = str_to_date(@date,'%y%m%d')
;

select count(*) from card; #892

# truncate table card;

select max(issued) from card;


# --------------------------------------------------------
drop table if exists district;

create table district (
  districtId int PRIMARY KEY,
  name varchar(20),
  region varchar(20),
  inhabitants int,
  municipalities int,
  municipalities500 int,
  municipalities2k int,
  municipalities10k int,
  cities int,
  urbanRatio decimal,
  avgSalary int,
  unemploymentRate95 decimal,
  unemploymentRate96 decimal,
  entrepreneurP1k int,
  crimes95 int,
  crimes96 int
);

load data local infile 'C:\\Users\\DH\\Documents\\School\\WeDataCloud\\data science\\midterm\\bank_loan\\district.asc'
into table district
    CHARACTER SET 'utf8'
    fields terminated by ';' ENCLOSED BY '"'
    lines terminated by '\r\n' IGNORE 1 LINES
;

select count(*) from district; #77

# truncate table district;
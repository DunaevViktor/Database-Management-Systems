CREATE TABLE Expense
(
	id_exp		  CHAR(18)  NOT NULL ,
	id_type		  CHAR(18)  NOT NULL ,
	id_prType	  CHAR(18)  NOT NULL 
);

COMMIT;

INSERT INTO Expense VALUES
	('01', 'Buy', 'Eeat');
INSERT INTO Expense VALUES
	('02', 'Pay', 'Credit');
INSERT INTO Expense VALUES
	('03', 'Buy', 'GameSteam');

COMMIT;


CREATE UNIQUE INDEX XPKExpense ON Expense
(id_exp  ASC,id_type  ASC,id_prType  ASC);

ALTER TABLE Expense
	ADD CONSTRAINT  XPKExpense PRIMARY KEY (id_exp,id_type,id_prType);



CREATE TABLE Income
(
	id_income	  CHAR(18)  NOT NULL ,
	id_type		  CHAR(18)  NOT NULL ,
	id_prType	  CHAR(18)  NOT NULL 
);

INSERT INTO Income VALUES
	('01', 'Zarplata', 'Oklad');
INSERT INTO Income VALUES
	('02', 'Zarplata', 'Preniya');
INSERT INTO Income VALUES
	('03', 'Loto', 'SuperLoto');

COMMIT;


CREATE UNIQUE INDEX XPKIncome ON Income
(id_income  ASC,id_type  ASC,id_prType  ASC);

ALTER TABLE Income
	ADD CONSTRAINT  XPKIncome PRIMARY KEY (id_income,id_type,id_prType);



CREATE TABLE Member
(
	id_mem		  CHAR(18)  NOT NULL 
);

INSERT INTO Member VALUES
	('Mum');
INSERT INTO Member VALUES
	('Dad');
INSERT INTO Member VALUES
	('Bitch Lasaniya');

COMMIT;


CREATE UNIQUE INDEX XPKMember ON Member
(id_mem  ASC);

ALTER TABLE Member
	ADD CONSTRAINT  XPKMember PRIMARY KEY (id_mem);



CREATE TABLE Operation
(
	id_operation	  CHAR(18)  NOT NULL ,
	id_income	  CHAR(18)  NOT NULL ,
	id_exp		  CHAR(18)  NOT NULL ,
	id_mem		  CHAR(18)  NOT NULL ,
	id_type		  CHAR(18)  NOT NULL ,
	id_prType	  CHAR(18)  NOT NULL ,
	date_op		  CHAR(18)  NOT NULL ,
	description	  CHAR(18)  NOT NULL ,
	currency	  CHAR(18)  DEFAULT 'BYN',
	summ		  NUMBER(18)  NOT NULL CHECK (summ > 0),
	cash		  CHAR(18)  NOT NULL 
);

INSERT INTO Operation VALUES
	('id 1', 'id inc', 'id exp', 'mum', 'id typ', 'id prt', '23 Jan', 'buy all games', 'USD', 5, 'cash -3');

COMMIT;


CREATE UNIQUE INDEX XPKOperation ON Operation
(id_operation  ASC,id_mem  ASC);

ALTER TABLE Operation
	ADD CONSTRAINT  XPKOperation PRIMARY KEY (id_operation,id_mem);



CREATE TABLE Property_Type
(
	prType_name	  CHAR(18)  NOT NULL ,
	id_type		  CHAR(18)  NOT NULL ,
	id_prType	  CHAR(18)  NOT NULL 
);

INSERT INTO Property_Type VALUES
	('prName', 'id 01', 'id pr type');


CREATE UNIQUE INDEX XPKProperty_Type ON Property_Type
(id_type  ASC,id_prType  ASC);

ALTER TABLE Property_Type
	ADD CONSTRAINT  XPKProperty_Type PRIMARY KEY (id_type,id_prType);



CREATE TABLE Type
(
	type_name	  CHAR(18)  NOT NULL ,
	id_type		  CHAR(18)  NOT NULL 
);

INSERT INTO Type VALUES
	('type name 1', 'id 1');

COMMIT;

CREATE UNIQUE INDEX XPKType ON Type
(id_type  ASC);

ALTER TABLE Type
	ADD CONSTRAINT  XPKType PRIMARY KEY (id_type);

ALTER TABLE Expense
	ADD (CONSTRAINT  R_35 FOREIGN KEY (id_type,id_prType) REFERENCES Property_Type(id_type,id_prType));

ALTER TABLE Income
	ADD (CONSTRAINT  R_32 FOREIGN KEY (id_type,id_prType) REFERENCES Property_Type(id_type,id_prType));

ALTER TABLE Operation
	ADD (CONSTRAINT  R_30 FOREIGN KEY (id_income,id_type,id_prType) REFERENCES Income(id_income,id_type,id_prType));

ALTER TABLE Operation
	ADD (CONSTRAINT  R_31 FOREIGN KEY (id_exp,id_type,id_prType) REFERENCES Expense(id_exp,id_type,id_prType));

ALTER TABLE Operation
	ADD (CONSTRAINT  R_44 FOREIGN KEY (id_mem) REFERENCES Member(id_mem));

ALTER TABLE Property_Type
	ADD (CONSTRAINT  R_27 FOREIGN KEY (id_type) REFERENCES Type(id_type));

COMMIT;
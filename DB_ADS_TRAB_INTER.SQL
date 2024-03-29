--DROP DATABASE DB_ADS_TRAB_INTER;
CREATE DATABASE DB_ADS_TRAB_INTER;
CREATE TABLE TB_ADS_EMPS(
	COD_EMPS SMALLINT PRIMARY KEY IDENTITY,
    NOM_EMPS VARCHAR(50) NOT NULL
);

CREATE TABLE TB_ADS_CID(
	COD_CID INT PRIMARY KEY IDENTITY,
    NOM_CID VARCHAR(50) NOT NULL
);


CREATE TABLE TB_ADS_BAIRRO(
	COD_BAIRRO INT PRIMARY KEY IDENTITY,
	COD_CID INT NOT NULL,
    NOM_BAIRRO VARCHAR(50) NOT NULL,
	CONSTRAINT FK_BAIRRO_CID
		FOREIGN KEY (COD_CID)
			REFERENCES TB_ADS_CID(COD_CID)
);

CREATE TABLE TB_ADS_RUA(
	COD_RUA INT PRIMARY KEY IDENTITY,
	COD_BAIRRO INT NOT NULL,
    NOM_RUA VARCHAR(50) NOT NULL,
	CONSTRAINT FK_RUA_BAIRRO
		FOREIGN KEY (COD_BAIRRO)
			REFERENCES TB_ADS_BAIRRO(COD_BAIRRO)
);

CREATE TABLE TB_ADS_LOC(
    COD_CEP CHAR(8) PRIMARY KEY,
    COD_RUA INT NOT NULL,
	NUM INT NOT NULL,
    CONSTRAINT FK_LOC_RUA
    	FOREIGN KEY (COD_RUA)
    		REFERENCES TB_ADS_RUA(COD_RUA)
);

CREATE TABLE TB_ADS_LOTE(
	COD_LOTE INT PRIMARY KEY IDENTITY,
    COD_EMPS SMALLINT NOT NULL,
    QTD_VAC INT NOT NULL,
    CONSTRAINT FK_LOTE_EMPS
    	FOREIGN KEY (COD_EMPS)
    		REFERENCES TB_ADS_EMPS(COD_EMPS)
);

CREATE TABLE TB_ADS_USER(
	COD_CPF CHAR(11) PRIMARY KEY,
    COD_RG CHAR(9) UNIQUE NOT NULL,
    NOM_USER VARCHAR(50) NOT NULL,
    IDADE SMALLINT NOT NULL,
    COD_CID INT NOT NULL,
	IND_FUNC CHAR(1),
	CONSTRAINT CK_FUNC_USER CHECK(IND_FUNC IN ('S','N')),
	CONSTRAINT FK_USER_CID
		FOREIGN KEY (COD_CID)
			REFERENCES TB_ADS_CID(COD_CID)
);

CREATE TABLE TB_ADS_CRM(
	COD_CRM CHAR(6) PRIMARY KEY,
	COD_CPF CHAR(11) NOT NULL,
	CONSTRAINT FK_CRM_CPF
    	FOREIGN KEY (COD_CPF)
    		REFERENCES TB_ADS_USER(COD_CPF)
);

CREATE TABLE TB_ADS_AGDM(
	COD_AGDM BIGINT PRIMARY KEY IDENTITY,
    COD_CPF_USER CHAR(11) NOT NULL,
    COD_CPF_VOL CHAR(11) NOT NULL,
    COD_CEP CHAR(8) NOT NULL,
	COD_LOTE INT NOT NULL,
    DAT_AGDM DATETIME NOT NULL,
    TXT_EXT VARCHAR(200),
    CONSTRAINT FK_AGDM_CPF_USER
    	FOREIGN KEY (COD_CPF_USER)
    		REFERENCES TB_ADS_USER(COD_CPF),
    CONSTRAINT FK_AGDM_CPF_VOL
    	FOREIGN KEY (COD_CPF_VOL)
    		REFERENCES TB_ADS_USER(COD_CPF),
    CONSTRAINT FK_AGDM_LOTE
    	FOREIGN KEY (COD_LOTE)
    		REFERENCES TB_ADS_LOTE(COD_LOTE),
	CONSTRAINT FK_AGDM_CEP
    	FOREIGN KEY (COD_CEP)
    		REFERENCES TB_ADS_LOC(COD_CEP)
);
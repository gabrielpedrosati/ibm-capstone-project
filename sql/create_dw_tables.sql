CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE staging."DimDate"
(
    iddate bigint NOT NULL,
    date date NOT NULL,
    year integer NOT NULL,
    quarter integer NOT NULL,
    quartername char(2) NOT NULL,
    month integer NOT NULL,
    monthname varchar(20) NOT NULL,
    day integer NOT NULL,
    weekday integer NOT NULL,
    weekdayname varchar(20) NOT NULL,
    PRIMARY KEY (iddate)
);

CREATE TABLE staging."DimCategory"
(
    idcategory integer NOT NULL,
    categoryname varchar(20) NOT NULL,
    PRIMARY KEY (idcategory)
);

CREATE TABLE staging."DimItem"
(
    iditem integer NOT NULL,
    itemname varchar(255) NOT NULL,
    price decimal(10,2) NOT NULL,
    PRIMARY KEY (iditem)
);

CREATE TABLE staging."DimCountry"
(
    idcountry integer NOT NULL,
    country varchar(100) NOT NULL,
    PRIMARY KEY (idcountry)
);

CREATE TABLE staging."FactSales"
(
    idsales bigint NOT NULL,
    iddate integer NOT NULL,
    iditem integer NOT NULL,
    idcategory integer NOT NULL,
    idcountry integer NOT NULL,
    PRIMARY KEY (idsales)
);

ALTER TABLE staging."FactSales"
    ADD FOREIGN KEY (iddate)
    REFERENCES staging."DimDate" (iddate);


ALTER TABLE staging."FactSales"
    ADD FOREIGN KEY (iditem)
    REFERENCES staging."DimItem" (iditem);


ALTER TABLE staging."FactSales"
    ADD FOREIGN KEY (idcategory)
    REFERENCES staging."DimCategory" (idcategory);


ALTER TABLE staging."FactSales"
    ADD FOREIGN KEY (idcountry)
    REFERENCES staging."DimCountry" (idcountry);
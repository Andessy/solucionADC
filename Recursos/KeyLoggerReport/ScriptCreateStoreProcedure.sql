DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `TiemposMuertos`()
BEGIN

	drop temporary table ADC.grupoKey1;
	drop temporary table ADC.grupoKey2;
	drop table ADC.IddleTimes;
    
	CREATE TEMPORARY TABLE ADC.grupoKey1(id MEDIUMINT NOT NULL AUTO_INCREMENT, 
    username VARCHAR(30) NOT NULL, 
    idactivity int, 
    activity varchar(30),
    datekey VARCHAR(20), 
    startdate varchar (20) not null,
    enddate varchar(20) not null,
    cantidad int,
    PRIMARY KEY (id));
    
    INSERT INTO ADC.grupoKey1 (username, idactivity, activity, datekey, startdate, enddate, cantidad )
    SELECT username, idactivity, activity, datekeyInt, StartDateTime, EndDateTime, count(*) FROM ADC.DataIddleTime
	group by username, idactivity, activity, datekey 
    order by username, datekeyInt;
    
    CREATE temporary table ADC.grupoKey2 
    select * from ADC.grupoKey1;
    
    CREATE TABLE ADC.IddleTimes(
    Username VARCHAR(30) NOT NULL, 
    Activity varchar(30),
    Iddletime int,
    StartDate varchar (20) not null,
    EndDate varchar(20) not null);
    
	INSERT INTO ADC.IddleTimes (Username, Activity,Iddletime, StartDate,EndDate)
    select d.username, d.activity, timestampdiff(MINUTE, STR_TO_DATE(g.datekey,'%Y%m%d%H%i') , STR_TO_DATE(d.datekey,'%Y%m%d%H%i')) , d.startdate, d.enddate
    from ADC.grupoKey1 d
    left outer join ADC.grupoKey2 g 
    on d.id =g.id+1 and d.username = g.username;
END$$
DELIMITER ;

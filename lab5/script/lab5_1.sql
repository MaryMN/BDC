--Completati urmatorul cod pentru a afi~a eel mai mare numar dintre cele trei numere prezentate: 

DECLARE @N1 INT, @N2 INT, @N3 INT;
DECLARE @MAI_MARE INT;
SET @N1 = 60 * RAND();
SET @N2 = 60 * RAND();
SET @N3 = 60 * RAND();

IF @N1>@N2 SET @MAI_MARE=@N1
ELSE SET @MAI_MARE=@N2
IF @N2>@N3 SET @MAI_MARE=@N2
ELSE SET @MAI_MARE=@N3
IF @N3>@N1 SET @MAI_MARE=@N3
ELSE SET @MAI_MARE=@N1
PRINT @N1;
PRINT @N2;
PRINT @N3;
PRINT 'Mai mare = ' + CAST(@MAI_MARE AS VARCHAR(2)); 


 
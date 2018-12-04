--Completati urmatorul cod pentru a afisa cel mai mare numar dintre cele trei numere prezentate,  
--apeland la structura selectiva CASE. : 
DECLARE @N1 INT, @N2 INT, @N3 INT;
DECLARE @MAI_MARE INT;
SET @N1 = 60 * RAND();
SET @N2 = 60 * RAND();
SET @N3 = 60 * RAND();
SET @MAI_MARE = CASE 
WHEN @N1>@N2 and @N1>@N3 THEN @N1
WHEN @N2>@N3 and @N2>@N1 THEN @N2
WHEN @N3>@N1 and @N3>@N1 THEN @N3
END
PRINT @N1;
PRINT @N2;
PRINT @N3;
PRINT 'Mai mare = ' + CAST(@MAI_MARE AS VARCHAR(2)); 
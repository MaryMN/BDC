# lab11


_**1.Sa se creeze un dosar Backup_labll. Sa se execute un backup complet al bazei de date universitatea in acest dosar. 
Fisierul copiei de rezerva sa se numeasca exercitiull.bak. Sa se scrie instructiunea SQL respectiva.**_

```SQL
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='backup1')
EXEC sp_dropdevice 'backup1' , 'delfile';
GO
EXEC sp_addumpdevice 'DISK', 'backup1', 'D:\mysqp\MSSQL14.MSSQLSERVER\MSSQL\DATA\Backup_lab11\exercitiul1.bkp'
GO
BACKUP DATABASE universitatea
TO DISK = 'D:\mysqp\MSSQL14.MSSQLSERVER\MSSQL\DATA\Backup_lab11\exercitiul1.bkp'
WITH FORMAT,
NAME = 'universitatea - Full DB backup'
GO
```
![Images](https://github.com/MaryMN/BDC/blob/master/lab11/images/1.PNG)


_**2.Sa se scrie instructiunea unui backup diferentiat al bazei de date universitatea. Fisierul copiei de rezerva sa se numeasca 
exercitiul2.bak.**_

```SQL
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='backup2')
EXEC sp_dropdevice 'backup2' , 'delfile';
GO
EXEC sp_addumpdevice 'DISK', 'backup2', 'D:\mysqp\MSSQL14.MSSQLSERVER\MSSQL\DATA\Backup_lab11\exercitiul2.bkp'
GO
BACKUP DATABASE universitatea
TO DISK = 'D:\mysqp\MSSQL14.MSSQLSERVER\MSSQL\DATA\Backup_lab11\exercitiul2.bkp'
WITH FORMAT,
NAME = 'universitatea - Differential DB backup'
GO
```
![Images](https://github.com/MaryMN/BDC/blob/master/lab11/images/2.PNG)

_**3.Sa se scrie instructiunea unui backup al jurnalului de tranzactii al bazei de date universitatea. Fisierul copiei de rezerva 
sa se numeasca exercitiul3.bak**_

```SQL
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='backup3')
EXEC sp_dropdevice 'backup3' , 'delfile';
GO
EXEC sp_addumpdevice 'DISK', 'backup3', 'D:\mysqp\MSSQL14.MSSQLSERVER\MSSQL\DATA\Backup_lab11\exercitiul3.bkp'
GO
BACKUP LOG universitatea
TO DISK = 'D:\mysqp\MSSQL14.MSSQLSERVER\MSSQL\DATA\Backup_lab11\exercitiu3.bkp'
WITH FORMAT,
NAME = 'universitatea - Full DB backup'
GO
```
![Images](https://github.com/MaryMN/BDC/blob/master/lab11/images/3.PNG)


_**4. Sa se execute restaurarea consecutiva a tuturor copiilor de rezerva create. Recuperarea trebuie sa fie realizata intr-o baza de 
date noua universitatea_labll. Fisierele bazei de date noi se afla in dosarul BD_labll. Sa se scrie instructiunile SQL respective**_

```SQL
IF EXISTS (SELECT * FROM master.sys.databases WHERE name='universitatea_lab11')
DROP DATABASE universitatea_lab11;
GO
RESTORE DATABASE universitatea_lab11
FROM DISK = 'D:\mysqp\MSSQL14.MSSQLSERVER\MSSQL\DATA\Backup_lab11\exercitiul1.bkp'
WITH MOVE 'universitatea' TO 'D:\mysqp\MSSQL14.MSSQLSERVER\MSSQL\DATA\data.mdf',
MOVE 'universitatea_log' TO 'D:\mysqp\MSSQL14.MSSQLSERVER\MSSQL\DATA\log.ldf',
NORECOVERY
GO
RESTORE LOG universitatea_lab11
FROM DISK = 'D:\mysqp\MSSQL14.MSSQLSERVER\MSSQL\DATA\Backup_lab11\exercitiul3.bkp'
WITH NORECOVERY
GO
RESTORE DATABASE universitatea_lab11
FROM DISK = 'D:\mysqp\MSSQL14.MSSQLSERVER\MSSQL\DATA\Backup_lab11\exercitiul2.bkp'
WITH NORECOVERY
GO
```

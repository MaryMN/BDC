
# Laboratory work nr.7


###Diagrame, Scheme si Sinonime

####Sarcini practice:

_**1.Creați o diagramă a bazei de date, folosind forma de vizualizare standard, 
structura căreia este descrisă la începutul sarcinilor practice din capitolul 4.**_

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/1.PNG)


_**2.Să se adauge constrîngeri referențiale (legate cu tabelele studenti și profesori) necesare coloanelor Sef_grupa și 
Prof_Indrumator (sarcina3, capitolul 6) din tabelul grupe.**_

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/2.PNG)

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/2.1.PNG)

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/2.2.PNG)

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/2.3.PNG)

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/2.4.PNG)



_**3.La diagrama construită, să se adauge și tabelul orarul definit în capitolul 6 al acestei lucrari:tabelul orarul conține 
identificatorul disciplinei (ld_Disciplina), identificatorul profesorului(Id_Profesor) și blocul de studii (Bloc). 
Cheia tabelului este constituită din trei cîmpuri:identificatorul grupei (Id_ Grupa), ziua lectiei (Z1), ora de inceput a 
lectiei (Ora), sala unde are loc lectia (Auditoriu)**_



``` 
CREATE TABLE orarul( Id_Disciplina int NOT NULL,
                       Id_Profesor int NOT NULL, 
					   Id_Grupa smallint NOT NULL,
					   Zi       char(2) NOT NULL,
					   Ora       Time NOT NULL,
					   Auditoriu  int NOT NULL,
					   Bloc       char(1) NOT NULL DEFAULT ('B'),
CONSTRAINT [PK_orarul] PRIMARY KEY CLUSTERED (	Id_Grupa,Zi,Ora,Auditoriu, Id_Disciplina, Id_Profesor )) ON [PRIMARY]

INSERT orarul VALUES(107, 101, (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='CIB171'), 'Lu', '08:00', 202,DEFAULT)
INSERT orarul VALUES(108, 101, (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='CIB171'), 'Lu', '11:30', 501,DEFAULT)
INSERT orarul VALUES(109, 117, (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='CIB171'), 'Lu', '13:00', 501,DEFAULT)   

INSERT INTO orarul (Id_Disciplina,Id_Profesor,Id_Grupa,Zi,Ora,Auditoriu,Bloc) 
VALUES ((SELECT Id_Disciplina FROM discipline WHERE Disciplina='Structuri de date si algoritmi'),
        (SELECT Id_Profesor FROM profesori WHERE Nume_Profesor='Bivol' and Prenume_Profesor='Ion' ),
        (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='INF171'),'Lu','08:00',101,DEFAULT)
    
INSERT INTO orarul (Id_Disciplina,Id_Profesor,Id_Grupa,Zi,Ora,Auditoriu,Bloc) 
VALUES ((SELECT Id_Disciplina FROM discipline WHERE Disciplina='Programe aplicative'),
        (SELECT Id_Profesor FROM profesori WHERE Nume_Profesor='Mircea' and Prenume_Profesor='Sorin' ),
        (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='INF171'),'Lu','11:30',103,DEFAULT)

INSERT INTO orarul (Id_Disciplina,Id_Profesor,Id_Grupa,Zi,Ora,Auditoriu,Bloc) 
VALUES ((SELECT Id_Disciplina FROM discipline WHERE Disciplina='Baze de date'),
        (SELECT Id_Profesor FROM profesori WHERE Nume_Profesor='Micu' and Prenume_Profesor='Elena' ),
        (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='INF171'),'Lu','13:00',104,DEFAULT);
```
        
   ![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/3.PNG)
        
  ![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/3.1.PNG)
        

_**4.Tabelul orarul trebuie să conțină și 2 chei secundare: (Zi, Ora, Id_ Grupa, Id_ Profesor) și (Zi, Ora, ld_Grupa, ld_Disciplina).**_

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/4.PNG)

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/4.1.PNG)


_**5.În diagrama, de asemenea, trebuie sa se defineasca constrangerile referentiale (FK-PK) ale atributelor ld_Disciplina, 
ld_Profesor, Id_ Grupa din tabelului orarul cu atributele tabelelor respective.**_

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/5.PNG)

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/5PNG.PNG)

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/5.1.PNG)

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/5.2.PNG)

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/5.3.PNG)


**_6.Creați, în baza de date universitatea, trei scheme noi: cadre_didactice, plan_studii și studenti. Transferați tabelul 
profesori din schema dbo in schema cadre didactice, ținînd cont de dependentele definite asupra tabelului menționat. 
În același mod să se trateze tabelele orarul,discipline care aparțin schemei plan_studii și tabelele studenți, studenti_reusita, 
care apartin schemei studenti. Se scrie instructiunile SQL respective._**
```
    GO
CREATE SCHEMA cadre_didactice
GO
ALTER SCHEMA cadre_didactice TRANSFER dbo.profesori

GO
CREATE SCHEMA plan_studii
GO
ALTER SCHEMA plan_studii TRANSFER dbo.orarul
ALTER SCHEMA plan_studii TRANSFER dbo.discipline

GO
CREATE SCHEMA studenti
GO
ALTER SCHEMA studenti TRANSFER dbo.studenti
ALTER SCHEMA studenti TRANSFER dbo.studenti_reusita    
```


![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/6.PNG)



_**7.Modificati 2-3 interogari asupra bazei de date universitatea prezentate in capitolul 4 astfel ca numele tabelelor accesate 
sa fie descrise in mod explicit, ținînd cont de faptul ca tabelele au fost mutate in scheme noi.**_

```
--8. Obtineti identificatorii si numele studentilor, ale examenelor sustinute in anul 2018.
Select distinct studenti.studenti.Id_Student, studenti.studenti.Nume_Student
FROM studenti.studenti INNER JOIN studenti.studenti_reusita ON studenti.studenti.Id_Student=studenti.studenti_reusita.Id_Student
Where year(studenti.studenti_reusita.Data_Evaluare)=2018
```
![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/7.PNG)
```
--14. Aflati numele si prenumele studentilor, precum si cursurile promovate cu note mai mari de 8 la examen. 
Select distinct studenti.Nume_Student, studenti.Prenume_Student, plan_studii.discipline.Disciplina, studenti.studenti_reusita.Nota
FROM studenti.studenti 
INNER JOIN studenti.studenti_reusita ON studenti.studenti.Id_Student=studenti.studenti.Id_Student
INNER JOIN plan_studii.discipline ON studenti.studenti_reusita.Id_Disciplina=plan_studii.discipline.Id_Disciplina
Where studenti.studenti_reusita.Nota>8
```
![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/7.1.PNG)
```
--35. Gasiti denumirile disciplinelor ~i media notelor pe disciplina. Afi;ati numai disciplinele cu medii mai mari de 7.0. 
SELECT plan_studii.discipline.Disciplina, AVG(cast(studenti.studenti_reusita.Nota as float)) Media_Notelor 
FROM plan_studii.discipline
	INNER JOIN studenti.studenti_reusita on studenti.studenti_reusita.Id_Disciplina = plan_studii.discipline.Id_Disciplina
GROUP BY plan_studii.discipline.Disciplina
HAVING AVG(cast(studenti.studenti_reusita.Nota as float)) > 7
```
![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/7.2.PNG)



_**8.Creați sinonimele respective pentru a simplifica interogările construite în exercițiul precedent și reformulați interogările, 
folosind sinonimele create.**_
``` 
GO
CREATE SYNONYM student FOR studenti.studenti
GO
CREATE SYNONYM reusita FOR studenti.studenti_reusita
GO
CREATE SYNONYM disciplina FOR plan_studii.discipline
```

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/8.PNG)

```
--8. Obtineti identificatorii si numele studentilor, ale examenelor sustinute in anul 2018.
Select distinct student.Id_Student, student.Nume_Student
FROM student INNER JOIN reusita ON student.Id_Student=reusita.Id_Student
Where year(reusita.Data_Evaluare)=2018
```

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/8.1.PNG)

```
--14. Aflati numele si prenumele studentilor, precum si cursurile promovate cu note mai mari de 8 la examen. 
Select distinct student.Nume_Student, student.Prenume_Student, disciplina.Disciplina, reusita.Nota
FROM student 
INNER JOIN reusita ON student.Id_Student=reusita.Id_Student
INNER JOIN disciplina ON reusita.Id_Disciplina=disciplina.Id_Disciplina
Where reusita.Nota>8
```
![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/8.2.PNG)
```
--35. Gasiti denumirile disciplinelor ~i media notelor pe disciplina. Afi;ati numai disciplinele cu medii mai mari de 7.0. 
SELECT disciplina.Disciplina, AVG(cast(reusita.Nota as float)) Media_Notelor 
FROM disciplina
	INNER JOIN reusita on reusita.Id_Disciplina = disciplina.Id_Disciplina
GROUP BY disciplina.Disciplina
HAVING AVG(cast(reusita.Nota as float)) > 7 
```
![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab7/images/8.3.PNG)

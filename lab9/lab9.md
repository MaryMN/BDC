# lab9

_**1.Sa se creeze proceduri stocate in baza exercitiilor (2 exercitii) din capitolul 4. Parametrii de
intrare trebuie sa corespunda criteriilor din clauzele WHERE ale exercitiilor respective .**_
*--4.14. Aflati numele si prenumele studentilor, precum si cursurile promovate cu note mai mari de 8 la examen.*

```SQL
Create procedure ex4_8
@Mark tinyint =8
 AS
 Select studenti.Nume_Student, studenti.Prenume_Student, plan_studii.discipline.Disciplina, studenti.studenti_reusita.Nota as Mark
FROM studenti.studenti 
INNER JOIN studenti.studenti_reusita ON studenti.studenti.Id_Student=studenti.studenti.Id_Student
INNER JOIN plan_studii.discipline ON studenti.studenti_reusita.Id_Disciplina=plan_studii.discipline.Id_Disciplina
Where studenti.studenti_reusita.Nota>@Mark

select*
from ex4_8
```
![Git](https://github.com/MaryMN/BDC/blob/master/lab9/images/1.PNG)

*35. Gasiti denumirile disciplinelor ~i media notelor pe disciplina. Afi;ati numai disciplinele cu medii mai mari de 7.0.* 

```SQL
Create Procedure ex6_3
@Mark tinyint=7
AS
SELECT plan_studii.discipline.Disciplina, AVG(cast(studenti.studenti_reusita.Nota as float)) Mark_AVG
FROM plan_studii.discipline
	INNER JOIN studenti.studenti_reusita on studenti.studenti_reusita.Id_Disciplina = plan_studii.discipline.Id_Disciplina
GROUP BY plan_studii.discipline.Disciplina
HAVING AVG(cast(studenti.studenti_reusita.Nota as float)) > @Mark
```

![Git](https://github.com/MaryMN/BDC/blob/master/lab9/images/1.1.PNG)


_**2. Sa se creeze o procedura stocata, care nu are niciun parametru de intrare ~i poseda un
parametru de ie~ire. Parametrul de ie~ire trebuie sa returneze numarul de studenti, care nu au
sustinut eel putin o forma de evaluare (nota mai mica de 5 sau valoare NULL).**_

```SQL
 CREATE PROCEDURE Stocare
 @Nr_Studenti smallint =Null output
  AS
Select  @Nr_Studenti= count(distinct Id_Student)
from studenti.studenti_reusita
where Nota<5 or Nota=Null
--
Select distinct  Id_Student
from studenti.studenti_reusita
where Nota<5 or Nota =Null

 DECLARE @Nr_Studenti smallint
EXEC Stocare @Nr_Studenti  output
Print 'numarul de studenti, care nu au sustinut cel putin o forma de evaluare (nota mai mica de 5 sau valoare NULL)='
+ cast( @Nr_Studenti as varchar(3));
```

![Git](https://github.com/MaryMN/BDC/blob/master/lab9/images/21.PNG)


_**3. Sa se creeze o procedura stocata, care ar insera in baza de date informatii despre un student
nou. in calitate de parametri de intrare sa serveasca datele personale ale studentului nou ~i
Cod_ Grupa. Sa se genereze toate intrarile-cheie necesare in tabelul studenti_reusita. Notele
de evaluare sa fie inserate ca NULL.**_

```SQL
Create PROCEDURE Inserare

@Nume varchar(50),
@Prenume varchar(50),
@DataNastere date,
@Adresa varchar(500),
@cod_Grupa char(6)
 as
 
 insert into studenti.studenti
 values (1,@Nume,@Prenume,@DataNastere,@Adresa)
 go
insert into studenti.studenti_reusita

 values (1, 105, 110 , 
         (select Id_Grupa 
		  from grupe
		  where Cod_Grupa = @cod_Grupa), 'Examen', NULL, '2018-11-27')
---------
exec Insert_NEW_St  'Lastname', 'Firstname', '1998-01-01',' mun.Chisinau', 'TI171'

select * 
from studenti.studenti
select * 
from studenti.studenti_reusita
```
![Git](https://github.com/MaryMN/BDC/blob/master/lab9/images/3.PNG)

_**4. Fie ca un profesor se elibereaza din functie la mijlocul semestrului. Sa se creeze o procedura
stocata care ar reatribui inregistrarile din tabelul studenti_reusita unui alt profesor. Parametri
de intrare: numele ~i prenumele profesorului vechi, numele ~i prenumele profesorului nou,
disciplina. in cazul in care datele inserate sunt incorecte sau incomplete, sa se afi~eze un
mesaj de avertizare.**_

```SQL
CREATE PROCEDURE Schimb_Prof
@Nume_prof VARCHAR(60),
@Pren_prof VARCHAR(60),
@NumeP_nou VARCHAR(60),
@PrenP_nou VARCHAR(60),
@Disciplina VARCHAR(20),
@Error INT = NULL
AS
IF(( Select plan_studii.discipline.Id_Disciplina 
     From plan_studii.discipline 
	 Where Disciplina = @Disciplina) IN (Select distinct studenti.studenti_reusita.Id_Disciplina 
										 From studenti.studenti_reusita 
										 Where Id_Profesor = (Select cadre_didactice.profesori.Id_Profesor 
										                      From cadre_didactice.profesori 
															  Where Nume_Profesor = @Nume_prof AND Prenume_Profesor = @Pren_prof)))
UPDATE studenti.studenti_reusita
SET Id_Profesor =  (Select Id_Profesor
					From cadre_didactice.profesori
					Where Nume_Profesor = @NumeP_nou AND   Prenume_Profesor = @PrenP_nou)

WHERE Id_Profesor = (Select Id_profesor
					 FROM cadre_didactice.profesori
     			     WHERE Nume_Profesor = @Nume_prof AND Prenume_Profesor = @Pren_prof)
					 print('Profesorul: '+@Nume_Prof+' '+@Pren_Prof+' este inlocuit cu profesorul: '+
			@NumeP_nou+' '+@PrenP_nou)
					 
 SET @Error = @@ERROR
 IF @Error <>0
 BEGIN
 RAISERROR ('ERROR : The  inserted   data  is  either incorrect  or  incomplete ' ,10 ,1)
 END

 exec Schimb_Prof 
@Nume_Prof='Micu',
@Pren_Prof='Elena',
@NumeP_nou='Cotelea',
@PrenP_nou='Vitalie',
@Disciplina='Baze de date'

select * from profesori 
select * from discipline where Id_Disciplina=107
```

![Git](https://github.com/MaryMN/BDC/blob/master/lab9/images/4.1.PNG)

_**5. Sa se creeze o procedura stocata care ar forma o lista cu primii 3 cei mai buni studenti la o
disciplina, ~i acestor studenti sa le fie marita nota la examenul final cu un punct (nota
maximala posibila este 10). in calitate de parametru de intrare, va servi denumirea disciplinei.
Procedura sa returneze urmatoarele campuri: Cod_ Grupa, Nume_Prenume_Student,
Disciplina, Nota _ Veche, Nota _ Noua.**_
```SQL
CREATE PROCEDURE  ex9_5
@disciplina VARCHAR(50)

AS

DECLARE @lista_studenti TABLE (Id_Student int, Media float)
INSERT INTO @lista_studenti
	SELECT TOP (3) studenti.studenti_reusita.Id_Student, AVG(cast (Nota as float)) as Media
	FROM studenti.studenti_reusita, plan_studii.discipline
	WHERE studenti.studenti_reusita.Id_Disciplina = plan_studii.discipline.Id_Disciplina
	AND Disciplina = @disciplina
	GROUP BY studenti.studenti_reusita.Id_Student
	ORDER BY Media desc		



SELECT cod_grupa, studenti.studenti_reusita.Id_Student, CONCAT(Nume_Student, ' ', Prenume_Student) as Nume, Disciplina, nota AS Nota_Veche, iif(nota > 9, 10, nota + 1) AS Nota_Noua 

       FROM studenti.studenti_reusita, plan_studii.discipline, grupe, studenti.studenti
	WHERE studenti.studenti_reusita.id_disciplina = plan_studii.discipline.Id_Disciplina
	AND grupe.Id_Grupa = studenti.studenti_reusita.Id_Grupa
	AND  studenti.studenti_reusita.Id_Student = studenti.studenti.Id_Student
	AND studenti.studenti.Id_Student in (select Id_Student from @lista_studenti)
	AND Disciplina = @disciplina
	AND Tip_Evaluare = 'Examen'

DECLARE @id_dis SMALLINT =
(SELECT  Id_Disciplina  FROM plan_studii.discipline
WHERE   Disciplina = @disciplina)

UPDATE studenti.studenti_reusita

SET studenti.studenti_reusita.Nota = (CASE WHEN nota >= 9 THEN 10 ELSE nota + 1 END)
WHERE Tip_Evaluare = 'Examen'
AND Id_Disciplina = @id_dis
AND Id_Student in (select Id_Student from @lista_studenti)
go

execute ex9_5 @disciplina = 'Baze de Date'
```

![Git](https://github.com/MaryMN/BDC/blob/master/lab9/images/5.PNG)


_**6. Sa se creeze functii definite de utilizator in baza exercitiilor (2 exercitii) din capitolul 4.
Parametrii de intrare trebuie sa corespunda criteriilor din clauzele WHERE ale exercitiilor
respective.**_

```SQL
--4.14. Aflati numele si prenumele studentilor, precum si cursurile promovate cu note mai mari de 8 la examen. 
Create function ex6_2
(@Mark tinyint )
returns table
 AS
 return
(Select studenti.studenti.Nume_Student, studenti.studenti.Prenume_Student, plan_studii.discipline.Disciplina, studenti.studenti_reusita.Nota as Mark
FROM studenti.studenti
INNER JOIN studenti.studenti_reusita ON studenti.studenti.Id_Student=studenti.studenti.Id_Student
INNER JOIN plan_studii.discipline ON studenti.studenti_reusita.Id_Disciplina=plan_studii.discipline.Id_Disciplina
Where studenti.studenti_reusita.Nota>@Mark)

select *
from ex6_2(8)
```

![Git](https://github.com/MaryMN/BDC/blob/master/lab9/images/6_1.PNG)

```SQL
--35. Gasiti denumirile disciplinelor ~i media notelor pe disciplina. Afi;ati numai disciplinele cu medii mai mari de 7.0. 
Create function ex6_3
(@Mark tinyint)
returns table 
AS
return
(SELECT plan_studii.discipline.Disciplina, AVG(cast(studenti.studenti_reusita.Nota as float)) Mark_AVG
FROM plan_studii.discipline
	INNER JOIN studenti.studenti_reusita on studenti.studenti_reusita.Id_Disciplina = plan_studii.discipline.Id_Disciplina
GROUP BY plan_studii.discipline.Disciplina
HAVING AVG(cast(studenti.studenti_reusita.Nota as float)) > @Mark)
select *
from ex6_3(7)
```

![Git](https://github.com/MaryMN/BDC/blob/master/lab9/images/6_3.PNG)


_**7. Sa se scrie functia care ar calcula varsta studentului. Sa se defineasca urmatorul format al
functiei: <nume Juncfie>(<Data _ Nastere _Student>).Proceduri .stocate ~i /uncfii definite de utilizator**_
  
  ```SQL
  CREATE FUNCTION ex9_7 (@data_nasterii DATE )
RETURNS INT
 BEGIN
 DECLARE @varsta INT
 SELECT @varsta = (SELECT (YEAR(GETDATE()) - YEAR(@data_nasterii) - CASE 
 						WHEN (MONTH(@data_nasterii) > MONTH(GETDATE())) OR (MONTH(@data_nasterii) = MONTH(GETDATE()) AND  DAY(@data_nasterii)> DAY(GETDATE()))
						THEN  1
						ELSE  0
						END))
 RETURN @varsta
 END
 select dbo.ex9_7 ('1998-05-09') AS VARSTA
 ```
 
  ![Git](https://github.com/MaryMN/BDC/blob/master/lab9/images/7.PNG)
  
  
_**8. Sa se creeze o functie definita de utilizator, care ar returna datele referitoare la reW?ita unui
student. Se define~te urmatorul format al functiei: <nume Juncfie>
(<Nume_Prenume_Student>). Sa fie afi~at tabelul cu urmatoarele campuri:
Nume_Prenume_Student, Disticplina, Nota, Data_Evaluare.**_
  
  ```SQL
  CREATE FUNCTION reusita_student (@NP_St VARCHAR(50))
RETURNS TABLE 
AS
RETURN
(Select Nume_Student + ' ' + Prenume_Student as Student, Disciplina, Nota, Data_Evaluare
 From studenti.studenti inner join studenti.studenti_reusita on 
 studenti.studenti.Id_Student=studenti.studenti_reusita.Id_Student inner join 
 plan_studii.discipline on studenti.studenti_reusita.Id_Disciplina=plan_studii.discipline.Id_Disciplina 
 Where Nume_Student + ' ' + Prenume_Student = @NP_St )

 select *
 from reusita_student ('Luca Alex')
 ```
  ![Git](https://github.com/MaryMN/BDC/blob/master/lab9/images/8.PNG)
  
  
_**9. Se cere realizarea unei functii definite de utilizator, care ar gasi eel mai sarguincios sau eel
mai slab student dintr-o grupa. Se define~te urmatorul format al functiei: <numeJuncfie>
(<Cod_ Grupa>, <is_good>). Parametrul <is_good> poate accepta valorile "sarguincios" sau
"slab", respectiv. Functia sa returneze un tabel cu urmatoarele campuri Grupa,
Nume_Prenume_Student, Nota Medie , is_good. Nota Medie sa fie cu precizie de 2
zecimale._** 
  
  ```SQL
  CREATE FUNCTION ex9_9 
(@cod_grupa VARCHAR(10), @is_good VARCHAR(20))
RETURNS @Test Table (Cod_Grupa varchar(10), Student varchar (100), Media decimal(4,2), Reusita varchar(20))
AS
begin
if @is_good = 'sarguincios'
begin
insert into @Test
SELECT top (1) Cod_Grupa, Nume_Student + ' ' + Prenume_Student as Student,
		 CAST(AVG( Nota * 1.0) as decimal (4,2)) as Media, @is_good
 FROM grupe,studenti.studenti, studenti.studenti_reusita
 WHERE grupe.Id_Grupa = studenti_reusita.Id_Grupa
 AND studenti.studenti.Id_Student = studenti_reusita.Id_Student
 AND Cod_Grupa = @cod_grupa
 GROUP BY Cod_Grupa, Nume_Student, Prenume_Student
 Order by Media desc
 end
 else
 begin 
 insert into @Test
SELECT top (1) Cod_Grupa, Nume_Student + ' ' + Prenume_Student as Student,
		 CAST(AVG( Nota * 1.0) as decimal (4,2)) as Media, @is_good
 FROM grupe,studenti.studenti, studenti_reusita
 WHERE grupe.Id_Grupa = studenti_reusita.Id_Grupa
 AND studenti.studenti.Id_Student = studenti_reusita.Id_Student
 AND Cod_Grupa = @cod_grupa
 GROUP BY Cod_Grupa, Nume_Student, Prenume_Student
 Order by Media 
 end
 RETURN 
 end
 ---
 select *
 from ex9_9 ('TI171', 'sarguincios')
  select *
 from ex9_9 ('CIB171', 'sarguincios')
 ```
 
  ![Git](https://github.com/MaryMN/BDC/blob/master/lab9/images/9.PNG)
  
  ![Git](https://github.com/MaryMN/BDC/blob/master/lab9/images/9.1.PNG)

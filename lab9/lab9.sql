--1.) Sa se creeze proceduri stocate in baza exercitiilor (2 exercitii) din capitolul 4. Parametrii de
--intrare trebuie sa corespunda criteriilor din clauzele WHERE ale exercitiilor respective  
--I.4.8. Obtineti identificatorii si numele studentilor, ale examenelor sustinute in anul 2018.
Create procedure U1
@Year date = 2018
AS
Select distinct studenti.studenti.Id_Student as ID, studenti.studenti.Nume_Student as Nume
FROM studenti.studenti INNER JOIN studenti.studenti_reusita ON studenti.studenti.Id_Student=studenti.studenti_reusita.Id_Student
Where Data_Evaluare=@Year

--4.14. Aflati numele si prenumele studentilor, precum si cursurile promovate cu note mai mari de 8 la examen. 
Create Procedure U2
@Mark tinyint = 8 AS
Select studenti.Nume_Student, studenti.Prenume_Student, plan_studii.discipline.Disciplina, studenti.studenti_reusita.Nota as Mark
FROM studenti.studenti 
INNER JOIN studenti.studenti_reusita ON studenti.studenti.Id_Student=studenti.studenti.Id_Student
INNER JOIN plan_studii.discipline ON studenti.studenti_reusita.Id_Disciplina=plan_studii.discipline.Id_Disciplina
Where studenti.studenti_reusita.Nota>@Mark

--35. Gasiti denumirile disciplinelor ~i media notelor pe disciplina. Afi;ati numai disciplinele cu medii mai mari de 7.0. 
Create PRocedure U3
@Mark tinyint=7
AS
SELECT plan_studii.discipline.Disciplina, AVG(cast(studenti.studenti_reusita.Nota as float)) Mark_AVG
FROM plan_studii.discipline
	INNER JOIN studenti.studenti_reusita on studenti.studenti_reusita.Id_Disciplina = plan_studii.discipline.Id_Disciplina
GROUP BY plan_studii.discipline.Disciplina
HAVING AVG(cast(studenti.studenti_reusita.Nota as float)) > @Mark

--ex2. Sa se creeze o procedura stocata, care nu are niciun parametru de intrare ~i poseda un
--parametru de ie~ire. Parametrul de ie~ire trebuie sa returneze numarul de studenti, care nu au
--sustinut eel putin o forma de evaluare (nota mai mica de 5 sau valoare NULL). 
Drop procedure if exists Stocare;
go
 CREATE PROCEDURE Stocare
 @NR_Student smallint =Null output
  AS
Select  @NR_Student= count(Id_Student)
from studenti.studenti_reusita
where Nota<5 or Nota=Null
--
Select  Id_Student
from studenti.studenti_reusita
where Nota<5 or Nota =Null

 DECLARE @NR_Student smallint
EXEC Stocare @NR_Student  output
Print 'numarul de studenti, care nu au sustinut cel putin o forma de evaluare (nota mai mica de 5 sau valoare NULL)='
+ cast( @NR_Student as varchar);

/*ex3. Sa se creeze o procedura stocata, care ar insera in baza de date informatii despre un student
nou. in calitate de parametri de intrare sa serveasca datele personale ale studentului nou ~i
Cod_ Grupa. Sa se genereze toate intrarile-cheie necesare in tabelul studenti_reusita. Notele
de evaluare sa fie inserate ca NULL. */
drop procedure if exists Insert_NEW_St
Create PROCEDURE Insert_NEW_St

@Nume varchar(50),
@Prenume varchar(50),
@DataNastere date,
@Adresa varchar(500),
@Cod_Grupa char(6)
 as
 
 insert into studenti.studenti
 values (1,@Nume,@Prenume,@DataNastere,@Adresa)
 go
insert into studenti.studenti_reusita

 values (1, 105, 110 , 
         (select Id_Grupa 
		  from grupe
		  where Cod_Grupa = @Cod_Grupa), 'Examen', NULL, '2018-11-27')
---------
exec Insert_NEW_St  'Lastname', 'Firstname', '1998-01-01',' mun.Chisinau', 'TI171'

select * 
from studenti.studenti_reusita
 /*ex4. Fie ca un profesor se elibereaza din functie la mijlocul semestrului. Sa se creeze o procedura
stocata care ar reatribui inregistrarile din tabelul studenti_reusita unui alt profesor. Parametri
de intrare: numele ~i prenumele profesorului vechi, numele ~i prenumele profesorului nou,
disciplina. in cazul in care datele inserate sunt incorecte sau incomplete, sa se afi~eze un
mesaj de avertizare. 
 */
 DROP PROCEDURE IF EXISTS Profesori_vechi_noi
GO
CREATE PROCEDURE Profesori_vechi_nou
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
					 
 SET @Error = @@ERROR
 IF @Error <>0
 BEGIN
 RAISERROR ('ERROR : The  inserted   data  is  either incorrect  or  incomplete ' ,10 ,1)
 END

 --
												       /*ex5*/
 /*ex6*/
 /*ex7.Sa se scrie functia care ar calcula varsta studentului. Sa se defineasca urmatorul format al functiei: <nume_functie>(<Data_Nastere_Student>).*/
 DROP Function IF EXISTS datanastere
GO

Create Function datanastere 
(@data_nastere DATE) 
RETURNS Int
 BEGIN
 DECLARE @varsta Int
 Select @varsta = (Select (YEAR(GETDATE()) - YEAR(@data_nastere) - CASE 
 						WHEN (MONTH(@data_nastere) > MONTH(GETDATE())) OR 
						(MONTH(@data_nastere) = MONTH(GETDATE()) AND  
						DAY(@data_nastere)> DAY(GETDATE()))
						THEN  1
						ELSE  0
						END))
 RETURN @varsta
 END

 --
 select datanastere ('1998-01-01') as varsta

 /*ex8. Sa se creeze o functie definita de utilizator, care ar returna datele referitoare la reusita unui student. Se defineste urmatorul format al functiei : < nume_functie > (<Nume_Prenume_Student>). Sa fie afisat tabelul cu urmatoarele campuri: Nume_Prenume_Student, Disticplina, Nota, Data_Evaluare.*/
 DROP FUNCTION IF EXISTS reusita
GO

CREATE FUNCTION reusita (@NP_St VARCHAR(50))
RETURNS TABLE 
AS
RETURN
(Select Nume_Student + ' ' + Prenume_Student as Student, Disciplina, Nota, Data_Evaluare
 From studenti.studenti inner join studenti.studenti_reusita on 
 studenti.studenti.Id_Student=studenti.studenti_reusita.Id_Student inner join 
 plan_studii.discipline on studenti.studenti_reusita.Id_Disciplina=plan_studii.discipline.Id_Disciplina 
 Where Nume_Student + ' ' + Prenume_Student = @NP_St )

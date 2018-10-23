Select distinct studenti.Id_Student, Nume_Student
FROM studenti INNER JOIN studenti_reusita ON studenti.Id_Student=studenti.Id_Student
Where year(Data_Evaluare)=2018

Select Nume_Student, Prenume_Student, Disciplina, Nota
FROM studenti 
INNER JOIN studenti_reusita ON studenti.Id_Student=studenti.Id_Student
INNER JOIN discipline ON studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
Where Nota>8

Select Nume_Student, Prenume_Student, Nota
FROM studenti
INNER JOIN studenti_reusita ON studenti.Id_Student=studenti.Id_Student

Where studenti.Id_Student =100

Select distinct Nume_Student, Prenume_Student, Nota
From studenti, studenti_reusita
Where studenti.Id_Student=studenti_reusita.Id_Student and Nota < Any (select Nota 
From studenti_reusita 
where Id_Student=100)


Select distinct S.Nume_Student, S.Prenume_Student,  S.Adresa_Postala_Student as Oras_resedinta,
P.Nume_Profesor, P.Prenume_Profesor, P.Adresa_Postala_Profesor as Oras_Resedinta, COUNT(*)
From studenti S, studenti_reusita R, profesori P
Where S.Id_Student=R.Id_Student and R.Id_Profesor=P.Id_Profesor and 
SUBSTRING(Adresa_Postala_Profesor, 6,8) in (select distinct ltrim (substring(Adresa_Postala_Student,charindex(' ',Adresa_Postala_Student), CHARINDEX(' ',ltrim(SUBSTRING(Adresa_Postala_Student,charindex(' ',Adresa_Postala_Student),LEN(Adresa_Postala_Student)-charindex(' ',Adresa_Postala_Student)))) -1)) 
from studenti)
group by SUBSTRING(Adresa_Postala_Profesor, 6,8), S.Adresa_Postala_Student,  S.Nume_Student, S.Prenume_Student,P.Nume_Profesor, P.Prenume_Profesor, P.Adresa_Postala_Profesor, ltrim (substring(Adresa_Postala_Student,charindex(' ',Adresa_Postala_Student), CHARINDEX(' ',ltrim(SUBSTRING(Adresa_Postala_Student,charindex(' ',Adresa_Postala_Student),LEN(Adresa_Postala_Student)-charindex(' ',Adresa_Postala_Student)))) -1))
order by count(*) 




SELECT d.Disciplina, AVG(cast(s.Nota as float)) Media_Notelor 
FROM discipline d
	INNER JOIN studenti_reusita s on s.Id_Disciplina = d.Id_Disciplina
GROUP BY Disciplina
HAVING AVG(cast(s.Nota as float)) > 7








Select studenti.Nume_Student,studenti.Prenume_Student, grupe.Id_Grupa
From studenti inner join studenti_reusita
on studenti.Id_Student=studenti.Id_Student inner join grupe
on studenti_reusita.Id_Grupa=grupe.Id_Grupa

select SUBSTRING(Adresa_Postala_Profesor, 6,8)
from profesori
select distinct ltrim (substring(Adresa_Postala_Student,charindex(' ',Adresa_Postala_Student), CHARINDEX(' ',ltrim(SUBSTRING(Adresa_Postala_Student,charindex(' ',Adresa_Postala_Student),LEN(Adresa_Postala_Student)-charindex(' ',Adresa_Postala_Student)))) -1)) 
from studenti








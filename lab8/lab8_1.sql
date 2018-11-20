--8. Obtineti identificatorii si numele studentilor, ale examenelor sustinute in anul 2018.
Create view ex1 as  
			Select distinct studenti.studenti.Id_Student, studenti.studenti.Nume_Student
			FROM studenti.studenti INNER JOIN studenti.studenti_reusita 
			ON studenti.studenti.Id_Student=studenti.studenti_reusita.Id_Student
			Where year(studenti.studenti_reusita.Data_Evaluare)=2018
GO
			Select *
			FROM ex1

--35. Gasiti denumirile disciplinelor ~i media notelor pe disciplina. Afi;ati numai disciplinele cu medii mai mari de 7.0. 
create view exerc1  as
			SELECT plan_studii.discipline.Disciplina, AVG(cast(studenti.studenti_reusita.Nota as float)) Media_Notelor 
			FROM plan_studii.discipline
			INNER JOIN studenti.studenti_reusita 
			on studenti.studenti_reusita.Id_Disciplina = plan_studii.discipline.Id_Disciplina
			GROUP BY plan_studii.discipline.Disciplina
			HAVING AVG(cast(studenti.studenti_reusita.Nota as float)) > 7
GO
			select *
			from exerc1
--Sa se scrie cate un exemplu de instructiuni INSERT, UPDATE, DELETE asupra viziunilor create. view_1
ALTER view View_1  AS
			SELECT DISTINCT studenti.studenti.Prenume_Student, plan_studii.discipline.Disciplina, 
			studenti.studenti_reusita.Nota, studenti.studenti.Nume_Student
			FROM plan_studii.discipline INNER JOIN studenti.studenti_reusita 
			ON plan_studii.discipline.Id_Disciplina = studenti.studenti_reusita.Id_Disciplina INNER JOIN studenti.studenti 
			ON studenti.studenti_reusita.Id_Student = studenti.studenti.Id_Student
			WHERE        (studenti.studenti_reusita.Nota > 8)
GO
			INSERT INTO View_1 
			values (100,'AAAA', 'BBBB')
GO

create view ex as 
select nume_student , Prenume_Student from student
go

SELECT * FROM View_1
SELECT * FROM ex

select * from student

-- Modificarea unui element in viziune
UPDATE View_1 
SET Prenume_Student = 'CCCC'
WHERE Prenume_Student = 'Teodora'
SELECT * FROM View_1

-- Stergerea unui element din viziune
delete from ex where Nume_Student = 'AAAA'

select * from ex 


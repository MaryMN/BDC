# LAB8


1. _**Sa se creeze doua viziuni in baza interogarilor formulate in doua exercitii indicate din capitolul 4. Prima viziune sa fie construita in Editorul de interogari, iar a doua, utilizand View
Designer.**_

![Image](https://github.com/MaryMN/BDC/blob/master/lab8/images/1.PNG)

![Image](https://github.com/MaryMN/BDC/blob/master/lab8/images/1.1.PNG)

![Image](https://github.com/MaryMN/BDC/blob/master/lab8/images/1.2.PNG)

```
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
```


2. **_Sa se scrie cate un exemplu de instructiuni INSERT, UPDATE, DELETE asupra viziunilor
create. Sa se adauge comentariile respective referitoare la rezultatele executarii acestor
instructiuni._**

![Image](https://github.com/MaryMN/BDC/blob/master/lab8/images/20.PNG)

![Image](https://github.com/MaryMN/BDC/blob/master/lab8/images/21.PNG)

![Image](https://github.com/MaryMN/BDC/blob/master/lab8/images/23.PNG)



```
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
```

```
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


alter view exerc1  as
			SELECT plan_studii.discipline.Disciplina, AVG(cast(studenti.studenti_reusita.Nota as float)) Media_Notelor 
			FROM plan_studii.discipline
			INNER JOIN studenti.studenti_reusita 
			on studenti.studenti_reusita.Id_Disciplina = plan_studii.discipline.Id_Disciplina
			GROUP BY plan_studii.discipline.Disciplina
			HAVING AVG(cast(studenti.studenti_reusita.Nota as float)) > 7
GO
			select *
			from exerc1


create view exercitiu as 
SELECT  plan_studii.discipline.Id_Disciplina, plan_studii.discipline.Disciplina 
	FROM plan_studii.discipline
go

drop view exercitiu
go
delete from plan_studii.discipline where Id_Disciplina=1
go
update plan_studii.discipline set Id_Disciplina=1
INSERT INTO exercitiu 
values (8,'Limba Engleza')
GO
select * from exercitiu


-- Modificarea unui element in viziune
UPDATE exerc1 
SET Disciplina = 'Disciplina'
where Disciplina = 'Retele informatice'
SELECT * FROM exerc1

-- Stergerea unui element din viziune
delete from exercitiu where Disciplina = 'Limba Engleza' 

select * from exercitiu
```

3. _**Sa se scrie instructiunile SQL care ar modifica viziunile create (in exercitiul 1) in asa fel, incat
sa nu fie posibila modificarea sau stergerea tabelelor pe care acestea sunt definite si viziunile
sa nu accepte operatiuni DML, daca conditiile clauzei WHERE nu sunt satis:facute.**_

![Image](https://github.com/MaryMN/BDC/blob/master/lab8/images/3.PNG)

```
ALTER view exerc1 WITH SCHEMABINDING  as
			SELECT plan_studii.discipline.Disciplina, AVG(cast(studenti.studenti_reusita.Nota as float)) Media_Notelor 
			FROM plan_studii.discipline
			INNER JOIN studenti.studenti_reusita 
			on studenti.studenti_reusita.Id_Disciplina = plan_studii.discipline.Id_Disciplina
			GROUP BY plan_studii.discipline.Disciplina
			HAVING AVG(cast(studenti.studenti_reusita.Nota as float)) > 7
WITH CHECK OPTION;
```

4. **_Sa se scrie instructiunile de testare a proprietatilor noi definite._**

![Image](https://github.com/MaryMN/BDC/blob/master/lab8/images/4.PNG)

![Image](https://github.com/MaryMN/BDC/blob/master/lab8/images/4.1.PNG)

```
--delete
ALTER TABLE plan_studii.discipline DROP COLUMN Disciplina
--insert
INSERT INTO exerc1
values (1, 'informatica')
```

5. _**Sa se rescrie 2 interogari formulate in exercitiile din capitolul 4, in asa fel. incat interogarile
imbricate sa fie redate sub forma expresiilor CTE.**_

![Image](https://github.com/MaryMN/BDC/blob/master/lab8/images/5.PNG)

```
WITH ex35_CTE (Disciplina) AS
(SELECT Disciplina
from plan_studii.discipline)
SELECT  AVG(cast(studenti.studenti_reusita.Nota as float)) Media_Notelor 
			FROM ex35_CTE
			INNER JOIN studenti.studenti_reusita 
			on studenti.studenti_reusita.Id_Disciplina = ex35_CTE.Id_Disciplina
			GROUP BY ex35_CTE.Disciplina
			HAVING AVG(cast(studenti.studenti_reusita.Nota as float)) > 7
```
6. **_Se considera un graf orientat, precum eel din figura de mai jos si fie se dore~te parcursa calea
de la nodul id = 3 la nodul unde id = 0. Sa se faca reprezentarea grafului orientat in forma de
expresie-tabel recursiv.
Sa se observe instructiunea de dupa UNION ALL a membrului recursiv, precum si partea de
pana la UNION ALL reprezentata de membrul-ancora._**

![Image](https://github.com/MaryMN/BDC/blob/master/lab8/images/Capture.PNG)

![Image](https://github.com/MaryMN/BDC/blob/master/lab8/images/6.PNG)

```
CREATE TABLE graf (
		Id_NR int PRIMARY KEY NOT NULL,
		numar_depend int NOT NULL
		);

INSERT INTO graf VALUES
(5,0), (4,2), (3,2), (1,0), (2,1), (0, null);

select * from graf;
WITH graf_cte AS (
		SELECT Id_NR , numar_depend FROM graf
		WHERE Id_NR = 3 and numar_depend = 2
		
		UNION ALL
		
		SELECT graf.Id_NR, graf.numar_depend FROM graf
		INNER JOIN graf_cte
		ON graf.ID_NR = graf_cte.numar_depend
			
)
SELECT * from graf_cte
```

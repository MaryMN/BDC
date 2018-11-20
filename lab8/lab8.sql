--2. Sa se scrie cate un exemplu de instructiuni INSERT, UPDATE, DELETE asupra viziunilor create.  (from exerc1)
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

--3. Sa se scrie instructiunile SQL care ar modifica viziunile create (in exercitiul 1) in ~a fel, incat
--sa nu fie posibila modificarea sau ~tergerea tabelelor pe care acestea sunt definite ~i viziunile
--sa nu accepte operatiuni DML, daca conditiile clauzei WHERE nu sunt satis:facute. 
ALTER view exerc1 WITH SCHEMABINDING  as
			SELECT plan_studii.discipline.Disciplina, AVG(cast(studenti.studenti_reusita.Nota as float)) Media_Notelor 
			FROM plan_studii.discipline
			INNER JOIN studenti.studenti_reusita 
			on studenti.studenti_reusita.Id_Disciplina = plan_studii.discipline.Id_Disciplina
			GROUP BY plan_studii.discipline.Disciplina
			HAVING AVG(cast(studenti.studenti_reusita.Nota as float)) > 7
WITH CHECK OPTION;

--4. Sa se scrie instructiunile de testare a proprietatilor noi definite
--delete
ALTER TABLE plan_studii.discipline DROP COLUMN Disciplina
--insert
INSERT INTO exerc1
values (1, 'informatica')


--5.  Sa se rescrie 2 interogari formulate in exercitiile din capitolul 4, in ~a fel. incat interogarile
--imbricate sa fie redate sub forma expresiilor CTE. 
--int.35
WITH ex35_CTE (Disciplina) AS
(SELECT Disciplina
from plan_studii.discipline)
SELECT  AVG(cast(studenti.studenti_reusita.Nota as float)) Media_Notelor 
			FROM ex35_CTE
			INNER JOIN studenti.studenti_reusita 
			on studenti.studenti_reusita.Id_Disciplina = ex35_CTE.Id_Disciplina
			GROUP BY ex35_CTE.Disciplina
			HAVING AVG(cast(studenti.studenti_reusita.Nota as float)) > 7

/*6.Se considera un graf orientat, precum eel din figura de mai jos ~i fie se dore~te parcursa calea
de la nodul id = 3 la nodul unde id = 0. Sa se faca reprezentarea grafului orientat in forma de
expresie-tabel recursiv.
Sa se observe instructiunea de dupa UNION ALL a membrului recursiv, precum ~i partea de
pana la UNION ALL reprezentata de membrul-ancora. */
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
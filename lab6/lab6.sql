--Sa se scrie o instructiune T-SQL, care ar popula co Joana Adresa _ Postala _ Profesor din tabelul
--profesori cu valoarea 'mun. Chisinau', unde adresa este necunoscuta
select *
from profesori
update profesori
set Adresa_Postala_Profesor = 'mun.Chisinau'
where Adresa_Postala_Profesor is null;


--Sa se modifice schema tabelului grupe, ca sa corespunda urmatoarelor cerinte:
--a) Campul Cod_ Grupa sa accepte numai valorile unice ~i sa nu accepte valori necunoscute.
--b) Sa se tina cont ca cheie primarii, deja, este definitii asupra coloanei Id_ Grupa. 

create unique index index_cod_grupa
on grupe (cod_grupa)
exec sp_helpindex grupe;

select cod_grupa
from grupe
/*
Msg 1913, Level 16, State 1, Line 10
The operation failed because an index or statistics with name 'index_cod_grupa' already exists on table 'grupe'
*/




/*La tabelul grupe, sa se adauge 2 coloane noi Sef_grupa ~i Prof_Indrumator, ambele de tip
INT. Sii se populeze campurile nou-create cu cele mai potrivite candidaturi ill baza criteriilor
de maijos:
a) $eful grupei trebuie sa aiba cea mai buna reu~itii (medie) din grupa la toate formele de
evaluare ~i la toate disciplinele. Un student nu poate fi ~ef de grupa la mai multe grupe.
b) Profesorul fndrumator trebuie sa predea un numiir maximal posibil de discipline la grupa
data. Daca nu existii o singurii candidaturii, care corespunde primei cerinte, atunci este
ales din grupul de candidati acel cu identificatorul (Id_Profesor) minimal. Un profesor nu
poate fi illdrumator la mai multe grupe.
c) Sii se scrie instructiunile ALTER, SELECT, UPDATE necesare pentru crearea coloanelor
in tabelul grupe, pentru selectarea candidatilor ~i inserarea datelor */

alter table grupe add sef_grupa int,prof_indrumator int ;

declare @nr_grupe int = (select COUNT(Id_Grupa)
from grupe)
declare @init int =1;

while(@init<=@nr_grupe)
	begin
		update grupe
--selectarea sefului de grupa dupa media cea mai mare
		set sef_grupa = (select top 1 x.Id_Student
		from(
		select  Id_Student,avg(cast(Nota as float)) as Media
		from studenti_reusita 
		where Id_Grupa=@init
		group by Id_Student ) x
		order by x.Media desc),
--pentru selectare profesorul indrumator dupa nr de discipline maxim
		prof_indrumator = (select y.Id_Profesor
		from(
		select top 1 Id_Profesor ,count(distinct Id_Disciplina) as nr_disc
		from studenti_reusita
		where Id_Grupa=@init
		GROUP BY Id_Profesor 
		order by nr_disc desc) y)
		where Id_Grupa=	@init
		set @init = @init+1;
	end
--adaugare indexului unique pentru cimpurile noi create
alter table grupe add constraint prof_stud unique(sef_grupa,prof_indrumator);


select *
from grupe

--Sa se scrie o instructiune T-SQL, care ar mari toate notele de evaluare ~efilor de grupe cu un
--punct. Nota maximala (10) nu poate fi miirita. 

update studenti_reusita
set Nota =  Nota +1
where Tip_Evaluare='Examen' 
		and Id_Student = any(select sef_grupa from grupe) 
		and Nota !=10

select   Id_Disciplina, Tip_Evaluare, Sef_grupa, Nota
from studenti_reusita	inner join	grupe 
on studenti_reusita.Id_Grupa = grupe.Id_Grupa
where Tip_Evaluare='Examen'

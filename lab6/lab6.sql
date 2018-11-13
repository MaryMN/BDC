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


/*Sa se creeze un tabel profesori_new, care include urmatoarele coloane: Id_Profesor,
Nume _ Profesor, Prenume _ Profesor, Localitate, Adresa _ 1, Adresa _ 2.
a) Coloana Id_Profesor trebuie sa fie definita drept cheie primara si, in baza ei, sa fie
construit un index CLUSTERED.
b) Campul Localitate trebuie sa posede proprietatea DEFAULT= 'mun. Chisinau'.
c) Sa se insereze toate datele din tabelul profesori in tabelul profesori_new. Sa se scrie, cu
acest scop, un numar potrivit de instructiuni T-SQL. Datele trebuie sa fie transferate in
felul urmator:
Coloana-sursa   |Coloana-destinatie
----------------|--------------------
Id_Profesor     |Id_Profesor
----------------|--------------------
Nume_Profesor   |Nume_Profesor
----------------|--------------------
Prenume_Profesor|Prenume_Profesor
----------------|--------------------
Adresa_Postala  |Profesor_Localitate
----------------|--------------------
Adresa_Postala  |Profesor_Adresa 1
----------------|--------------------
Adresa_Pastala  |Profesor_Adresa 2
----------------|--------------------
In coloana Localitate sa fie inserata doar informatia despre denumirea localitatii din
coloana-sursa Adresa_Postala_Profesor. in coloana Adresa_l, doar denumirea strazii. In
coloanaAdresa_2, sa se pastreze numarul casei si (posibil) al apartamentului. */
CREATE TABLE profesori_new
(Id_Profesor int NOT NULL,
 Nume_Profesor char(255),
 Prenume_Profesor char(255),
 Localitate char (255) DEFAULT ('mun. Chisinau'),
 Adresa_1 char (255),
 Adresa_2 char (255),
  CONSTRAINT [PK_profesori_new] PRIMARY KEY CLUSTERED 
(Id_Profesor )) ON [PRIMARY]

INSERT INTO profesori_new (Id_Profesor,Nume_Profesor, Prenume_Profesor, Localitate,Adresa_1, Adresa_2)
(SELECT Id_Profesor, Nume_Profesor, Prenume_Profesor, Adresa_Postala_Profesor, Adresa_Postala_Profesor, 
Adresa_Postala_Profesor
from profesori)

UPDATE profesori_new
SET Localitate = case when CHARINDEX(', s.',Localitate) >0
				 then case when CHARINDEX (', str.',Localitate) > 0
							then SUBSTRING (Localitate,1, CHARINDEX (', str.',Localitate)-1)
					        when CHARINDEX (', bd.',Localitate) > 0
							then SUBSTRING (Localitate,1, CHARINDEX (', bd.',Localitate)-1)
				      end
				  when  CHARINDEX(', or.',Localitate) >0
				 then case when CHARINDEX (', str.',Localitate) > 0
							then SUBSTRING (Localitate,1, CHARINDEX ('str.',Localitate)-3)
					        when CHARINDEX (', bd.',Localitate) > 0
							then SUBSTRING (Localitate,1, CHARINDEX ('bd.',Localitate)-3)
					  end
				when CHARINDEX('nau',Localitate) >0
				then SUBSTRING(Localitate, 1, CHARINDEX('nau',Localitate)+2)
				end
UPDATE profesori_new
SET Adresa_1 = case when CHARINDEX('str.', Adresa_1)>0
					then SUBSTRING(Adresa_1,CHARINDEX('str',Adresa_1), PATINDEX('%, [0-9]%',Adresa_1)- 
					CHARINDEX('str.',Adresa_1))
			        when CHARINDEX('bd.',Adresa_1)>0
					then SUBSTRING(Adresa_1,CHARINDEX('bd',Adresa_1), PATINDEX('%, [0-9]%',Adresa_1) -  
					CHARINDEX('bd.',Adresa_1))
			   end

UPDATE profesori_new
SET Adresa_2 = case when PATINDEX('%, [0-9]%',Adresa_2)>0
					then SUBSTRING(Adresa_2, PATINDEX('%, [0-9]%',Adresa_2)+1,len(Adresa_2) - 
					PATINDEX('%, [0-9]%',Adresa_2)+1)
				end
				
select * from profesori_new


/*Să se insereze datele in tabelul orarul pentru Grupa= 'CIBJ 71' (Id_ Grupa= 1) pentru ziua de luni. 
Toate lectiile vor avea loc în blocul de studii 'B'. Mai jos, sunt prezentate detaliile de inserare:
(ld_Disciplina = 107, Id_Profesor= 101, Ora ='08:00', Auditoriu = 202);
(Id_Disciplina = 108, Id_Profesor= 101, Ora ='11:30', Auditoriu = 501);
(ld_Disciplina = 119, Id_Profesor= 117, Ora ='13:00', Auditoriu = 501);*/

create table orarul ( Id_Disciplina int NOT NULL,
					  Id_Profesor int NOT NULL,
					  Id_Grupa smallint default(1) NOT NULL,
					  Zi char(2),
					  Ora Time,
					  Auditoriu int NULL,
					  Bloc char(1) default('B'),
					  CONSTRAINT [PK_orarul] PRIMARY KEY CLUSTERED (Id_Disciplina,Id_Profesor,Id_Grupa,	ZI))ON [PRIMARY]
Insert orarul (Id_Disciplina , Id_Profesor, Zi, Ora, Auditoriu)
       values ( 107, 101, 'Lu','08:00', 202 )
Insert orarul (Id_Disciplina , Id_Profesor, Zi, Ora, Auditoriu)
       values ( 108, 101, 'Lu','11:30', 501 )
Insert orarul (Id_Disciplina , Id_Profesor, Zi, Ora, Auditoriu)
       values ( 109, 117, 'Lu','13:00', 501 )

select * from orarul

/*Sa se scrie expresiile T-SQL necesare pentru a popula tabelul orarul pentru grupa INF171 , ziua de luni. 
Datele necesare pentru inserare trebuie sa fie colectate cu ajutorul instructiunii/instructiunilor SELECT si 
introduse in tabelul-destinatie, stiind ca: 
lectie #1 (Ora ='08:00', Disciplina = 'Structuri de date si algoritmi', Profesor ='Bivol Ion')
lectie #2 (Ora ='11 :30', Disciplina = 'Programe aplicative', Profesor ='Mircea Sorin')
lectie #3 (Ora ='13:00', Disciplina ='Baze de date', Profesor = 'Micu Elena')*/

INSERT INTO orarul (Id_Disciplina, Id_Profesor, Id_Grupa, Zi, Ora)
values ((select Id_Disciplina from discipline where Disciplina = 'Structuri de date si algoritmi'),
		(select Id_Profesor from profesori where Nume_Profesor = 'Bivol' and Prenume_Profesor = 'Ion'),
		(select Id_Grupa from grupe where Cod_Grupa = 'INF171'), 'Lu', '08:00')

INSERT INTO orarul (Id_Disciplina, Id_Profesor, Id_Grupa, Zi, Ora)
values ((select Id_Disciplina from discipline where Disciplina = 'Programe aplicative'),
		(select Id_Profesor from profesori where Nume_Profesor = 'Mircea' and Prenume_Profesor = 'Sorin'),
		(select Id_Grupa from grupe where Cod_Grupa = 'INF171'), 'Lu', '11:30')

INSERT INTO orarul (Id_Disciplina, Id_Profesor, Id_Grupa, Zi, Ora)
values ((select Id_Disciplina from discipline where Disciplina = 'Baze de date'),
		(select Id_Profesor from profesori where Nume_Profesor = 'Micu' and Prenume_Profesor = 'Elena'),
		(select Id_Grupa from grupe where Cod_Grupa = 'INF171'), 'Lu', '13:00')

select * from orarul

/*Sa se scrie interogarile de creare a indecsilor asupra tabelelor din baza de date universitatea pentru a asigura 
o performanta sporita la executarea interogarilor SELECT din Lucrarea practica 4. 
Rezultatele optimizarii sa fie analizate in baza planurilor de executie, pana la si dupa crearea indecsilor. 
Indecsii nou-creati sa fie plasati fizic in grupul de fisiere userdatafgroupl 
(Crearea si intrefinerea bazei de date - sectiunea 2.2.2)*/
ALTER DATABASE universitatea
ADD FILEGROUP userdatafgroupl
GO

ALTER DATABASE universitatea
ADD FILE
( NAME = Indexes,
FILENAME = 'd:\db.ndf',
SIZE = 1MB
)
TO FILEGROUP userdatafgroupl
GO

CREATE NONCLUSTERED INDEX pk_id_disciplina ON
discipline (id_disciplina)
ON [userdatafgroupl]
# Laboratory work nr.5 

_**Completati urmatorul cod pentru a afisati cel mai mare numar dintre cele trei numere prezentate:**_ 

![imaginename](https://github.com/MaryMN/BDC/blob/master/lab5/images/1.PNG)




_**Afisati primele zece date (numele, prenumele studentului) in functie de valoarea notei (cu exceptia
notelor 6 si 8) a studentului la primul test al disciplinei Baze de date , folosind structura de
altemativa IF. .. ELSE. Sa se foloseasca variabilele.**_
```SQL
declare @Nume_Disciplina varchar(20) = 'Baze de date';
declare @Tipul_Testului varchar(20) = 'Testul 1';
declare @Nota1 int = 6;
declare @Nota2 int = 8;

if @Nota1 !=any (select  top (10) Nota
from studenti, studenti_reusita, discipline
where studenti.Id_Student = studenti_reusita.Id_Student
and discipline.Id_Disciplina = studenti_reusita.Id_Disciplina
and Disciplina = @Nume_Disciplina
and Tip_Evaluare = @Tipul_Testului)

and @Nota2 != any (select  top (10) Nota
from studenti, studenti_reusita, discipline
where studenti.Id_Student = studenti_reusita.Id_Student
and discipline.Id_Disciplina = studenti_reusita.Id_Disciplina
and Disciplina = @Nume_Disciplina
and Tip_Evaluare = @Tipul_Testului)

begin

select  top (10) Nume_Student, Prenume_Student, Nota
from studenti, studenti_reusita, discipline
where discipline.Id_Disciplina = studenti_reusita.Id_Disciplina
and studenti.Id_Student = studenti_reusita.Id_Student
and Disciplina = @Nume_Disciplina
and Tip_Evaluare = @Tipul_Testului
and Nota not in (@Nota1, @Nota2)

end
```
![imaginename](https://github.com/MaryMN/BDC/blob/master/lab5/images/2.PNG)




_**Rezolvati aceesi sarcina, 1, apeland la structura selectiva CASE**_

![imaginename](https://github.com/MaryMN/BDC/blob/master/lab5/images/3.PNG)




_**Modificati exercitiile din sarcinile 1 si 2 pentru a include procesarea erorilor cu TRY si CATCH, si
RAISERRROR.**_

*With TRY & CATCH instruction*

![imaginename](https://github.com/MaryMN/BDC/blob/master/lab5/images/4.1.PNG)
![imaginename](https://github.com/MaryMN/BDC/blob/master/lab5/images/4.1.1.PNG)


*With RAISERROR instruction*

![imaginename](https://github.com/MaryMN/BDC/blob/master/lab5/images/4.1.2.PNG)

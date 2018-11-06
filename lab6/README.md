# LAB 6


1. _Sa se scrie o instructiune T-SQL, care ar popula co Joana Adresa _ Postala _ Profesor din tabelul profesori cu valoarea 'mun. Chisinau', unde adresa este necunoscuta_
 
 ```
select *
from profesori
update profesori
set Adresa_Postala_Profesor = 'mun.Chisinau'
where Adresa_Postala_Profesor is null;
  ```

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab6/photo/1.PNG)



2. *Sa se modifice schema tabelului grupe, ca sa corespunda urmatoarelor cerinte: a) Campul Cod_ Grupa sa accepte numai valorile unice ~i sa nu accepte valori necunoscute. b) Sa se tina cont ca cheie primarii, deja, este definitii asupra coloanei Id_ Grupa.*

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab6/photo/2.PNG)

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab6/photo/2.1.PNG)



3. *La tabelul grupe, sa se adauge 2 coloane noi Sef_grupa si Prof_Indrumator, ambele de tip INT. Si se populeze campurile nou-create cu cele mai potrivite candidaturi ill baza criteriilor de maijos: 

a) $eful grupei trebuie sa aiba cea mai buna reuitii (medie) din grupa la toate formele de evaluare si la toate disciplinele. Un student nu poate fi ~ef de grupa la mai multe grupe. 

b) Profesorul fndrumator trebuie sa predea un numiir maximal posibil de discipline la grupa data. Daca nu existii o singurii candidaturii, care corespunde primei cerinte, atunci este ales din grupul de candidati acel cu identificatorul (Id_Profesor) minimal. Un profesor nu poate fi illdrumator la mai multe grupe. 

c) Sii se scrie instructiunile ALTER, SELECT, UPDATE necesare pentru crearea coloanelor in tabelul grupe, pentru selectarea candidatilor si inserarea datelor*


![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab6/photo/3.PNG)

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab6/photo/3.1.PNG)




4. *Sa se scrie o instructiune T-SQL, care ar mari toate notele de evaluare ~efilor de grupe cu un punct. Nota maximala (10) nu poate fi marita.*

![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab6/photo/4.PNG)
![GitHub Logo](https://github.com/MaryMN/BDC/blob/master/lab6/photo/4.1.PNG)

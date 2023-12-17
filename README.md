Din uppgift är att designa en databas enligt instruktioner nedan. Läs noga igenom domänbeskrivningen. Den är ganska komplex, så jag finns alltid här för att svara på frågor om domänen.
Uppgiften är indelad i flera steg och har en inlämning kopplad till varje steg. Allting lämnas in via LearnPoint.
Till uppgiften hör ett exempelschema och en domänbeskrivning som ni hittar på LearnPoint.
Uppgiften utförs i grupper om 2-3 studenter.

Uppgift 1 – ERD: 
Din första uppgift är att modellera databasen. Som tur är finns det ett schema som någon designat innan. Detta schema är dock inkomplett och behöver utökas för att korrekt modellera domänen.

1.	Kolla in det ofärdiga schemat.
2.	Skissa ett ER-diagram utifrån detta ofärdiga schema.
3.	Läs igenom domänbeskrivningen igen och utöka schemat för att bättre modellera domänen.
4.	Se till att ditt schema är normaliserat upp till 3NF.
Inläming: En bild över ditt schema.

Uppgift 2 – Implementera Tabellerna
Du ska nu implementera ditt ER-diagram med CREATE TABLE-statements och lämpliga PRIMARY och FOREIGN KEYS.

För att kolla igenom att du implementerat databasen rätt måste du testa dina constraints för olika scenarier. Dessa kan exempelvis vara:
•	Två grenar med samma namn, fast på olika program.
•	En student som inte har tagit några kurser.
•	En student som bara har fått underkänt.
•	En student som inte har valt någon gren.
•	En väntelista kan bara finnas för platsbegränsade kurser.
•	Och så vidare..
När du gjort detta kan du gå vidare till nästa uppgift.
Inlämning: en fil, tables.sql, som skapar alla tabeller.

Uppgift 3 – Views
Baserat på din tidigare databas ska du skapa följande views.

basic_information(idnr, name, program, branch) Visar information om alla studenter. Branch tillåts vara NULL.

finished_courses(student, course, grade, credits) Alla avslutade kurser för varje student, tillsammans med betyg och högskolepoäng.

passed_courses(student, course, credits) Alla godkända kurser för varje student.

registrations(student, course, status) Alla registrerade och väntande studenter för olika kurser. Statusen kan antingen vara ’waiting’ eller ’registered’.

unread_mandatory(student, course) Olästa obligatoriska kurser för varje student.

course_queue_position(course, student, place) Alla väntande studenter, rangordnade i turordning på väntelistan.

Om du har andra kolumner i dina views, dubbelkolla detta med mig. Dina views kan också vara godkända.

Inlämning: views.sql med definitionen för alla views.

Uppgift 4 – Frontend
Du ska nu skapa en enkel frontend för databasen. Du får själv välja vilken funktion detta ska vara. Det skulle till exempel kunna vara ett gränssnitt för en student att registrera sig på kurser. Det räcker att interagera med en av dina tabeller.
Du ska nu göra något högst ovanligt i den här uppgiften. Du ska medvetet introducera en möjlighet för att användaren att utföra en SQL-injection via din frontend. I kommentarer i koden anger du hur man skulle gå tillväga för att utnyttja den här svagheten. Kommentera också hur du skulle fixa detta.

Inlämning: En fil app.py eller en länk till GitHub-repo.

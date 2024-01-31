--#1 Share of countries by amount and number of orders

SELECT BillingCountry AS Country , SUM(Total) AS Sum_Invoice, COUNT(*) AS Numb_of_orders
FROM Invoice i  
GROUP BY 1 
ORDER BY 2 DESC;

--#2 Number and amount of sales by genre

SELECT g.Name , COUNT(*) AS Numb_of_orders , SUM(il.UnitPrice) as Total_Sum
FROM Invoice i 
LEFT JOIN InvoiceLine il  ON i.InvoiceId = il.InvoiceId
LEFT JOIN Customer c ON i.CustomerId = c.CustomerId 
LEFT JOIN Track t ON il.TrackId = t.TrackId 
LEFT JOIN Genre g ON t.GenreId = g.GenreId 
GROUP BY 1
ORDER BY 2 DESC;

--#3 Genres of music by popularity for each country

SELECT c.Country , g.Name , COUNT(*) AS Numb_of_orders
FROM InvoiceLine il  
LEFT JOIN Invoice i  ON i.InvoiceId = il.InvoiceId
LEFT JOIN Customer c ON i.CustomerId = c.CustomerId 
LEFT JOIN Track t ON il.TrackId = t.TrackId 
LEFT JOIN Genre g ON t.GenreId = g.GenreId 
GROUP BY 1,2
ORDER BY 1,3 DESC;

--#4 The most popular genre for each country

SELECT * 
FROM (
SELECT c.Country , g.Name , COUNT(*) AS Numb_of_orders, 
ROW_NUMBER () over (PARTITION BY c.Country ORDER BY COUNT(*) DESC) AS numb
FROM InvoiceLine il  
LEFT JOIN Invoice i  ON i.InvoiceId = il.InvoiceId
LEFT JOIN Customer c ON i.CustomerId = c.CustomerId 
LEFT JOIN Track t ON il.TrackId = t.TrackId 
LEFT JOIN Genre g ON t.GenreId = g.GenreId 
GROUP BY 1,2
ORDER BY 1,3 DESC
) 
WHERE numb = 1;


--#5 The most profitable customers

SELECT c.CustomerId , FirstName , LastName , SUM( i.Total) AS Total_sum
FROM Customer c 
LEFT JOIN Invoice i ON I.CustomerId = C.CustomerId 
GROUP BY 1
ORDER BY 4 DESC;


--#6 The genre is a favorite for the most profitable customers and the number of orders is precisely for this genre

WITH CustomerGenre AS (
SELECT c.CustomerId, 
       c.FirstName,
       c.LastName,
       g.GenreId,
       g.Name,
           COUNT(g.GenreId) AS GenreCount
 FROM InvoiceLine il  
 LEFT JOIN Invoice i ON i.InvoiceId = il.InvoiceId
 LEFT JOIN Customer c ON i.CustomerId = c.CustomerId 
 LEFT JOIN Track t ON il.TrackId = t.TrackId 
 LEFT JOIN Genre g ON t.GenreId = g.GenreId 
 GROUP BY c.CustomerId, g.GenreId
)
SELECT CustomerId,
       FirstName,
       LastName,
       Name,
       MAX(GenreCount) AS Numb_of_orders
FROM CustomerGenre
GROUP BY CustomerId, FirstName, LastName;


--#7 The most profitable and most popular artist

SELECT art.Name , COUNT(*) AS Numb_of_orders , SUM(il.UnitPrice) as Total_Sum
FROM Invoice i 
LEFT JOIN InvoiceLine il  ON i.InvoiceId = il.InvoiceId
LEFT JOIN Customer c ON i.CustomerId = c.CustomerId 
LEFT JOIN Track t ON il.TrackId = t.TrackId 
LEFT JOIN Album a ON t.AlbumId = a.AlbumId 
LEFT JOIN Artist art ON a.ArtistId = art.ArtistId 
GROUP BY 1
ORDER BY 3 DESC;


--#8 The most profitable performers to the price per unit of production

WITH KPI AS (
SELECT art.Name , COUNT(*) AS Numb_of_orders , SUM(il.UnitPrice) as Total_Sum
FROM Invoice i 
LEFT JOIN InvoiceLine il  ON i.InvoiceId = il.InvoiceId
LEFT JOIN Customer c ON i.CustomerId = c.CustomerId 
LEFT JOIN Track t ON il.TrackId = t.TrackId 
LEFT JOIN Album a ON t.AlbumId = a.AlbumId 
LEFT JOIN Artist art ON a.ArtistId = art.ArtistId 
GROUP BY 1
ORDER BY 3 DESC
)
SELECT 
	Name,
	Numb_of_orders,
	Total_Sum,
	(Total_Sum/Numb_of_orders)*100 as KPI
FROM KPI
WHERE  KPI > 100;


--#9 The most popular song by the number of orders

SELECT art.Name AS Artist , t.Name as Track , g.Name AS Genre , COUNT(*) AS Numb_of_orders , SUM(il.UnitPrice) as Total_Sum
FROM Invoice i 
LEFT JOIN InvoiceLine il  ON i.InvoiceId = il.InvoiceId
LEFT JOIN Customer c ON i.CustomerId = c.CustomerId 
LEFT JOIN Track t ON il.TrackId = t.TrackId 
LEFT JOIN Genre g ON t.GenreId = g.GenreId 
LEFT JOIN Album a ON t.AlbumId = a.AlbumId 
LEFT JOIN Artist art ON a.ArtistId = art.ArtistId 
GROUP BY 1,2
ORDER BY 4 DESC;
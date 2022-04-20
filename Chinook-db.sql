-- Q1
-- The top 10 rock bands are shown below along with the number of songs each band has on record.

SELECT ar.ArtistId, ar.Name artist_name, COUNT(*) songs
FROM Artist ar
JOIN Album al
ON ar.ArtistId = al.ArtistId
JOIN Track t
ON t. AlbumId = al.AlbumId
JOIN Genre g
ON g.GenreId = t.GenreId
WHERE g.GenreId = 1
GROUP BY 2
ORDER BY 3 DESC
LIMIT 10;

Which Jazz band released most songs in US

SELECT ar.ArtistId, ar.Name artist_name, COUNT(*) songs, c.Country
FROM Artist ar
JOIN Album al
ON ar.ArtistId = al.ArtistId
JOIN Track t
ON t. AlbumId = al.AlbumId
JOIN Genre g
ON g.GenreId = t.GenreId
JOIN InvoiceLine il
ON il.TrackId = t.TrackId
JOIN Invoice i
ON i.InvoiceId = il.InvoiceId
JOIN Customer c
ON c.CustomerId = i.CustomerId
WHERE c.Country = "USA" AND g.GenreId = 2
GROUP BY 2
ORDER BY 3 DESC;


Which song is the most played per each brand

-- Q2
-- Use your query to return the email, first name, last name, and Genre of all Rock Music listeners (Rock & Roll would be considered a different category for this exercise). Return your list ordered alphabetically by email address starting with A.

SELECT c.Email, c.FirstName, c.LastName, g.Name genre_name 
FROM Customer c
JOIN Invoice i
ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il
ON i.InvoiceId = il.InvoiceId
JOIN Track t
ON t.TrackId = il.TrackId
JOIN Genre g
ON g.GenreId = t.GenreId
WHERE g.GenreId = 1
GROUP BY 1,2,3,4
ORDER BY 1;

-- Q3
-- Which countries have the most Invoices?
SELECT BillingCountry, COUNT(*) invoices
FROM Invoice
GROUP BY 1
ORDER BY 2 DESC;

-- Q3
-- Which city has the best customers?
SELECT BillingCity City_name, sum(total) Total_invoices
FROM Invoice
GROUP BY 1
ORDER BY 2 DESC;

-- Q4
-- Who is the best customer?
SELECT c.CustomerId, c.FirstName, c.LastName, sum(total) Total_invoices
FROM Customer c
JOIN Invoice i
ON i.CustomerId = c.CustomerId
GROUP BY 1,2,3
ORDER BY 4 DESC;

-- Q5
-- Find which artist has earned the most according to the InvoiceLines?

SELECT ar.Name, SUM(il.UnitPrice) AS amt_spent
FROM InvoiceLine il
JOIN Track t
ON il.TrackId = t.TrackId
JOIN Album al
ON t.AlbumId = AL.AlbumId
JOIN Artist ar
ON al.ArtistId = ar.ArtistId
GROUP BY 1
ORDER BY 2 DESC;

##OR##

SELECT ar.Name artist_name, sum(il.Quantity*il.UnitPrice) amt_spent
FROM Invoice i
JOIN InvoiceLine il
ON i.InvoiceId = il.InvoiceId
JOIN Track t
ON il.TrackId = t.TrackId
JOIN Customer c
ON i.CustomerId = c.CustomerId
JOIN Album al
ON t.AlbumId = al.AlbumId
JOIN Artist ar
ON al.ArtistId = ar.ArtistId
GROUP BY 1
ORDER by 2 DESC
Limit 10


-- Q6
-- the top purchasers are shown in the table below. The customer with the highest total invoice amount is customer 55, Mark Taylor.

SELECT c.CustomerId, c.FirstName, c.LastName, ar.Name, sum(il.Quantity*il.UnitPrice) AmountSpent
FROM Invoice i
JOIN InvoiceLine il
ON i.InvoiceId = il.InvoiceId
JOIN Track t
ON il.TrackId = t.TrackId
JOIN Customer c
ON i.CustomerId = c.CustomerId
JOIN Album al
ON t.AlbumId = al.AlbumId
JOIN Artist ar
ON al.ArtistId = ar.ArtistId
WHERE ar.Name = 'Iron Maiden'
GROUP BY 1,2,3,4
ORDER by 5 DESC;



Which track is the most played in each country.

-- Q8
-- track names that have a song length longer than the average song length

SELECT t.Name Track_name, t.Milliseconds, g.Name genre_name
FROM Track t
JOIN Genre g
ON t.GenreId = g.GenreId
WHERE t.Milliseconds > (SELECT AVG(Milliseconds) FROM Track)
ORDER BY 2 DESC;

Q1, Which sales agen has sold songs the least.

SELECT e.EmployeeId Rep_id, SUM(i.total) Total_amt
FROM Employee e
JOIN Customer c
ON c.SupportRepId = e.EmployeeId
JOIN Invoice i
ON i.CustomerId = c.CustomerId
GROUP BY 1
ORDER BY 2;

Top 5 albums purchsed in each country
WITH tab1 AS (
          SELECT al.AlbumId Album_Id, al.Title Album_title, c.country  country_name, count(i.InvoiceId) count_invoice
          FROM Artist ar
          JOIN Album al
          ON ar.ArtistId = al.ArtistId
		  JOIN Track t
		  ON al.AlbumId = t.AlbumId
          JOIN InvoiceLine il
          ON t.trackid = il.trackid
          JOIN Invoice i
          ON i.InvoiceId = il.InvoiceId
          JOIN Customer c
          ON c.CustomerId = i.CustomerId
          GROUP BY 1, 2, 3
          ORDER BY 2),

      tab2 AS (
           SELECT country_name, max(count_invoice) maximum
           FROM tab1
           GROUP BY 1)
SELECT tab1.count_invoice AS Purchases, tab1.country_name country, tab1.Album_title
FROM tab1
JOIN tab2
ON tab1.country_name = tab2.country_name AND tab1.count_invoice = tab2.maximum
ORDER BY 1 Desc
LIMIT 5;
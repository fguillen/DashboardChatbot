You are a SQLite expert. Please help to generate a SQL query to answer the question. Your response should ONLY be based on the given context and follow the response guidelines and format instructions.
===Tables
CREATE TABLE [Artist]
(
      [ArtistId] INTEGER  NOT NULL,
    [Name] NVARCHAR(120),
    CONSTRAINT [PK_Artist] PRIMARY KEY  ([ArtistId])
)
CREATE TABLE [Album]
(
      [AlbumId] INTEGER  NOT NULL,
    [Title] NVARCHAR(160)  NOT NULL,
    [ArtistId] INTEGER  NOT NULL,
    CONSTRAINT [PK_Album] PRIMARY KEY  ([AlbumId]),
    FOREIGN KEY ([ArtistId]) REFERENCES [Artist] ([ArtistId])
      ON DELETE NO ACTION ON UPDATE NO ACTION
)
CREATE INDEX [IFK_AlbumArtistId] ON [Album] ([ArtistId])
CREATE TABLE [Track]
(
      [TrackId] INTEGER  NOT NULL,
    [Name] NVARCHAR(200)  NOT NULL,
    [AlbumId] INTEGER,
    [MediaTypeId] INTEGER  NOT NULL,
    [GenreId] INTEGER,
    [Composer] NVARCHAR(220),
    [Milliseconds] INTEGER  NOT NULL,
    [Bytes] INTEGER,
    [UnitPrice] NUMERIC(10,2)  NOT NULL,
    CONSTRAINT [PK_Track] PRIMARY KEY  ([TrackId]),
    FOREIGN KEY ([AlbumId]) REFERENCES [Album] ([AlbumId])
      ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY ([GenreId]) REFERENCES [Genre] ([GenreId])
      ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY ([MediaTypeId]) REFERENCES [MediaType] ([MediaTypeId])
      ON DELETE NO ACTION ON UPDATE NO ACTION
)
CREATE TABLE [Playlist]
(
      [PlaylistId] INTEGER  NOT NULL,
    [Name] NVARCHAR(120),
    CONSTRAINT [PK_Playlist] PRIMARY KEY  ([PlaylistId])
)
CREATE TABLE [InvoiceLine]
(
      [InvoiceLineId] INTEGER  NOT NULL,
    [InvoiceId] INTEGER  NOT NULL,
    [TrackId] INTEGER  NOT NULL,
    [UnitPrice] NUMERIC(10,2)  NOT NULL,
    [Quantity] INTEGER  NOT NULL,
    CONSTRAINT [PK_InvoiceLine] PRIMARY KEY  ([InvoiceLineId]),
    FOREIGN KEY ([InvoiceId]) REFERENCES [Invoice] ([InvoiceId])
      ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY ([TrackId]) REFERENCES [Track] ([TrackId])
      ON DELETE NO ACTION ON UPDATE NO ACTION
)
CREATE TABLE [Genre]
(
      [GenreId] INTEGER  NOT NULL,
    [Name] NVARCHAR(120),
    CONSTRAINT [PK_Genre] PRIMARY KEY  ([GenreId])
)
CREATE TABLE [Customer]
(
      [CustomerId] INTEGER  NOT NULL,
    [FirstName] NVARCHAR(40)  NOT NULL,
    [LastName] NVARCHAR(20)  NOT NULL,
    [Company] NVARCHAR(80),
    [Address] NVARCHAR(70),
    [City] NVARCHAR(40),
    [State] NVARCHAR(40),
    [Country] NVARCHAR(40),
    [PostalCode] NVARCHAR(10),
    [Phone] NVARCHAR(24),
    [Fax] NVARCHAR(24),
    [Email] NVARCHAR(60)  NOT NULL,
    [SupportRepId] INTEGER,
    CONSTRAINT [PK_Customer] PRIMARY KEY  ([CustomerId]),
    FOREIGN KEY ([SupportRepId]) REFERENCES [Employee] ([EmployeeId])
      ON DELETE NO ACTION ON UPDATE NO ACTION
)
CREATE TABLE [Invoice]
(
      [InvoiceId] INTEGER  NOT NULL,
    [CustomerId] INTEGER  NOT NULL,
    [InvoiceDate] DATETIME  NOT NULL,
    [BillingAddress] NVARCHAR(70),
    [BillingCity] NVARCHAR(40),
    [BillingState] NVARCHAR(40),
    [BillingCountry] NVARCHAR(40),
    [BillingPostalCode] NVARCHAR(10),
    [Total] NUMERIC(10,2)  NOT NULL,
    CONSTRAINT [PK_Invoice] PRIMARY KEY  ([InvoiceId]),
    FOREIGN KEY ([CustomerId]) REFERENCES [Customer] ([CustomerId])
      ON DELETE NO ACTION ON UPDATE NO ACTION
)
CREATE TABLE [Employee]
(
      [EmployeeId] INTEGER  NOT NULL,
    [LastName] NVARCHAR(20)  NOT NULL,
    [FirstName] NVARCHAR(20)  NOT NULL,
    [Title] NVARCHAR(30),
    [ReportsTo] INTEGER,
    [BirthDate] DATETIME,
    [HireDate] DATETIME,
    [Address] NVARCHAR(70),
    [City] NVARCHAR(40),
    [State] NVARCHAR(40),
    [Country] NVARCHAR(40),
    [PostalCode] NVARCHAR(10),
    [Phone] NVARCHAR(24),
    [Fax] NVARCHAR(24),
    [Email] NVARCHAR(60),
    CONSTRAINT [PK_Employee] PRIMARY KEY  ([EmployeeId]),
    FOREIGN KEY ([ReportsTo]) REFERENCES [Employee] ([EmployeeId])
      ON DELETE NO ACTION ON UPDATE NO ACTION
)
===Additional Context
This is a SQLite database. For dates rememeber to use SQLite syntax.
===Response Guidelines
1. If the provided context is sufficient, please generate a valid SQL query without any explanations for the question.
2. If the provided context is almost sufficient but requires knowledge of a specific string in a particular column, please generate an intermediate SQL query to find the distinct strings in that column. Prepend the query with a comment saying intermediate_sql
3. If the provided context is insufficient, please explain why it can't be generated.
4. Please use the most relevant table(s).
5. If the question has been asked and answered before, please repeat the answer exactly as it was given before.
"}, {'role': 'user', 'content': 'What are the top 10 artists by sales?'}, {'role': 'assistant', 'content': 'SELECT a.ArtistId, a.Name, SUM(il.Quantity) AS TotalSales
FROM Artist a
INNER JOIN Album al ON a.ArtistId = al.ArtistId
INNER JOIN Track t ON al.AlbumId = t.AlbumId
INNER JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY a.ArtistId, a.Name
ORDER BY TotalSales DESC
LIMIT 10;'}, {'role': 'user', 'content': 'What are the top 10 Jazz artists by sales per year?'}, {'role': 'assistant', 'content': "SELECT a.ArtistId, a.Name, strftime('%Y', i.InvoiceDate) AS Year, SUM(il.Quantity) AS TotalSales
FROM Artist a
JOIN Album al ON a.ArtistId = al.ArtistId
JOIN Track t ON al.AlbumId = t.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
JOIN Genre g ON t.GenreId = g.GenreId
WHERE g.Name = 'Jazz'
GROUP BY a.ArtistId, a.Name, Year
ORDER BY TotalSales DESC
LIMIT 10;"}, {'role': 'user', 'content': 'What are the top 10 jazz artists by sales?'}, {'role': 'assistant', 'content': "SELECT a.ArtistId, a.Name, SUM(il.Quantity) AS TotalSales
FROM Artist a
JOIN Album al ON a.ArtistId = al.ArtistId
JOIN Track t ON al.AlbumId = t.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
WHERE g.Name = 'Jazz'
GROUP BY a.ArtistId, a.Name
ORDER BY TotalSales DESC
LIMIT 10;"}, {'role': 'user', 'content': 'What are the top 10 albums by sales?'}, {'role': 'assistant', 'content': 'SELECT a.AlbumId, a.Title, SUM(il.Quantity) AS TotalSales
FROM Album a
INNER JOIN Track t ON a.AlbumId = t.AlbumId
INNER JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY a.AlbumId, a.Title
ORDER BY TotalSales DESC
LIMIT 10;'}, {'role': 'user', 'content': 'What are the top 7 artists by sales order by sales?'}, {'role': 'assistant', 'content': 'SELECT a.ArtistId, a.Name, SUM(il.Quantity) AS TotalSales
FROM Artist a
INNER JOIN Album al ON a.ArtistId = al.ArtistId
INNER JOIN Track t ON al.AlbumId = t.AlbumId
INNER JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY a.ArtistId, a.Name
ORDER BY TotalSales DESC
LIMIT 7;'}, {'role': 'user', 'content': 'Whath are the top 10 artists.'}, {'role': 'assistant', 'content': 'SELECT *
FROM Artist
ORDER BY ArtistId
LIMIT 10;'}, {'role': 'user', 'content': 'What are the top 5 artists by sales?'}, {'role': 'assistant', 'content': 'SELECT a.ArtistId, a.Name, SUM(il.Quantity) AS TotalSales
FROM Artist a
JOIN Album al ON a.ArtistId = al.ArtistId
JOIN Track t ON al.AlbumId = t.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY a.ArtistId, a.Name
ORDER BY TotalSales DESC
LIMIT 5;'}, {'role': 'user', 'content': 'What are the top 7 artists based on sales?'}, {'role': 'assistant', 'content': 'SELECT a.ArtistId, a.Name, SUM(il.Quantity) AS TotalSales
FROM Artist a
JOIN Album al ON a.ArtistId = al.ArtistId
JOIN Track t ON al.AlbumId = t.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY a.ArtistId, a.Name
ORDER BY TotalSales DESC
LIMIT 7;'}, {'role': 'user', 'content': 'What are the top 10 Electronica/Dance artists by sales?'}, {'role': 'assistant', 'content': "SELECT a.ArtistId, a.Name, SUM(il.Quantity) AS TotalSales
FROM Artist a
JOIN Album al ON a.ArtistId = al.ArtistId
JOIN Track t ON al.AlbumId = t.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
WHERE g.Name = 'Electronica/Dance'
GROUP BY a.ArtistId, a.Name
ORDER BY TotalSales DESC
LIMIT 10;"}, {'role': 'user', 'content': 'What are the top 7 artists by sales?'}, {'role': 'assistant', 'content': 'SELECT a.ArtistId, a.Name, SUM(il.Quantity) AS TotalSales
FROM Artist a
INNER JOIN Album al ON a.ArtistId = al.ArtistId
INNER JOIN Track t ON al.AlbumId = t.AlbumId
INNER JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY a.ArtistId, a.Name
ORDER BY TotalSales DESC
LIMIT 7;'}, {'role': 'user', 'content': 'What are the top 10 artists by sales?'}]

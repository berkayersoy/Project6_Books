CREATE DATABASE books_project;

USE books_project;

CREATE TABLE books (
   bookID INT PRIMARY KEY,
   title VARCHAR(400),
   average_rating DECIMAL(3,2),
   num_pages INT,
   ratings_count INT,
   text_reviews_count INT,
   publication_date DATE,
   lang VARCHAR(255)
);

CREATE TABLE genres (
  genreID INT AUTO_INCREMENT PRIMARY KEY,
  genre_name VARCHAR(255)
);

CREATE TABLE book_genres (
  bookID INT,
  genreID INT,
  FOREIGN KEY (bookID) REFERENCES books(bookID),
  FOREIGN KEY (genreID) REFERENCES genres(genreID)
);

CREATE TABLE authors (
  authorID INT AUTO_INCREMENT PRIMARY KEY,
  author_name VARCHAR(255)
);

CREATE TABLE book_authors (
  bookID INT,
  authorID INT,
  FOREIGN KEY (bookID) REFERENCES books(bookID),
  FOREIGN KEY (authorID) REFERENCES authors(authorID)
);

CREATE TABLE publishers (
  publisherID INT AUTO_INCREMENT PRIMARY KEY,
  publisher_name VARCHAR(255)
);

CREATE TABLE book_publishers (
  bookID INT,
  publisherID INT,
  FOREIGN KEY (bookID) REFERENCES books(bookID),
  FOREIGN KEY (publisherID) REFERENCES publishers(publisherID)
);



# Inserting author_name to authors table from the staging table.
INSERT INTO authors (author_name)
SELECT DISTINCT author
FROM staging_books;

# Inserting publisher_name to publishers table from the staging table.
INSERT INTO publishers (publisher_name)
SELECT DISTINCT publisher
FROM staging_books;

# Inserting genre_name to genres table from the staging table.
INSERT INTO genres (genre_name)
SELECT DISTINCT genre
FROM staging_books;

# Needed to fix the "language" name because it is a reversed keyword in MySQL.
ALTER TABLE staging_books RENAME COLUMN language TO lang;
SET SQL_SAFE_UPDATES = 0;
# Updating the date format before inserting so it will not cause errors.
UPDATE staging_books SET publication_date = STR_TO_DATE(publication_date, '%d-%m-%Y');

# Inserting the data to books table.
INSERT INTO books (bookID, title, average_rating, num_pages, ratings_count, text_reviews_count, publication_date, lang)
SELECT bookID, title, average_rating, num_pages, ratings_count, text_reviews_count, publication_date, lang
FROM staging_books;

# Filling book_publishers table.
INSERT INTO book_publishers (bookID, publisherID)
SELECT books.bookID, publishers.publisherID
FROM books
INNER JOIN staging_books ON books.bookID = staging_books.bookID
INNER JOIN publishers ON publishers.publisher_name = staging_books.publisher;

# Filling book_genres table.
INSERT INTO book_genres (bookID, genreID)
SELECT books.bookID, genres.genreID
FROM books
INNER JOIN staging_books ON books.bookID = staging_books.bookID
INNER JOIN genres ON genres.genre_name = staging_books.genre;

# Filling book_authors table.
INSERT INTO book_authors (bookID, authorID)
SELECT books.bookID, authors.authorID
FROM books
INNER JOIN staging_books ON books.bookID = staging_books.bookID
INNER JOIN authors ON authors.author_name = staging_books.author;








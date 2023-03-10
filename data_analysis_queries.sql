USE books_project;

# Books with most pages.
SELECT bookID, title, num_pages FROM books
ORDER BY num_pages DESC
LIMIT 10;

# Who wrote the most books ?
SELECT COUNT(title) AS book_count, author_name 
FROM books b
	INNER JOIN book_authors ba ON b.bookID=ba.bookID
	INNER JOIN authors a ON ba.authorID=a.authorID
GROUP BY a.author_name
ORDER BY book_count DESC;

# How many books without a genre are there ?
SELECT COUNT(genre_name) AS books_without_genre
FROM genres g
	INNER JOIN book_genres bg ON g.genreID=bg.genreID
	INNER JOIN books b ON b.bookID=bg.bookID
WHERE genre_name="blank";

# Percentage of books without genre in the dataset ?
SELECT ROUND(COUNT(genre_name)*100/(SELECT COUNT(*) FROM books),2) AS books_without_genre
FROM genres g
	INNER JOIN book_genres bg ON g.genreID=bg.genreID
	INNER JOIN books b ON b.bookID=bg.bookID
WHERE genre_name="blank";

# Favorite genre of authors.
SELECT author_name, genre_name, book_count
FROM (
  SELECT author_name, genre_name, COUNT(b.bookID) AS book_count,
    ROW_NUMBER() OVER (PARTITION BY author_name ORDER BY COUNT(b.bookID) DESC) AS genre_rank
  FROM books b
  INNER JOIN book_authors ba ON b.bookID=ba.bookID
  INNER JOIN authors a ON ba.authorID=a.authorID
  INNER JOIN book_genres bg ON b.bookID=bg.bookID
  INNER JOIN genres g ON bg.genreID=g.genreID
  GROUP BY author_name, genre_name
) AS subquery
WHERE genre_rank <=1
ORDER BY author_name, book_count DESC;












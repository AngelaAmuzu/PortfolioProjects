



--Ranking the top 10 movies by amount

SELECT TOP 10 Rank,Title,LifetimeGross,year
FROM MoviesProject..[Top 200 Highest by Amount]


--Ranking by the year from most recent in 5 years

SELECT TOP 10 year,rank,Title,LifetimeGross
FROM MoviesProject..[Top 200 Highest by year]
order by year desc

--The year with most amount 

SELECT TOP 10 Rank,Title,year, max(LifetimeGross) as Highestgrossamount
FROM MoviesProject..[Top 200 Highest by Amount]
group by rank, title, year 
order by Highestgrossamount desc



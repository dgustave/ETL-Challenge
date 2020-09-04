
select * from salaries;
select * from league;
select * from goals;
select * from expected;
select * from mvp;
select * from stats;
select * from player_stats;
select * from team_names;

select * from salaries
where first = 'Jonathan' and last = 'dos Santos'

select first, last from stats
where first = 'Brenden';

select "id", "Club" from league
where "id" = 14

-- Top 10 highest paid players in the MLS
select club_id, first, last, club, round(guaranteed_compensation::decimal,2) as guaranteed from salaries
order by guaranteed_compensation DESC
limit 10;

-- Average player salary by club

CREATE VIEW mean_salary_correct as 
select club_id, club, round(avg(guaranteed_compensation)::decimal,2) as "Mean Salary" 
from salaries
group by club_id, club;

select * from mean_salary_correct

-- Avg, Min, Max
CREATE VIEW club_salary_measures as
select club_id, club, round(min(guaranteed_compensation)::decimal,2) as "Min Salary", round(avg(guaranteed_compensation)::decimal,2) as "Mean Salary", round(max(guaranteed_compensation)::decimal,2) as "Max Salary"
from salaries
group by club_id, club;

select * from club_salary_measures

-- Highest salaries in each club
CREATE VIEW highest_paid_player_by_club as
select id, club_id, club, first, last, guaranteed_compensation from salaries 
	where guaranteed_compensation in (select max(guaranteed_compensation) from salaries group by club);
-- for new table view: need to figure out why there are two max values for LA Galaxy
select * from highest_paid_player_by_club

-- Highest salaries in each club, sorted from greatest to least salary (still includes two data points for LA Galaxy)
CREATE VIEW sorted_highest_paid_player_by_club as
select * from highest_paid_player_by_club
order by guaranteed_compensation DESC;

select * from sorted_highest_paid_player_by_club

-- Salaries table ordered by TOTAL salary amount spent on players by club in descending order
CREATE VIEW team_payroll as

select club_id, club, round(sum(guaranteed_compensation::decimal),2) as "Roster Payroll"
from salaries
group by club_id, club
order by round(sum(guaranteed_compensation::decimal),2) DESC;

select * from team_payroll

-- Wins percentage by Club (Which teams underachieved/overachieved?); Issue: cannot round the decimals, ADD: goals for, total salary
-- -- winning percentage calculation: https://en.wikipedia.org/wiki/Winning_percentage#:~:text=In%20sports%2C%20a%20winning%20percentage,wins%20plus%20draws%20plus%20losses).
CREATE VIEW percent_wins as
select "id", "Club", round(((("Wins")/("Wins"+("Draws"*.5)+"Losses"))::decimal),3) as "% Wins" from league
order by "Wins" DESC;

select * from percent_wins

-- Players with most goals (need to query with salary)

CREATE VIEW player_goals as
select club_id, club, first, last, sum(goals) as "Total Goals"
from stats
group by club_id, club, first, last
order by sum(goals) DESC;

select * from player_goals

-- Average goals scored per game by club
select l."Club", round(((g."Goals_For"/l."Matches_Played")::decimal),2) as "Goals Per Game"
from goals as g, league as l
where g."id" = l."id"
order by "Goals Per Game" DESC

-- Averge goals scored against per game by club
select l."Club", round(((g."Goals_Against"/l."Matches_Played")::decimal),2) as "Goals Against Per Game"
from goals as g, league as l
where g."id" = l."id"
order by "Goals Against Per Game" DESC

-- goals scored by player and salary of player
-- we do not have a player id, so we needed to match by first and last name. This resulted in loss of player data because first and last
------names from both tables did not match exactly ie. names with accents

-- this query uses the player_stats table, where accents in first and last name are removed: 544 total players, missing 80 players
-- we believe the discrepancy in number of players is a result of our source data not matching where we scraped player stats and salaries
CREATE VIEW performance_salary as
select s.club_id, s.club, s.first, s.last, s.position, s.mp, s.minutes, s.assists, s.goals as "total_goals", round((m.guaranteed_compensation::decimal),2) as "salary"
from player_stats as s, salaries as m
where s.first = m.first and s.last = m.last
group by s.club_id, s.club, s.first, s.last, s.position, s.mp, s.minutes, s.assists, s.goals, m.guaranteed_compensation
order by "total_goals" DESC;

select * from performance_salary

-- this query uses stats table, where accents in first and last names yields 476 total players, missing 147 players
select g.club_id, g.club, g.first, g.last, g."Total Goals", round((s.guaranteed_compensation::decimal),2) as "Salary"
from player_goals as g, salaries as s
where g.first = s.first and g.last = s.last
group by g.club_id, g.club, g.first, g.last, g."Total Goals", s.guaranteed_compensation
order by  g."Total Goals" DESC;

-- query for unique names of players in stats table: 623 players
select distinct first, last from stats order by last ASC;
--query for unique names of players from player stats table: 623 players
select distinct first, last from player_stats order by last ASC;

-- Further queries to consider: 
-- -- combine one table with summary of the views created
-- -- table for goals against to compare salary and defense players with high salary

CREATE VIEW club_summary_stats_v2 as
select p.club_id, p.club, g."Goals_For", g."Goals_Against",  c."Min Salary", c."Mean Salary", c."Max Salary", p."Roster Payroll", w."% Wins" as "Wins (%)"
from team_payroll as p, percent_wins as w, goals as g, club_salary_measures as c, mean_salary_correct as m
where p.club_id=w.id and g."id"=p.club_id and m.club_id = p.club_id and c.club_id=p.club_id
order by p."Roster Payroll" DESC;

select * from club_summary_stats_v2


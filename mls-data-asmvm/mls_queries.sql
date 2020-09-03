
select * from salaries;
select * from league;
select * from goals;
select * from expected;
select * from mvp;
select * from stats;
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

-- Average goals scored per game by club
select l."Club", round(((g."Goals_For"/l."Matches_Played")::decimal),2) as "Goals Per Game"
from goals as g, league as l
where g."id" = l."id"
order by "Goals Per Game" DESC

-- Further queries to consider: 
-- -- combine one table with summary of the views created
-- -- table for goals against to compare salary and defense players with high salary






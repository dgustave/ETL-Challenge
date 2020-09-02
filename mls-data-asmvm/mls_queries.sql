
select * from salaries;
select * from league;
select * from goals;
select * from expected;
select * from mvp;
select * from stats;
select * from team_names;

select first, last from stats
where first = 'Brenden';

select "id", "Club" from league
where "id" = 14

-- Top 10 highest paid players in the MLS
select club_id, first, last, club, cast(round(guaranteed_compensation)as float) as guaranteed from salaries
order by guaranteed_compensation DESC
limit 10;

-- Salaries table ordered by total salary amount spent on players by club in descending order
CREATE VIEW team_payroll as
select club_id, club, round(sum(guaranteed_compensation::decimal),2) as "Roster Payroll"
from salaries
group by club_id, club
order by round(sum(guaranteed_compensation::decimal),2) DESC;


-- Wins percentage by Club (Which teams underachieved/overachieved?); Issue: cannot round the decimals, ADD: goals for, total salary
-- -- winning percentage calculation: https://en.wikipedia.org/wiki/Winning_percentage#:~:text=In%20sports%2C%20a%20winning%20percentage,wins%20plus%20draws%20plus%20losses).
CREATE VIEW percent_wins as
select "id", "Club", round(((("Wins")/("Wins"+("Draws"*.5)+"Losses"))::decimal),3) as "% Wins" from league
order by "Wins" DESC;

-- Players with most goals (need to query with salary)

DROP VIEW player_goals

CREATE VIEW player_goals as
select club_id, club, first, last, sum(goals) as "Total Goals"
from stats
group by club_id, club, first, last
order by sum(goals) DESC;

select * from player_goals



select p.club_id, p.club, p.first, p.last, p.goals, s.guaranteed_compensation 
from player_goals as p, salaries as s
where p.club_id = s.club_id;



-- Club with players earning over $1M and worst record (need to query league table and salary table)

select "Club", "Wins"/("Wins"+"Draws"+"Losses") from league as "Pct Wins"
order by "Wins" DESC;



select round(1/3,2) from salaries;

SELECT
    first_name,
    last_name,
    ROUND( AVG( amount ), 2 ) avg_rental



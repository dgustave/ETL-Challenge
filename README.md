## Local Data ETL

### Instructions

* Create a `mls_db` database in dbeaver/postgres then create the following two tables within:

  * A `premise` table that contains the columns `id`, `premise_name` and `county_id`.

  * A `county` table that contains the columns `id`, `county_name`, `license_count` and `county_id`.

  * Be sure to assign a primary key, as Pandas will not be able to do so.

* In Jupyter Notebook perform all ETL.

* **Extraction**

  * Webscraping into a pandas DataFrame:
  https://mlsplayers.org/resources/salary-guide - Player Salaries 2019
  https://fbref.com/en/comps/22/2798/2019-Major-League-Soccer-Stats Team Stats 2019 

* **Transform**

  * Copy only the columns needed into a new DataFrame.

  * Rename columns to fit the tables created in the database.

  * Handle any duplicates. **HINT:** In players salary, players have different names but teams are unique.

  * Set index to the previously created primary key, which will be ['Club'].

* **Load**

  * Create a connection to database.

  * Check for a successful connection to the database and confirm that the tables have been created.

  * Append DataFrames to tables. Be sure to use the index set earlier.

* Confirm successful **Load** by querying database.

    * Combine the two tables "Eastern" and "Western" . 
    * Join the two tables select the `Ranking', 'Squad', 'Club', 'Matches Played', 'Wins', 'Draws', 'Losses', and 'Total Points' from the 
      '2019 Major League Soccer' Stats table and `Club Salary` from the `2019 Average Club Salary` table. Club will be the joining point. 

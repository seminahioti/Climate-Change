--  Step 1: Understanding the data by watching what our table contains. 
SELECT * 
FROM state_climate
LIMIT 10;

-- Step 2: Let’s start by looking at how the average temperature changes over time in each state. Write a query that returns the state, year, tempf or tempc, and running_avg_temp (in either Celsius or Fahrenheit) for each state. (The running_avg_temp should use a window function.)
SELECT
  state,
  year,
  tempf,
  tempc,
  AVG(tempc) OVER 
  (
    PARTITION BY state
    ORDER BY year
  ) AS 'running_avg_temp'
FROM state_climate
LIMIT 10;

/* We could have the same code with ROUNDING to the second decimal place. 
SELECT
  state,
  year,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1,
  ROUND(AVG(tempc) OVER
  (
    PARTITION BY state
    ORDER BY year
  ),2) AS 'running_avg_temp'
FROM state_climate
WHERE state = 'Alabama'
LIMIT 10 ; */

-- Step 3: Now let’s explore the lowest temperatures for each state. Write a query that returns state, year, tempf or tempc, and the lowest temperature (lowest_temp) for each state.
SELECT
  state,
  year,
  tempf,
  tempc,
  FIRST_VALUE(tempc) OVER
  (
    PARTITION BY state
    ORDER BY tempc
  ) AS lowest_temp
FROM state_climate
LIMIT 10; 

-- Step 4: Like before, write a query that returns state, year, tempf or tempc, except now we will also return the highest temperature (highest_temp) for each state. Are the highest recorded temps for each state more recent or more historic?
SELECT
  state,
  year,
  tempf,
  tempc,
  LAST_VALUE(tempc) OVER
  (
    PARTITION BY state
    ORDER BY tempc
    RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS highest_temp
FROM state_climate
LIMIT 10;

-- Step 5: Let’s see how temperature has changed each year in each state. Write a query to select the same columns but now you should write a window function that returns the change_in_temp from the previous year (no null values should be returned). Which states and years saw the largest changes in temperature? Is there a particular part of the United States that saw the largest yearly changes in temperature?
SELECT
  state,
  year,
  tempf,
  tempc,
  LAG(tempc, 1, 0) OVER 
  (
    PARTITION BY state
    ORDER BY year
  ) AS change_in_temp
FROM state_climate
ORDER BY change_in_temp DESC
LIMIT 10;

-- Step 6: Write a query to return a rank of the coldest temperatures on record (coldest_rank) along with year, state, and tempf or tempc. Are the coldest ranked years recent or historic? The coldest years should be from any state or year.
SELECT
  RANK() OVER 
  (
    ORDER BY tempc
  ) AS rank,
  state,
  year,
  tempf,
  tempc
FROM state_climate
LIMIT 10;

-- Step 7: Modify your coldest_rank query to now instead return the warmest_rank for each state, meaning your query should return the warmest temp/year for each state. Again, are the warmest temperatures more recent or historic for each state?
SELECT
  RANK() OVER 
  (
    PARTITION BY state
    ORDER BY tempc DESC
  ) AS rank,
  state,
  year,
  tempf,
  tempc
FROM state_climate
LIMIT 10;

-- Step 8: Let’s now write a query that will return the average yearly temperatures in quartiles instead of in rankings for each state. Your query should return quartile, year, state and tempf or tempc. The top quartile should be the coldest years. Are the coldest years more recent or historic?
SELECT
  NTILE(4) OVER 
  (
    PARTITION BY state
    ORDER BY tempc
  ) AS quartile,
  state,
  year,
  tempf,
  tempc
FROM state_climate
LIMIT 10;

-- Step 9: Lastly, we will write a query that will return the average yearly temperatures in quintiles (5). Your query should return quintile, year, state and tempf or tempc. The top quintile should be the coldest years overall, not by state. What is different about the coldest quintile now?
SELECT
  NTILE(5) OVER 
  (
    ORDER BY tempc
  ) AS quintile,
  year,
  state,
  tempf,
  tempc
FROM state_climate
LIMIT 10;
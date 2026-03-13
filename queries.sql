select count(*) from dataset;
select * from dataset;


-- 1. What is the average sleep duration, screen time, and stress level across all users?
select avg(sleep_duration_hours), 
avg(daily_screen_time_hours), 
avg(stress_level)
from dataset;

-- 2. Which occupation group has the highest average stress level?
select occupation, avg(stress_level)
from dataset
group by occupation
order by avg(stress_level) desc limit 1;

-- 3. How does average sleep duration vary across different occupations?
select occupation, avg(sleep_duration_hours)
from dataset
group by occupation
order by avg(sleep_duration_hours) desc;

-- 4. Do people with higher daily screen time tend to have lower sleep quality scores?
SELECT 
    AVG(daily_screen_time_hours) AS avg_screen_time,
    AVG(sleep_quality_score) AS avg_sleep_quality
FROM dataset;

-- 5. What is the relationship between caffeine intake and average sleep duration?
select caffeine_intake_cups, avg(sleep_duration_hours)
from dataset
group by caffeine_intake_cups;

-- 6. Which age group experiences the highest average stress levels?
ALTER TABLE dataset
ADD COLUMN age_group VARCHAR(20);

UPDATE dataset
SET age_group =
CASE
    WHEN age < 20 THEN 'Teen'
    WHEN age BETWEEN 20 AND 29 THEN '20s'
    WHEN age BETWEEN 30 AND 39 THEN '30s'
    WHEN age BETWEEN 40 AND 49 THEN '40s'
    WHEN age BETWEEN 50 AND 59 THEN '50s'
    ELSE '60+'
END;

select age_group, avg(stress_level)
from dataset
group by age_group
order by avg(stress_level) desc;

-- 7. Does higher physical activity reduce stress levels on average?
ALTER TABLE dataset
ADD COLUMN activity_level VARCHAR(20);

UPDATE dataset
SET activity_level =
CASE
    WHEN physical_activity_minutes < 30 THEN 'Low Activity'
    WHEN physical_activity_minutes BETWEEN 30 AND 60 THEN 'Moderate Activity'
    WHEN physical_activity_minutes BETWEEN 61 AND 120 THEN 'Active'
    ELSE 'Highly Active'
END;

select activity_level, avg(stress_level)
from dataset
group by activity_level;

-- 8. How do notification counts per day impact users' stress levels?
ALTER TABLE dataset
ADD COLUMN notification_level VARCHAR(200);

UPDATE dataset
SET notification_level =
CASE
    WHEN notifications_received_per_day < 50 THEN 'Low Notifications'
    WHEN notifications_received_per_day BETWEEN 50 AND 100 THEN 'Moderate Notifications'
    WHEN notifications_received_per_day BETWEEN 101 AND 200 THEN 'High Notifications'
    ELSE 'Very High Notifications'
END;

select notification_level, avg(stress_level)
from dataset
group by notification_level;

-- 9. Which gender reports higher average sleep quality and lower stress levels?
SELECT 
gender,
AVG(sleep_quality_score) AS avg_sleep_quality,
AVG(stress_level) AS avg_stress
FROM dataset
GROUP BY gender;

-- 10. What are the top 10 users with the highest screen time and how does it affect their sleep duration?
select user_id,daily_screen_time_hours, sleep_duration_hours
from dataset
order by daily_screen_time_hours desc 
limit 10;

-- 11. Is there a correlation between late-night phone usage and reduced sleep duration?
select sleep_category, avg(phone_usage_before_sleep_minutes)
from dataset
group by sleep_category;

-- 12. Which combination of occupation and gender shows the highest average stress level?
select gender, occupation, avg(stress_level)
from dataset
group by gender, occupation
order by avg(stress_level) desc;

-- 13. What percentage of users sleep less than the recommended 7 hours per night?
SELECT 
COUNT(user_id)*100.0 / (SELECT COUNT(user_id) FROM dataset) AS percent_sleep_less_than_7
FROM dataset
WHERE sleep_duration_hours < 7;

-- 14. Do users with higher physical activity levels report better sleep quality scores?
select activity_level, avg(sleep_quality_score)
from dataset
group by activity_level;

-- 15. Which lifestyle factor (screen time, caffeine intake, notifications, or physical activity) has the strongest association with higher stress levels?
SELECT
CORR(daily_screen_time_hours, stress_level) AS screen_time_stress_corr,
CORR(caffeine_intake_cups, stress_level) AS caffeine_stress_corr,
CORR(notifications_received_per_day, stress_level) AS notifications_stress_corr,
CORR(physical_activity_minutes, stress_level) AS activity_stress_corr
FROM dataset;

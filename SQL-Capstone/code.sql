--1.1 Get familiar with the company

SELECT COUNT(DISTINCT utm_campaign) 
  AS 'Number of Campaign'
FROM page_visits;

SELECT COUNT(DISTINCT utm_source)
   AS 'Number of Sources'
FROM page_visits;

SELECT DISTINCT utm_campaign, utm_source 
FROM page_visits;


-- 1.2 What pages on their website?
SELECT DISTINCT page_name AS 'Page Names'
FROM page_visits;


--2.1 What is the user journey - first touches
WITH first_touch AS (  -- set of all first touch
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY 1),
ft_attr AS (   --set of all first touch with additon colums
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_campaign AS Campaign,
       ft_attr.utm_source AS Source,
       COUNT(*) AS Counts
FROM ft_attr
GROUP BY 1
order by 3 DESC;

-- 2.2 User Journey - last touches
WITH last_touch AS (  -- set of all last touch
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY 1),
lt_attr AS ( --set of all last touch with additon colums
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_campaign AS Campaign,
       lt_attr.utm_source AS Source,
       COUNT(*) AS Counts
FROM lt_attr
GROUP BY 1
order by 3 DESC;


--2.3 How many visitors make a purchase? 
SELECT COUNT(DISTINCT user_id) AS 'Total Visitors'
FROM page_visits;
  
SELECT COUNT(DISTINCT user_id) AS 'Number of Vistors Who Purchased'
FROM page_visits
WHERE page_name = '4 - purchase';


-- 2.4 User journey - how many last touches on the purchase page

WITH last_touch AS (  -- set of all last touch
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY 1),
lt_attr AS ( --set of all last touch with additon colums
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_campaign AS Campaign,
       lt_attr.utm_source AS Source,
       COUNT(*) AS Counts
FROM lt_attr
GROUP BY 1
order by 3 DESC; 


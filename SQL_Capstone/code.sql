
/*
Campaigns and Sources
*/

SELECT count(DISTINCT utm_campaign) as campain_count
FROM page_visits;

SELECT count(DISTINCT utm_source) as source_count
FROM page_visits;

SELECT utm_campaign, utm_source 
FROM page_visits
GROUP BY utm_campaign;

SELECT DISTINCT page_name
FROM page_visits;

/* 
How many first touches is each campaign responsible for?
*/

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
first_touch_sandc AS (
	SELECT ftouch.user_id,
  			ftouch.first_touch_at,
  			pvisit.utm_source,
  			pvisit.utm_campaign
  FROM first_touch AS ftouch
  JOIN page_visits AS pvisit
  ON ftouch.user_id = pvisit.user_id
  AND ftouch.first_touch_at = pvisit.timestamp
)
SELECT first_touch_sandc.utm_source as 'Source',
       first_touch_sandc.utm_campaign as 'Campaign',
       COUNT(*) as 'Count'
FROM first_touch_sandc
GROUP BY 1, 2
ORDER BY 3 DESC;
;


/* 
How many last touches is each campaign responsible for?
*/

WITH last_touch AS (
    SELECT user_id,
          MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
last_touch_sandc AS (
	SELECT ltouch.user_id,
  			ltouch.last_touch_at,
  			pvisit.utm_source,
  			pvisit.utm_campaign
  FROM last_touch AS ltouch
  JOIN page_visits AS pvisit
  ON ltouch.user_id = pvisit.user_id
  AND ltouch.last_touch_at = pvisit.timestamp
)
SELECT last_touch_sandc.utm_source as 'Source',
       last_touch_sandc.utm_campaign as 'Campaign',
       COUNT(*) as 'Count'
FROM last_touch_sandc
GROUP BY 1, 2
ORDER BY 3 DESC;



/* 
How many make a purchase?
*/

SELECT COUNT(DISTINCT user_id) as Purchasers
FROM page_visits
WHERE page_name is '4 - purchase';

/*
How many last touch purchases is each campaign responsible for?
*/

WITH last_touch AS (
    SELECT user_id,
          MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
last_touch_sandc AS (
	SELECT ltouch.user_id,
  			ltouch.last_touch_at,
  			pvisit.utm_source,
  			pvisit.utm_campaign,
  			pvisit.page_name
  FROM last_touch AS ltouch
  JOIN page_visits AS pvisit
  ON ltouch.user_id = pvisit.user_id
  AND ltouch.last_touch_at = pvisit.timestamp
)
SELECT last_touch_sandc.utm_source as 'Source',
       last_touch_sandc.utm_campaign as 'Campaign',
       COUNT(*) as 'Count'
FROM last_touch_sandc
WHERE last_touch_sandc.page_name is '4 - purchase'
GROUP BY 1, 2
ORDER BY 3 DESC;
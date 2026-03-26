INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-01','yandex','cpc','freemium',103,2230362,103,25,1654810),
	 ('2023-06-01','yandex','cpc','prof-frontend',78,4456764,78,12,1057000),
	 ('2023-06-01','yandex','cpc','prof-python',62,2047612,62,7,613196),
	 ('2023-06-01','yandex','cpc','base-python',31,388244,31,7,476021),
	 ('2023-06-01','vk','cpc','prof-python',71,146016,40,5,355564),
	 ('2023-06-01','vk','cpc','freemium-frontend',80,252800,43,5,338083),
	 ('2023-06-01','yandex','cpc','prof-java',49,1445010,49,4,284590),
	 ('2023-06-01','yandex','cpc','base-frontend',40,722440,40,3,268515),
	 ('2023-06-01','vk','cpc','prof-java',51,158865,23,2,232726),
	 ('2023-06-01','yandex','cpc','prof-data-analytics',14,141204,14,2,220264);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-01','yandex','cpc','prof-professions-brand',13,62634,13,3,154287),
	 ('2023-06-20','telegram','cpp','base-java',3,NULL,1,1,151192),
	 ('2023-06-01','yandex','cpc','dod-php',4,23856,4,1,150255),
	 ('2023-06-01','yandex','cpc','base-professions-retarget',4,604,4,1,134100),
	 ('2023-06-07','vk','social','hexlet-blog',3,NULL,1,1,84000),
	 ('2023-06-01','yandex','cpc','base-java',20,385040,20,1,48000),
	 ('2023-06-01','yandex','cpc','dod-professions',6,NULL,6,1,37800),
	 ('2023-06-01','vk','cpc','base-python',58,149683,36,1,9072),
	 ('2023-06-01','vk','cpc','freemium-python',44,43120,25,1,1560),
	 ('2023-06-01','admitad','cpa','admitad',66,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-01','vk','cpc','prof-data-analytics',49,52528,30,0,NULL),
	 ('2023-06-01','vk','cpc','freemium-java',42,20454,24,0,NULL),
	 ('2023-06-01','telegram','cpp','base-python',38,NULL,0,0,NULL),
	 ('2023-06-01','telegram','cpp','base-java',33,NULL,0,0,NULL),
	 ('2023-06-01','vk','cpc','prof-frontend',17,NULL,7,0,NULL),
	 ('2023-06-01','tproger','cpc','dod-frontend',11,NULL,0,0,NULL),
	 ('2023-06-01','vk','cpm','prof-data-analytics',10,3850,6,0,NULL),
	 ('2023-06-01','yandex','cpc','prof-professions-retarget',10,17140,10,0,NULL),
	 ('2023-06-01','vk-senler','cpc','freemium',8,NULL,0,0,NULL),
	 ('2023-06-01','zen','social','hexlet-blog',8,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-01','zen','social','prof-frontend',7,NULL,0,0,NULL),
	 ('2023-06-01','telegram','cpp','base-frontend',5,NULL,0,0,NULL),
	 ('2023-06-01','yandex','cpc','dod-java',4,11624,4,0,NULL),
	 ('2023-06-01','zen','social','prof-backend',4,NULL,0,0,NULL),
	 ('2023-06-01','google','cpc','frontend',3,NULL,0,0,NULL),
	 ('2023-06-01','telegram','cpp','dod-php',3,NULL,0,0,NULL),
	 ('2023-06-01','telegram','social','course_completed',3,NULL,0,0,NULL),
	 ('2023-06-01','vk','cpp','dod-php',3,NULL,0,0,NULL),
	 ('2023-06-01','yandex','cpc','dod-frontend',3,8613,3,0,NULL),
	 ('2023-06-01','yandex','cpc','dod-python-java',3,NULL,3,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-01','telegram','cpp','dod-java',2,NULL,0,0,NULL),
	 ('2023-06-01','vk','cpp','intensive-python',2,NULL,0,0,NULL),
	 ('2023-06-01','Yandex','cpc','03997128',1,NULL,0,0,NULL),
	 ('2023-06-01','Yandex','cpm','01097402',1,NULL,0,0,NULL),
	 ('2023-06-01','telegram','cpp','intensive-python',1,NULL,0,0,NULL),
	 ('2023-06-01','telegram','cpp','prof-php',1,NULL,0,0,NULL),
	 ('2023-06-01','telegram','cpp','prof-python',1,NULL,1,0,NULL),
	 ('2023-06-01','telegram','social','mdtrue*studenty-mnogih-onlayn-kursov-p',1,NULL,0,0,NULL),
	 ('2023-06-01','twitter','social','devushki_v_it',1,NULL,0,0,NULL),
	 ('2023-06-01','twitter','social','hexlet-blog',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-01','twitter','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-01','twitter.com','social','buffer',1,NULL,0,0,NULL),
	 ('2023-06-01','vc','cpp','dod-php',1,NULL,0,0,NULL),
	 ('2023-06-01','vk','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-01','vk','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-01','vk','social','general',1,NULL,0,0,NULL),
	 ('2023-06-01','vk','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-01','vk','social','hexlet.io/my',1,NULL,0,0,NULL),
	 ('2023-06-01','vk-senler','cpc','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-02','vk','cpc','prof-python',240,487680,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-02','vk','cpc','prof-java',216,601128,0,0,NULL),
	 ('2023-06-02','vk','cpc','freemium-frontend',207,525366,0,0,NULL),
	 ('2023-06-02','vk','cpc','prof-data-analytics',178,722680,0,0,NULL),
	 ('2023-06-02','vk','cpc','freemium-java',163,413368,0,0,NULL),
	 ('2023-06-02','vk','cpc','freemium-python',143,248677,0,0,NULL),
	 ('2023-06-02','vk','cpc','base-python',133,337288,0,0,NULL),
	 ('2023-06-02','vk','cpc','prof-frontend',120,NULL,0,0,NULL),
	 ('2023-06-02','tproger','cpc','dod-frontend',55,NULL,0,0,NULL),
	 ('2023-06-02','admitad','cpa','admitad',54,NULL,0,0,NULL),
	 ('2023-06-02','telegram','cpp','base-java',23,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-02','vk','cpm','prof-data-analytics',14,NULL,0,0,NULL),
	 ('2023-06-02','telegram','cpp','base-python',11,NULL,0,0,NULL),
	 ('2023-06-02','telegram','cpp','dod-java',10,NULL,0,0,NULL),
	 ('2023-06-02','telegram','cpp','dod-php',9,NULL,0,0,NULL),
	 ('2023-06-02','vk-senler','cpc','freemium',9,NULL,0,0,NULL),
	 ('2023-06-02','zen','social','hexlet-blog',5,NULL,0,0,NULL),
	 ('2023-06-02','vk','cpm','prof-frontend',4,NULL,0,0,NULL),
	 ('2023-06-02','zen','social','prof-frontend',3,NULL,0,0,NULL),
	 ('2023-06-02','zen','social','promo',3,NULL,0,0,NULL),
	 ('2023-06-02','telegram','cpp','prof-frontend',2,NULL,1,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-02','twitter','social','devushki_v_it',2,NULL,0,0,NULL),
	 ('2023-06-02','vk','cpp','dod-php',2,NULL,0,0,NULL),
	 ('2023-06-02','vk','social','hexlet-blog',2,NULL,0,0,NULL),
	 ('2023-06-02','botmother','tg','frontend',1,NULL,0,0,NULL),
	 ('2023-06-02','facebook','cpm','freemium-en',1,NULL,0,0,NULL),
	 ('2023-06-02','partners','cpc','prof-python',1,NULL,0,0,NULL),
	 ('2023-06-02','telegram','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-02','telegram','cpp','prof-python',1,NULL,0,0,NULL),
	 ('2023-06-02','telegram','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-02','tg','social','newdirections',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-02','twitter','social','my-to--chto-my-skrollim-kak-programmistu',1,NULL,0,0,NULL),
	 ('2023-06-02','vc','cpp','dod-php',1,NULL,0,0,NULL),
	 ('2023-06-02','vk','cpc','freemium',1,NULL,0,0,NULL),
	 ('2023-06-02','vk','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-02','vk','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-02','vk','social','base-python',1,NULL,0,0,NULL),
	 ('2023-06-02','yandex-direct','cpc','34668848',1,NULL,0,0,NULL),
	 ('2023-06-02','yandex-direct','cpm','00788899',1,NULL,0,0,NULL),
	 ('2023-06-03','vk','cpc','freemium-frontend',211,535729,0,0,NULL),
	 ('2023-06-03','tproger','cpc','dod-frontend',207,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-03','vk','cpc','prof-python',204,412692,0,0,NULL),
	 ('2023-06-03','vk','cpc','prof-java',198,549252,0,0,NULL),
	 ('2023-06-03','vk','cpc','prof-data-analytics',172,683528,0,0,NULL),
	 ('2023-06-03','vk','cpc','freemium-java',148,393088,0,0,NULL),
	 ('2023-06-03','vk','cpc','freemium-python',122,169580,0,0,NULL),
	 ('2023-06-03','vk','cpc','prof-frontend',122,NULL,0,0,NULL),
	 ('2023-06-03','vk','cpc','base-python',101,302697,0,0,NULL),
	 ('2023-06-03','admitad','cpa','admitad',43,NULL,0,0,NULL),
	 ('2023-06-03','vk-senler','cpc','freemium',16,NULL,1,0,NULL),
	 ('2023-06-03','telegram','cpp','base-python',12,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-03','vk','cpm','prof-data-analytics',12,NULL,0,0,NULL),
	 ('2023-06-03','zen','social','promo',9,NULL,0,0,NULL),
	 ('2023-06-03','telegram','cpp','base-frontend',6,NULL,0,0,NULL),
	 ('2023-06-03','vk','cpm','prof-frontend',3,NULL,0,0,NULL),
	 ('2023-06-03','vk','cpp','dod-php',3,NULL,0,0,NULL),
	 ('2023-06-03','google','cpc','frontend',2,NULL,0,0,NULL),
	 ('2023-06-03','telegram','cpp','base-java',2,NULL,0,0,NULL),
	 ('2023-06-03','telegram','cpp','prof-frontend',2,NULL,0,0,NULL),
	 ('2023-06-03','telegram','social','course_completed',2,NULL,0,0,NULL),
	 ('2023-06-03','vk','social','hexlet-blog',2,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-03','Yandex','cpc','02284027',1,NULL,0,0,NULL),
	 ('2023-06-03','Yandex','cpc','59988739',1,NULL,0,0,NULL),
	 ('2023-06-03','Yandex','cpm','94599791',1,NULL,0,0,NULL),
	 ('2023-06-03','admitad','cpa','442763',1,NULL,0,0,NULL),
	 ('2023-06-03','facebook','cpm','freemium-en',1,NULL,0,0,NULL),
	 ('2023-06-03','telegram','cpp','dod-java',1,NULL,0,0,NULL),
	 ('2023-06-03','telegram','cpp','prof-java',1,NULL,0,0,NULL),
	 ('2023-06-03','telegram','cpp','prof-python',1,NULL,0,0,NULL),
	 ('2023-06-03','telegram','social','base-java',1,NULL,0,0,NULL),
	 ('2023-06-03','twitter','social','course_completed',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-03','vc','cpp','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-03','vk','cpm','java',1,NULL,0,0,NULL),
	 ('2023-06-03','vk','social','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-03','vk','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-03','yandex-direct','cpc','16645437',1,NULL,0,0,NULL),
	 ('2023-06-03','zen','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-04','vk','cpc','freemium-frontend',224,568512,0,0,NULL),
	 ('2023-06-04','vk','cpc','prof-python',213,432816,0,0,NULL),
	 ('2023-06-04','vk','cpc','prof-java',188,305876,0,0,NULL),
	 ('2023-06-04','tproger','cpc','dod-frontend',156,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-04','vk','cpc','freemium-java',150,234900,0,0,NULL),
	 ('2023-06-04','vk','cpc','base-python',145,367865,0,0,NULL),
	 ('2023-06-04','vk','cpc','prof-data-analytics',132,493680,0,0,NULL),
	 ('2023-06-04','vk','cpc','freemium-python',130,169650,0,0,NULL),
	 ('2023-06-04','vk','cpc','prof-frontend',113,NULL,0,0,NULL),
	 ('2023-06-04','telegram','cpp','base-python',47,NULL,0,0,NULL),
	 ('2023-06-04','admitad','cpa','admitad',31,NULL,1,0,NULL),
	 ('2023-06-04','vk','cpm','prof-data-analytics',24,16824,0,0,NULL),
	 ('2023-06-04','vk','cpm','prof-frontend',11,NULL,0,0,NULL),
	 ('2023-06-04','telegram','cpp','base-frontend',10,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-04','telegram','cpp','base-java',9,NULL,0,0,NULL),
	 ('2023-06-04','vk-senler','cpc','freemium',8,NULL,0,0,NULL),
	 ('2023-06-04','vk','social','hexlet-blog',4,NULL,0,0,NULL),
	 ('2023-06-04','telegram','cpp','prof-python',3,NULL,0,0,NULL),
	 ('2023-06-04','vk','cpp','dod-php',2,NULL,0,0,NULL),
	 ('2023-06-04','vk','social','general',2,NULL,0,0,NULL),
	 ('2023-06-04','Yandex','cpc','55670133',1,NULL,0,0,NULL),
	 ('2023-06-04','admitad','cpc','183258',1,NULL,0,0,NULL),
	 ('2023-06-04','dzen','social','dzen_post',1,NULL,0,0,NULL),
	 ('2023-06-04','instagram','social','prof-php',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-04','telegram','cpp','dod-java',1,NULL,0,0,NULL),
	 ('2023-06-04','telegram','cpp','intensive-python',1,NULL,0,0,NULL),
	 ('2023-06-04','telegram','cpp','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-04','telegram','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-04','telegram','social','mdtruena-hekslete-poyavilsya-esche-odin-no',1,NULL,0,0,NULL),
	 ('2023-06-04','telegram','social','special',1,NULL,0,0,NULL),
	 ('2023-06-04','twitter','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-04','twitter','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-04','twitter.com','social','svezhiy-vzglyad-na-prohozhdenie-proektov-ot',1,NULL,0,0,NULL),
	 ('2023-06-04','vk','cpc','php',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-04','vk','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-04','vk','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-04','vk','social','prof-qa',1,NULL,0,0,NULL),
	 ('2023-06-04','zen','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-05','vk','cpc','freemium-frontend',192,487296,0,0,NULL),
	 ('2023-06-05','vk','cpc','prof-java',191,386202,0,0,NULL),
	 ('2023-06-05','vk','cpc','prof-python',182,924014,0,0,NULL),
	 ('2023-06-05','vk','cpc','prof-data-analytics',154,469392,0,0,NULL),
	 ('2023-06-05','vk','cpc','freemium-java',138,54786,0,0,NULL),
	 ('2023-06-05','vk','cpc','freemium-python',138,154284,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-05','vk','cpc','base-python',124,245520,0,0,NULL),
	 ('2023-06-05','vk','cpc','prof-frontend',110,NULL,0,0,NULL),
	 ('2023-06-05','tproger','cpc','dod-frontend',49,NULL,0,0,NULL),
	 ('2023-06-05','admitad','cpa','admitad',38,NULL,0,0,NULL),
	 ('2023-06-05','telegram','cpp','base-python',31,NULL,0,0,NULL),
	 ('2023-06-05','telegram','cpp','base-frontend',29,NULL,0,0,NULL),
	 ('2023-06-05','vk','cpm','prof-data-analytics',23,17503,0,0,NULL),
	 ('2023-06-05','telegram','cpp','base-java',19,NULL,0,0,NULL),
	 ('2023-06-05','vk-senler','cpc','dod-php',12,NULL,0,0,NULL),
	 ('2023-06-05','telegram','cpp','dod-java',5,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-05','vk','cpp','dod-php',5,NULL,1,0,NULL),
	 ('2023-06-05','telegram','cpp','prof-java',4,NULL,0,0,NULL),
	 ('2023-06-05','telegram','social','hexlet-blog',4,NULL,0,0,NULL),
	 ('2023-06-05','vk','social','base-python',4,NULL,0,0,NULL),
	 ('2023-06-05','vk-senler','cpc','freemium',4,NULL,0,0,NULL),
	 ('2023-06-05','vk','cpm','prof-frontend',3,NULL,0,0,NULL),
	 ('2023-06-05','vk','social','base-java',3,NULL,0,0,NULL),
	 ('2023-06-05','telegram','cpp','prof-python',2,NULL,0,0,NULL),
	 ('2023-06-05','vk','social','all-courses',2,NULL,0,0,NULL),
	 ('2023-06-05','Yandex','cpc','16951197',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-05','Yandex','cpc','67652027',1,NULL,0,0,NULL),
	 ('2023-06-05','facebook','cpc','frontend',1,NULL,0,0,NULL),
	 ('2023-06-05','google','cpc','frontend',1,NULL,0,0,NULL),
	 ('2023-06-05','instagram','social','prof-data-analyst',1,NULL,0,0,NULL),
	 ('2023-06-05','podcast','social','unpack',1,NULL,0,0,NULL),
	 ('2023-06-05','telegram','cpm','base',1,NULL,0,0,NULL),
	 ('2023-06-05','telegram','cpm','frontend',1,NULL,0,0,NULL),
	 ('2023-06-05','telegram','cpp','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-05','telegram','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-05','telegram','social','kak_gumanitariyu_popast-v_it',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-05','vc','cpp','dod-php',1,NULL,0,0,NULL),
	 ('2023-06-05','vk','cpm','base',1,NULL,0,0,NULL),
	 ('2023-06-05','vk','cpp','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-05','vk','social','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-05','vk','social','dod-php',1,NULL,0,0,NULL),
	 ('2023-06-05','vk','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-05','vk','social','planiruy-uchebu--fokusiruysya-na-protsesse',1,NULL,0,0,NULL),
	 ('2023-06-05','vk','social','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-05','yandex-direct','cpc','08062768',1,NULL,0,0,NULL),
	 ('2023-06-05','zen','social','hexlet-blog',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-06','vk','cpc','prof-python',185,939430,0,0,NULL),
	 ('2023-06-06','vk','cpc','freemium-frontend',171,572508,0,0,NULL),
	 ('2023-06-06','vk','cpc','prof-java',159,180783,0,0,NULL),
	 ('2023-06-06','vk','cpc','freemium-java',139,266324,0,0,NULL),
	 ('2023-06-06','vk','cpc','prof-data-analytics',135,410940,0,0,NULL),
	 ('2023-06-06','vk','cpc','base-python',121,402722,0,0,NULL),
	 ('2023-06-06','vk','cpc','prof-frontend',111,NULL,0,0,NULL),
	 ('2023-06-06','vk','cpc','freemium-python',104,192816,0,0,NULL),
	 ('2023-06-06','telegram','cpp','base-frontend',52,NULL,0,0,NULL),
	 ('2023-06-06','admitad','cpa','admitad',33,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-06','telegram','cpp','base-python',25,NULL,0,0,NULL),
	 ('2023-06-06','vk-senler','cpc','freemium',17,NULL,0,0,NULL),
	 ('2023-06-06','telegram','cpp','base-java',13,NULL,0,0,NULL),
	 ('2023-06-06','vk','cpm','prof-data-analytics',13,9867,0,0,NULL),
	 ('2023-06-06','tproger','cpc','dod-frontend',8,NULL,0,0,NULL),
	 ('2023-06-06','vk','cpp','base-frontend',5,NULL,0,0,NULL),
	 ('2023-06-06','telegram','cpp','dod-java',4,NULL,0,0,NULL),
	 ('2023-06-06','vk','cpp','dod-php',4,NULL,0,0,NULL),
	 ('2023-06-06','vk','social','base-java',4,NULL,0,0,NULL),
	 ('2023-06-06','telegram','cpp','prof-java',3,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-06','telegram','cpp','prof-python',3,NULL,0,0,NULL),
	 ('2023-06-06','vk','cpc','freemium',3,NULL,0,0,NULL),
	 ('2023-06-06','vk','social','general',3,NULL,0,0,NULL),
	 ('2023-06-06','vk','social','prof-frontend',3,NULL,0,0,NULL),
	 ('2023-06-06','google','cpc','frontend',2,NULL,0,0,NULL),
	 ('2023-06-06','telegram','social','course_completed',2,NULL,0,0,NULL),
	 ('2023-06-06','admitad','cpc','183258',1,NULL,0,0,NULL),
	 ('2023-06-06','instagram','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-06','slack','social','base_alg',1,NULL,0,0,NULL),
	 ('2023-06-06','telegram','cpm','python',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-06','telegram','cpp','base-php',1,NULL,0,0,NULL),
	 ('2023-06-06','telegram','cpp','prof-data-analytics',1,NULL,0,0,NULL),
	 ('2023-06-06','telegram','cpp','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-06','twitter','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-06','vc','cpp','dod-frontend',1,NULL,1,0,NULL),
	 ('2023-06-06','vk','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-06','vk','social','base-python',1,NULL,0,0,NULL),
	 ('2023-06-06','vk','social','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-06','vk','social','dod-php',1,NULL,0,0,NULL),
	 ('2023-06-06','vk','social','dod-professions',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-06','vk','social','hexlet-blog',1,NULL,1,0,NULL),
	 ('2023-06-06','vk','social','hexlet.io/my',1,NULL,0,0,NULL),
	 ('2023-06-06','vk','social','kak-dzhunu-napisat-soprovoditelnoe-pis',1,NULL,0,0,NULL),
	 ('2023-06-06','vk','social','prof-rails',1,NULL,0,0,NULL),
	 ('2023-06-06','vk-senler','cpc','dod-php',1,NULL,0,0,NULL),
	 ('2023-06-06','vk.com','social','na-hekslete-poyavilas-novaya-professiya-v',1,NULL,0,0,NULL),
	 ('2023-06-06','yandex-direct','cpc','68583881',1,NULL,0,0,NULL),
	 ('2023-06-07','vk','cpc','prof-python',190,965010,0,0,NULL),
	 ('2023-06-07','vk','cpc','freemium-frontend',169,428415,0,0,NULL),
	 ('2023-06-07','vk','cpc','prof-java',166,186916,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-07','vk','cpc','freemium-java',113,286116,0,0,NULL),
	 ('2023-06-07','vk','cpc','freemium-python',111,323676,0,0,NULL),
	 ('2023-06-07','vk','cpc','prof-data-analytics',110,335280,0,0,NULL),
	 ('2023-06-07','vk','cpc','base-python',107,269212,0,0,NULL),
	 ('2023-06-07','vk','cpc','prof-frontend',94,NULL,0,0,NULL),
	 ('2023-06-07','admitad','cpa','admitad',51,NULL,0,0,NULL),
	 ('2023-06-07','telegram','cpp','base-frontend',37,NULL,0,0,NULL),
	 ('2023-06-07','vk-senler','cpc','freemium',17,NULL,0,0,NULL),
	 ('2023-06-07','telegram','cpp','base-python',15,NULL,0,0,NULL),
	 ('2023-06-07','vk','cpm','prof-data-analytics',12,9144,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-07','telegram','cpp','dod-java',9,NULL,1,0,NULL),
	 ('2023-06-07','tproger','cpc','dod-frontend',9,NULL,0,0,NULL),
	 ('2023-06-07','vk','cpp','base-frontend',9,NULL,0,0,NULL),
	 ('2023-06-07','telegram','cpp','prof-java',7,NULL,1,0,NULL),
	 ('2023-06-07','vk','social','base-python',7,NULL,0,0,NULL),
	 ('2023-06-07','telegram','cpp','base-java',4,NULL,0,0,NULL),
	 ('2023-06-07','telegram','cpp','prof-python',2,NULL,0,0,NULL),
	 ('2023-06-07','vk','social','base-java',2,NULL,0,0,NULL),
	 ('2023-06-07','vk','social','general',2,NULL,0,0,NULL),
	 ('2023-06-07','vk','social','prof-python',2,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-07','botmother','tg','frontend',1,NULL,0,0,NULL),
	 ('2023-06-07','facebook','cpc','python',1,NULL,0,0,NULL),
	 ('2023-06-07','facebook','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-07','instagram','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-07','instagram','social','taplink',1,NULL,0,0,NULL),
	 ('2023-06-07','public','social','open_lectures23',1,NULL,0,0,NULL),
	 ('2023-06-07','telegram','cpm','java',1,NULL,0,0,NULL),
	 ('2023-06-07','telegram','cpp','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-07','telegram','cpp','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-07','telegram','social','base-python',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-07','telegram','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-07','telegram','social',NULL,1,NULL,0,0,NULL),
	 ('2023-06-07','vk','cpc','frontend',1,NULL,0,0,NULL),
	 ('2023-06-07','vk','cpm','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-07','vk','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-07','vk','social','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-07','vk-senler','cpc','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-07','yandex-direct','cpc','51752512',1,NULL,0,0,NULL),
	 ('2023-06-07','zen','social','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-08','vk','cpc','freemium-frontend',193,496975,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-08','vk','cpc','prof-python',188,954288,0,0,NULL),
	 ('2023-06-08','vk','cpc','prof-java',172,274168,0,0,NULL),
	 ('2023-06-08','vk','cpc','prof-data-analytics',135,406755,0,0,NULL),
	 ('2023-06-08','vk','cpc','freemium-java',124,313844,0,0,NULL),
	 ('2023-06-08','vk','cpc','prof-frontend',117,69264,0,0,NULL),
	 ('2023-06-08','vk','cpc','base-python',111,111999,0,0,NULL),
	 ('2023-06-08','vk','cpc','freemium-python',108,273456,0,0,NULL),
	 ('2023-06-08','admitad','cpa','admitad',48,NULL,0,0,NULL),
	 ('2023-06-08','timepad','cpp','base-frontend',44,NULL,0,0,NULL),
	 ('2023-06-08','telegram','cpp','base-frontend',21,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-08','telegram','cpp','prof-python',20,NULL,1,0,NULL),
	 ('2023-06-08','vk','cpm','prof-data-analytics',17,12954,0,0,NULL),
	 ('2023-06-08','vk','cpp','base-frontend',15,NULL,0,0,NULL),
	 ('2023-06-08','vk-senler','cpc','freemium',12,NULL,0,0,NULL),
	 ('2023-06-08','tproger','cpc','dod-frontend',11,NULL,0,0,NULL),
	 ('2023-06-08','telegram','cpp','base-python',7,NULL,0,0,NULL),
	 ('2023-06-08','telegram','cpp','dod-frontend',3,NULL,1,0,NULL),
	 ('2023-06-08','telegram','cpp','prof-java',3,NULL,0,0,NULL),
	 ('2023-06-08','vk','cpm','prof-frontend',3,0,0,0,NULL),
	 ('2023-06-08','vk','social','general',3,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-08','vk','social','hexlet-blog',3,NULL,0,0,NULL),
	 ('2023-06-08','telegram','cpp','dod-java',2,NULL,1,0,NULL),
	 ('2023-06-08','facebook.com','social','buffer',1,NULL,0,0,NULL),
	 ('2023-06-08','telegram','cpp','base-java',1,NULL,0,0,NULL),
	 ('2023-06-08','telegram','cpp','dod-php',1,NULL,0,0,NULL),
	 ('2023-06-08','telegram','cpp','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-08','telegram','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-08','telegram','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-08','telegram','social','mdtruehaskell--funktsionalnyy-yazyk',1,NULL,0,0,NULL),
	 ('2023-06-08','vk','cpc','php',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-08','vk','cpm','php',1,NULL,0,0,NULL),
	 ('2023-06-08','vk','cpp','dod-career',1,NULL,0,0,NULL),
	 ('2023-06-08','vk','cpp','intensive-python',1,NULL,0,0,NULL),
	 ('2023-06-08','vk','social','prof-data-analytics',1,NULL,0,0,NULL),
	 ('2023-06-08','vk-senler','cpc','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-08','vk-senler','cpc','dod-professions',1,NULL,0,0,NULL),
	 ('2023-06-08','zen','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-08','zen','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-08','zen','social','prof-data-analytics',1,NULL,0,0,NULL),
	 ('2023-06-09','vk','cpc','prof-python',182,924014,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-09','vk','cpc','freemium-frontend',181,458654,0,0,NULL),
	 ('2023-06-09','vk','cpc','prof-java',161,742210,0,0,NULL),
	 ('2023-06-09','vk','cpc','prof-data-analytics',160,720320,0,0,NULL),
	 ('2023-06-09','vk','cpc','freemium-python',120,303960,0,0,NULL),
	 ('2023-06-09','vk','cpc','prof-frontend',112,568624,1,0,NULL),
	 ('2023-06-09','vk','cpc','freemium-java',108,273564,0,0,NULL),
	 ('2023-06-09','vk','cpc','base-python',105,NULL,0,0,NULL),
	 ('2023-06-09','admitad','cpa','admitad',46,NULL,0,0,NULL),
	 ('2023-06-09','timepad','cpp','base-frontend',32,NULL,0,0,NULL),
	 ('2023-06-09','telegram','cpp','base-frontend',15,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-09','vk','cpm','prof-data-analytics',11,704,0,0,NULL),
	 ('2023-06-09','vk-senler','cpc','freemium',9,NULL,0,0,NULL),
	 ('2023-06-09','tproger','cpc','dod-frontend',7,NULL,0,0,NULL),
	 ('2023-06-09','vk','cpp','base-frontend',7,NULL,0,0,NULL),
	 ('2023-06-09','vk','cpm','prof-frontend',5,NULL,0,0,NULL),
	 ('2023-06-09','telegram','cpp','dod-frontend',3,NULL,0,0,NULL),
	 ('2023-06-09','telegram','cpp','prof-python',3,NULL,0,0,NULL),
	 ('2023-06-09','telegram','cpp','base-java',2,NULL,0,0,NULL),
	 ('2023-06-09','telegram','cpp','prof-frontend',2,NULL,0,0,NULL),
	 ('2023-06-09','telegram','cpp','prof-java',2,NULL,1,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-09','vk','social','all-courses',2,NULL,0,0,NULL),
	 ('2023-06-09','vk','social','base-frontend',2,NULL,0,0,NULL),
	 ('2023-06-09','Yandex','cpc','42790821',1,NULL,0,0,NULL),
	 ('2023-06-09','Yandex','cpc','87255026',1,NULL,0,0,NULL),
	 ('2023-06-09','mytarget','cpc','freemium',1,NULL,0,0,NULL),
	 ('2023-06-09','rutube','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-09','social','youtube','chistie-funktsii',1,NULL,0,0,NULL),
	 ('2023-06-09','telegram','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-09','telegram','social','kak-gumanitariy-stal-bekend-razrabotchiko',1,NULL,0,0,NULL),
	 ('2023-06-09','telegram.me','social','klassicheskaya-zadachka-fizzbuzz-na-hekslet',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-09','telegram.me','social','na-hekslet-poyavilis-novye-ispytaniya-v-k',1,NULL,0,0,NULL),
	 ('2023-06-09','twitter','social','devushki_v_it',1,NULL,0,0,NULL),
	 ('2023-06-09','vk','social','base-python',1,NULL,0,0,NULL),
	 ('2023-06-09','vk','social','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-09','vk','social','dod-php',1,NULL,0,0,NULL),
	 ('2023-06-10','vk','cpc','prof-python',163,889654,0,0,NULL),
	 ('2023-06-10','vk','cpc','freemium-frontend',155,393080,0,0,NULL),
	 ('2023-06-10','vk','cpc','prof-java',150,561450,0,0,NULL),
	 ('2023-06-10','vk','cpc','freemium-python',143,362648,0,0,NULL),
	 ('2023-06-10','vk','cpc','prof-data-analytics',130,548600,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-10','vk','cpc','base-python',119,NULL,0,0,NULL),
	 ('2023-06-10','vk','cpc','freemium-java',107,271459,0,0,NULL),
	 ('2023-06-10','vk','cpc','prof-frontend',96,523968,0,0,NULL),
	 ('2023-06-10','admitad','cpa','admitad',26,NULL,0,0,NULL),
	 ('2023-06-10','vk-senler','cpc','freemium',13,NULL,0,0,NULL),
	 ('2023-06-10','vk','cpm','prof-data-analytics',12,NULL,0,0,NULL),
	 ('2023-06-10','telegram','cpp','base-frontend',8,NULL,0,0,NULL),
	 ('2023-06-10','timepad','cpp','base-frontend',6,NULL,0,0,NULL),
	 ('2023-06-10','vk','cpm','prof-frontend',5,NULL,0,0,NULL),
	 ('2023-06-10','google','cpc','frontend',2,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-10','vk','cpm','base',2,NULL,0,0,NULL),
	 ('2023-06-10','vk','social','all-courses',2,NULL,0,0,NULL),
	 ('2023-06-10','facebook','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-10','telegram','cpp','base-java',1,NULL,0,0,NULL),
	 ('2023-06-10','telegram','cpp','base-python',1,NULL,0,0,NULL),
	 ('2023-06-10','telegram','cpp','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-10','telegram','cpp','intensive-python',1,NULL,0,0,NULL),
	 ('2023-06-10','telegram','cpp','prof-python',1,NULL,0,0,NULL),
	 ('2023-06-10','telegram','social','glavnye-instrumenty--servisy-i-podhody',1,NULL,0,0,NULL),
	 ('2023-06-10','telegram','social','hexlet-blog',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-10','telegram','social','typescript',1,NULL,0,0,NULL),
	 ('2023-06-10','twitter','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-10','vk','cpc','freemium',1,NULL,0,0,NULL),
	 ('2023-06-10','vk','cpc','frontend',1,NULL,0,0,NULL),
	 ('2023-06-10','vk','cpc','yaintern',1,NULL,0,0,NULL),
	 ('2023-06-10','vk','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-10','vk','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-10','zen','social','hexlet',1,NULL,0,0,NULL),
	 ('2023-06-11','vk','cpc','freemium-frontend',211,534463,0,0,NULL),
	 ('2023-06-11','vk','cpc','prof-python',186,944136,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-11','vk','cpc','prof-java',147,555807,0,0,NULL),
	 ('2023-06-11','vk','cpc','prof-data-analytics',141,644229,0,0,NULL),
	 ('2023-06-11','vk','cpc','freemium-java',126,367416,0,0,NULL),
	 ('2023-06-11','vk','cpc','prof-frontend',123,671334,0,0,NULL),
	 ('2023-06-11','vk','cpc','base-python',115,NULL,0,0,NULL),
	 ('2023-06-11','vk','cpc','freemium-python',112,284032,0,0,NULL),
	 ('2023-06-11','admitad','cpa','admitad',41,NULL,0,0,NULL),
	 ('2023-06-11','vk','cpm','prof-data-analytics',14,NULL,0,0,NULL),
	 ('2023-06-11','vk-senler','cpc','freemium',10,NULL,0,0,NULL),
	 ('2023-06-11','telegram','cpp','base-frontend',6,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-11','vk','cpp','dod-frontend',6,NULL,0,0,NULL),
	 ('2023-06-11','vk','cpm','prof-frontend',4,NULL,0,0,NULL),
	 ('2023-06-11','vk','social','all-courses',2,NULL,0,0,NULL),
	 ('2023-06-11','vk','social','base-python',2,NULL,0,0,NULL),
	 ('2023-06-11','vk','social','general',2,NULL,0,0,NULL),
	 ('2023-06-11','vk','social','hexlet-blog',2,NULL,0,0,NULL),
	 ('2023-06-11','google','cpc','freemium',1,NULL,0,0,NULL),
	 ('2023-06-11','google','cpc','frontend',1,NULL,0,0,NULL),
	 ('2023-06-11','telegram','cpm','base_python',1,NULL,0,0,NULL),
	 ('2023-06-11','telegram','cpp','prof-frontend',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-11','timepad','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-11','vk','cpc','java',1,NULL,0,0,NULL),
	 ('2023-06-11','vk','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-12','vk','cpc','prof-python',196,1024794,0,0,NULL),
	 ('2023-06-12','vk','cpc','freemium-frontend',184,583280,0,0,NULL),
	 ('2023-06-12','vk','cpc','prof-java',170,697850,0,0,NULL),
	 ('2023-06-12','vk','cpc','prof-data-analytics',161,674107,0,0,NULL),
	 ('2023-06-12','vk','cpc','freemium-java',132,641326,0,0,NULL),
	 ('2023-06-12','vk','cpc','base-python',123,NULL,0,0,NULL),
	 ('2023-06-12','vk','cpc','freemium-python',121,306856,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-12','vk','cpc','prof-frontend',113,573814,0,0,NULL),
	 ('2023-06-12','admitad','cpa','admitad',33,NULL,0,0,NULL),
	 ('2023-06-12','vk-senler','cpc','freemium',24,NULL,0,0,NULL),
	 ('2023-06-12','telegram','cpp','base-frontend',18,NULL,0,0,NULL),
	 ('2023-06-12','vk','cpm','prof-data-analytics',14,NULL,0,0,NULL),
	 ('2023-06-12','vk','cpm','prof-frontend',6,NULL,0,0,NULL),
	 ('2023-06-12','timepad','cpp','base-frontend',4,NULL,0,0,NULL),
	 ('2023-06-12','vk','cpp','base-frontend',4,NULL,0,0,NULL),
	 ('2023-06-12','telegram','cpp','base-python',3,NULL,0,0,NULL),
	 ('2023-06-12','telegram','cpp','dod-frontend',3,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-12','vk','social','prof-rails',3,NULL,0,0,NULL),
	 ('2023-06-12','telegram','cpp','base-java',2,NULL,0,0,NULL),
	 ('2023-06-12','vk','cpp','dod-frontend',2,NULL,0,0,NULL),
	 ('2023-06-12','vk','social','hexlet-blog',2,NULL,0,0,NULL),
	 ('2023-06-12','Yandex','cpm','25530592',1,NULL,0,0,NULL),
	 ('2023-06-12','facebook','social','how-to-sleep',1,NULL,0,0,NULL),
	 ('2023-06-12','facebook.com','social','mozhno-li-ustroitsya-na-rabotu-posle-heks',1,NULL,0,0,NULL),
	 ('2023-06-12','google','cpc','freemium',1,NULL,0,0,NULL),
	 ('2023-06-12','instagram','social','base-java',1,NULL,0,0,NULL),
	 ('2023-06-12','telegram','social','promo',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-12','tg','social','codecamp',1,NULL,0,0,NULL),
	 ('2023-06-12','twitter','social','devushki_v_it',1,NULL,0,0,NULL),
	 ('2023-06-12','vk','cpm','base_python',1,NULL,0,0,NULL),
	 ('2023-06-12','vk','cpp','intensive-python',1,NULL,0,0,NULL),
	 ('2023-06-12','vk','social','base-java',1,NULL,0,0,NULL),
	 ('2023-06-12','vk','social','base-python',1,NULL,0,0,NULL),
	 ('2023-06-12','vk','social','general',1,NULL,0,0,NULL),
	 ('2023-06-12','vk','social','prof-python',1,NULL,0,0,NULL),
	 ('2023-06-12','vk','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-12','yandex-direct','cpc','96566756',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-13','yandex','cpc','freemium',138,2556174,0,0,NULL),
	 ('2023-06-13','yandex','cpc','prof-frontend',105,6581925,0,0,NULL),
	 ('2023-06-13','yandex','cpc','prof-python',104,4497064,0,0,NULL),
	 ('2023-06-13','yandex','cpc','prof-java',83,3031160,0,0,NULL),
	 ('2023-06-13','vk','cpc','prof-python',66,343332,0,0,NULL),
	 ('2023-06-13','vk','cpc','freemium-frontend',62,170252,1,0,NULL),
	 ('2023-06-13','vk','cpc','freemium-java',57,135489,0,0,NULL),
	 ('2023-06-13','vk','cpc','freemium-python',52,131976,0,0,NULL),
	 ('2023-06-13','vk','cpc','prof-data-analytics',49,205212,0,0,NULL),
	 ('2023-06-13','vk','cpc','prof-java',47,204450,1,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-13','vk','cpc','base-python',41,NULL,0,0,NULL),
	 ('2023-06-13','yandex','cpc','base-java',41,NULL,0,0,NULL),
	 ('2023-06-13','admitad','cpa','admitad',40,NULL,0,0,NULL),
	 ('2023-06-13','vk','cpc','prof-frontend',37,201983,0,0,NULL),
	 ('2023-06-13','yandex','cpc','base-python',35,NULL,0,0,NULL),
	 ('2023-06-13','yandex','cpc','prof-professions-brand',33,117942,0,0,NULL),
	 ('2023-06-13','yandex','cpc','base-frontend',29,296728,0,0,NULL),
	 ('2023-06-13','telegram','cpp','base-frontend',21,NULL,0,0,NULL),
	 ('2023-06-13','yandex','cpc','prof-professions-retarget',18,10872,0,0,NULL),
	 ('2023-06-13','yandex','cpc','prof-data-analytics',17,102561,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-13','telegram','cpp','prof-python',13,NULL,0,0,NULL),
	 ('2023-06-13','vk-senler','cpc','freemium',12,NULL,0,0,NULL),
	 ('2023-06-13','yandex','cpc','dod-professions',12,46860,0,0,NULL),
	 ('2023-06-13','yandex','cpc','dod-frontend',10,41230,0,0,NULL),
	 ('2023-06-13','yandex','cpc','dod-python-java',9,NULL,0,0,NULL),
	 ('2023-06-13','telegram','cpp','prof-java',8,NULL,0,0,NULL),
	 ('2023-06-13','yandex','cpc','base-professions-retarget',5,4040,0,0,NULL),
	 ('2023-06-13','vk','cpm','prof-data-analytics',4,NULL,0,0,NULL),
	 ('2023-06-13','yandex','cpc','dod-java',4,NULL,0,0,NULL),
	 ('2023-06-13','telegram','cpp','prof-frontend',3,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-13','timepad','cpp','base-frontend',3,NULL,0,0,NULL),
	 ('2023-06-13','yandex','cpc','dod-php',3,NULL,0,0,NULL),
	 ('2023-06-13','vk','cpp','dod-frontend',2,NULL,0,0,NULL),
	 ('2023-06-13','vk','social','base-frontend',2,NULL,0,0,NULL),
	 ('2023-06-13','vk','social','base-python',2,NULL,0,0,NULL),
	 ('2023-06-13','vk','social','hexlet-blog',2,NULL,0,0,NULL),
	 ('2023-06-13','yandex','cpc','dod-qa',2,NULL,0,0,NULL),
	 ('2023-06-13','Yandex','cpc','80100720',1,NULL,0,0,NULL),
	 ('2023-06-13','facebook','cpc','python',1,NULL,0,0,NULL),
	 ('2023-06-13','facebook','social','hexlet-blog',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-13','facebook','social','my-sozdali-kurs-osnovy-redis-pro-rabot',1,NULL,0,0,NULL),
	 ('2023-06-13','telegram','cpm','base_java',1,NULL,0,0,NULL),
	 ('2023-06-13','telegram','cpp','base-java',1,NULL,0,0,NULL),
	 ('2023-06-13','telegram','cpp','base-python',1,NULL,0,0,NULL),
	 ('2023-06-13','telegram','cpp','dod-php',1,NULL,0,0,NULL),
	 ('2023-06-13','telegram','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-13','vc','cpp','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-13','vc','cpp','dod-professions',1,NULL,0,0,NULL),
	 ('2023-06-13','vk','cpc','base',1,NULL,0,0,NULL),
	 ('2023-06-13','vk','cpc','dod-professions',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-13','vk','cpm','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-13','vk','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-13','vk','cpp','dod-php',1,NULL,0,0,NULL),
	 ('2023-06-13','vk','cpp','intensive-python',1,NULL,0,0,NULL),
	 ('2023-06-13','vk','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-13','vk','social','english-soft',1,NULL,0,0,NULL),
	 ('2023-06-13','vk','social','general',1,NULL,0,0,NULL),
	 ('2023-06-13','vk','social','hexlet.io/my',1,NULL,0,0,NULL),
	 ('2023-06-13','vk','social','prof-rails',1,NULL,0,0,NULL),
	 ('2023-06-13','zen','social','all-courses',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-14','yandex','cpc','freemium',215,4031680,0,0,NULL),
	 ('2023-06-14','yandex','cpc','prof-python',170,7100220,0,0,NULL),
	 ('2023-06-14','yandex','cpc','prof-frontend',165,11652960,0,0,NULL),
	 ('2023-06-14','yandex','cpc','prof-java',163,6055613,0,0,NULL),
	 ('2023-06-14','yandex','cpc','base-java',57,NULL,0,0,NULL),
	 ('2023-06-14','yandex','cpc','base-python',53,NULL,0,0,NULL),
	 ('2023-06-14','yandex','cpc','prof-professions-brand',49,175420,0,0,NULL),
	 ('2023-06-14','admitad','cpa','admitad',44,NULL,0,0,NULL),
	 ('2023-06-14','timepad','cpp','base-frontend',43,NULL,0,0,NULL),
	 ('2023-06-14','yandex','cpc','base-frontend',42,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-14','yandex','cpc','prof-data-analytics',32,283328,0,0,NULL),
	 ('2023-06-14','yandex','cpc','prof-professions-retarget',27,18738,0,0,NULL),
	 ('2023-06-14','telegram','social','dod-professions',21,NULL,1,0,NULL),
	 ('2023-06-14','vk-senler','cpc','freemium',15,NULL,0,0,NULL),
	 ('2023-06-14','yandex','cpc','dod-frontend',15,14760,0,0,NULL),
	 ('2023-06-14','telegram','cpp','prof-python',13,NULL,0,0,NULL),
	 ('2023-06-14','telegram','cpp','base-frontend',12,NULL,0,0,NULL),
	 ('2023-06-14','yandex','cpc','dod-java',12,NULL,0,0,NULL),
	 ('2023-06-14','yandex','cpc','dod-professions',12,17652,0,0,NULL),
	 ('2023-06-14','vk','cpc','prof-data-analytics',10,41890,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-14','vk','cpc','freemium-frontend',8,19832,0,0,NULL),
	 ('2023-06-14','vk','cpc','freemium-python',8,23160,0,0,NULL),
	 ('2023-06-14','yandex','cpc','base-professions-retarget',8,5776,0,0,NULL),
	 ('2023-06-14','yandex','cpc','dod-php',8,NULL,0,0,NULL),
	 ('2023-06-14','vk','cpp','dod-frontend',7,NULL,0,0,NULL),
	 ('2023-06-14','yandex','cpc','dod-python-java',7,6363,0,0,NULL),
	 ('2023-06-14','yandex','cpc','dod-qa',7,NULL,0,0,NULL),
	 ('2023-06-14','vk','cpc','prof-frontend',5,25385,0,0,NULL),
	 ('2023-06-14','vk','cpc','prof-java',5,20560,0,0,NULL),
	 ('2023-06-14','vk','cpc','prof-python',5,25370,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-14','vk','social','dod-professions',4,NULL,0,0,NULL),
	 ('2023-06-14','telegram','cpp','base-python',3,NULL,0,0,NULL),
	 ('2023-06-14','telegram','cpp','prof-java',3,NULL,0,0,NULL),
	 ('2023-06-14','vc','cpp','dod-frontend',3,NULL,2,0,NULL),
	 ('2023-06-14','vk','social','base-python',3,NULL,0,0,NULL),
	 ('2023-06-14','vk','social','hexlet-blog',2,NULL,0,0,NULL),
	 ('2023-06-14','vk','social','prof-python',2,NULL,0,0,NULL),
	 ('2023-06-14','vk-senler','cpc','dod-frontend',2,NULL,0,0,NULL),
	 ('2023-06-14','facebook','cpc','freemium.ua-by',1,NULL,0,0,NULL),
	 ('2023-06-14','mytarget','cpc','freemium',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-14','telegram','cpp','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-14','telegram','cpp','dod-php',1,NULL,0,0,NULL),
	 ('2023-06-14','telegram','cpp','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-14','telegram','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-14','telegram','social','mdtruehaskell--funktsionalnyy-yazyk',1,NULL,0,0,NULL),
	 ('2023-06-14','telegram','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-14','twitter','social','51-letniy-student-heksleta-dmitriy-rassk',1,NULL,0,0,NULL),
	 ('2023-06-14','vk','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-14','vk','social','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-14','vk','social','general',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-14','vk-senler','cpc','dod-professions',1,NULL,0,0,NULL),
	 ('2023-06-14','yandex-direct','cpc','19183657',1,NULL,0,0,NULL),
	 ('2023-06-14','zen','social','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-15','yandex','cpc','freemium',238,3645446,0,0,NULL),
	 ('2023-06-15','yandex','cpc','prof-frontend',164,11344044,0,0,NULL),
	 ('2023-06-15','yandex','cpc','prof-python',156,6549192,0,0,NULL),
	 ('2023-06-15','yandex','cpc','prof-java',130,4537260,0,0,NULL),
	 ('2023-06-15','yandex','cpc','base-java',61,NULL,0,0,NULL),
	 ('2023-06-15','yandex','cpc','base-python',49,NULL,0,0,NULL),
	 ('2023-06-15','yandex','cpc','prof-professions-brand',49,270039,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-15','admitad','cpa','admitad',48,NULL,0,0,NULL),
	 ('2023-06-15','yandex','cpc','base-frontend',38,NULL,0,0,NULL),
	 ('2023-06-15','yandex','cpc','prof-data-analytics',28,183568,0,0,NULL),
	 ('2023-06-15','yandex','cpc','prof-professions-retarget',27,34830,0,0,NULL),
	 ('2023-06-15','yandex','cpc','dod-frontend',20,18160,0,0,NULL),
	 ('2023-06-15','yandex','cpc','dod-professions',17,66725,0,0,NULL),
	 ('2023-06-15','vk-senler','cpc','freemium',14,NULL,0,0,NULL),
	 ('2023-06-15','telegram','cpp','base-frontend',12,NULL,0,0,NULL),
	 ('2023-06-15','yandex','cpc','dod-python-java',10,45540,0,0,NULL),
	 ('2023-06-15','vk','cpc','freemium-python',9,22824,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-15','vk','cpc','prof-data-analytics',9,41076,0,0,NULL),
	 ('2023-06-15','yandex','cpc','base-professions-retarget',8,NULL,0,0,NULL),
	 ('2023-06-15','yandex','cpc','dod-java',8,NULL,0,0,NULL),
	 ('2023-06-15','vk','cpc','freemium-frontend',7,17738,0,0,NULL),
	 ('2023-06-15','yandex','cpc','dod-qa',7,NULL,0,0,NULL),
	 ('2023-06-15','telegram','cpp','prof-python',6,NULL,0,0,NULL),
	 ('2023-06-15','vk','cpc','freemium-java',6,15228,0,0,NULL),
	 ('2023-06-15','vk','cpc','prof-java',6,25584,0,0,NULL),
	 ('2023-06-15','yandex','cpc','dod-php',6,NULL,0,0,NULL),
	 ('2023-06-15','telegram','cpp','prof-java',5,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-15','vk','cpc','prof-frontend',5,23440,1,0,NULL),
	 ('2023-06-15','telegram','social','dod-professions',3,NULL,0,0,NULL),
	 ('2023-06-15','vk','cpc','prof-python',3,17511,0,0,NULL),
	 ('2023-06-15','vk','cpp','dod-frontend',3,NULL,0,0,NULL),
	 ('2023-06-15','vk','social','all-courses',3,NULL,0,0,NULL),
	 ('2023-06-15','vk','social','hexlet-blog',3,NULL,0,0,NULL),
	 ('2023-06-15','dzen','social','dzen_post',2,NULL,1,0,NULL),
	 ('2023-06-15','telegram','cpp','base-java',2,NULL,0,0,NULL),
	 ('2023-06-15','telegram','social','course_completed',2,NULL,0,0,NULL),
	 ('2023-06-15','vk','cpp','base-frontend',2,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-15','vk-senler','cpc','dod-frontend',2,NULL,0,0,NULL),
	 ('2023-06-15','dzen','social','dzen-post',1,NULL,0,0,NULL),
	 ('2023-06-15','facebook','cpc','python',1,NULL,0,0,NULL),
	 ('2023-06-15','instagram','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-15','podcast','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-15','slack','social','hexlet',1,NULL,0,0,NULL),
	 ('2023-06-15','telegram','cpm','java',1,NULL,0,0,NULL),
	 ('2023-06-15','telegram','cpp','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-15','telegram','cpp','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-15','telegram','social','prof-qa',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-15','telegram','social','webinars',1,NULL,0,0,NULL),
	 ('2023-06-15','timepad','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-15','twitter','social','grokaem_algoritmy',1,NULL,0,0,NULL),
	 ('2023-06-15','twitter','social','oop-i-arhitektura-koda-kirill-mokevni',1,NULL,0,0,NULL),
	 ('2023-06-15','twitter','social','podrobno-rasskazyvaem--pochemu-pleysholde',1,NULL,0,0,NULL),
	 ('2023-06-15','twitter.com','social','istorii-uspeha-nashih-uchenikov-i-vypuskni',1,NULL,0,0,NULL),
	 ('2023-06-15','vc','cpp','dod-professions',1,NULL,0,0,NULL),
	 ('2023-06-15','vk','cpc','yaintern',1,NULL,0,0,NULL),
	 ('2023-06-15','vk','social','base-python',1,NULL,0,0,NULL),
	 ('2023-06-15','vk','social','dod-professions',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-15','vkontakte','social','button-vk',1,NULL,0,0,NULL),
	 ('2023-06-15','zen','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-16','yandex','cpc','freemium',233,4173729,0,0,NULL),
	 ('2023-06-16','yandex','cpc','prof-python',168,6588120,0,0,NULL),
	 ('2023-06-16','yandex','cpc','prof-frontend',137,8074095,0,0,NULL),
	 ('2023-06-16','yandex','cpc','prof-java',112,4083408,0,0,NULL),
	 ('2023-06-16','yandex','cpc','base-java',59,NULL,0,0,NULL),
	 ('2023-06-16','yandex','cpc','base-python',51,NULL,0,0,NULL),
	 ('2023-06-16','yandex','cpc','prof-professions-brand',48,278112,0,0,NULL),
	 ('2023-06-16','yandex','cpc','base-frontend',44,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-16','yandex','cpc','prof-data-analytics',39,217464,0,0,NULL),
	 ('2023-06-16','admitad','cpa','admitad',37,NULL,0,0,NULL),
	 ('2023-06-16','yandex','cpc','prof-professions-retarget',35,37975,0,0,NULL),
	 ('2023-06-16','yandex','cpc','dod-frontend',22,NULL,0,0,NULL),
	 ('2023-06-16','yandex','cpc','dod-professions',15,46155,0,0,NULL),
	 ('2023-06-16','vk','cpc','prof-data-analytics',13,59722,0,0,NULL),
	 ('2023-06-16','vk','cpc','prof-python',13,75894,1,0,NULL),
	 ('2023-06-16','yandex','cpc','dod-java',12,NULL,0,0,NULL),
	 ('2023-06-16','vk-senler','cpc','freemium',11,NULL,0,0,NULL),
	 ('2023-06-16','yandex','cpc','base-professions-retarget',10,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-16','telegram','cpp','base-frontend',9,NULL,0,0,NULL),
	 ('2023-06-16','vk','cpc','prof-java',9,39843,1,0,NULL),
	 ('2023-06-16','vk','cpc','prof-frontend',8,43664,1,0,NULL),
	 ('2023-06-16','vk','cpc','freemium-java',7,16786,0,0,NULL),
	 ('2023-06-16','yandex','cpc','dod-php',6,NULL,0,0,NULL),
	 ('2023-06-16','telegram','cpp','prof-python',5,NULL,0,0,NULL),
	 ('2023-06-16','vk','cpc','freemium-python',5,12685,0,0,NULL),
	 ('2023-06-16','yandex','cpc','dod-python-java',5,16295,0,0,NULL),
	 ('2023-06-16','yandex','cpc','dod-qa',5,NULL,0,0,NULL),
	 ('2023-06-16','telegram','social','dod-professions',4,NULL,1,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-16','vk','cpc','freemium-frontend',4,10140,0,0,NULL),
	 ('2023-06-16','telegram','cpp','prof-java',3,NULL,0,0,NULL),
	 ('2023-06-16','vk','social','base-python',3,NULL,0,0,NULL),
	 ('2023-06-16','telegram','cpp','dod-java',2,NULL,0,0,NULL),
	 ('2023-06-16','vk','cpc','php',2,NULL,0,0,NULL),
	 ('2023-06-16','vk','social','dod-professions',2,NULL,0,0,NULL),
	 ('2023-06-16','vk','social','prof-python',2,NULL,0,0,NULL),
	 ('2023-06-16','admitad','cpa','442763',1,NULL,0,0,NULL),
	 ('2023-06-16','admitad','cpc','183258',1,NULL,0,0,NULL),
	 ('2023-06-16','instagram','social','base-python',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-16','instagram','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-16','slack','social','hexlet',1,NULL,0,0,NULL),
	 ('2023-06-16','telegram','cpm','java',1,NULL,0,0,NULL),
	 ('2023-06-16','telegram','cpp','base-java',1,NULL,0,0,NULL),
	 ('2023-06-16','telegram','cpp','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-16','telegram','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-16','telegram Этот курс побеждён! 💪💪💪 Было круто! 🚀','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-16','timepad','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-16','twitter','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-16','twitter','social','v-etoy-statie-my-dadim-neskolko-sovetov',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-16','twitter','social','v-kontse-yanvarya-praktika-heksleta-ne-rabo',1,NULL,0,0,NULL),
	 ('2023-06-16','vk','cpc','prof-php',1,NULL,0,0,NULL),
	 ('2023-06-16','vk','cpc','yaintern',1,NULL,0,0,NULL),
	 ('2023-06-16','vk','cpm','base',1,NULL,0,0,NULL),
	 ('2023-06-16','vk','cpp','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-16','vk','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-16','vk','social','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-16','vk','social','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-16','vk','social','general',1,NULL,0,0,NULL),
	 ('2023-06-17','yandex','cpc','freemium',200,2882600,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-17','yandex','cpc','prof-python',174,7854186,0,0,NULL),
	 ('2023-06-17','yandex','cpc','prof-frontend',132,7902972,0,0,NULL),
	 ('2023-06-17','yandex','cpc','prof-java',131,3603810,0,0,NULL),
	 ('2023-06-17','yandex','cpc','base-python',63,NULL,0,0,NULL),
	 ('2023-06-17','yandex','cpc','prof-professions-brand',58,224924,0,0,NULL),
	 ('2023-06-17','yandex','cpc','base-java',43,NULL,0,0,NULL),
	 ('2023-06-17','yandex','cpc','base-frontend',39,NULL,0,0,NULL),
	 ('2023-06-17','admitad','cpa','admitad',38,NULL,0,0,NULL),
	 ('2023-06-17','yandex','cpc','prof-data-analytics',34,260542,0,0,NULL),
	 ('2023-06-17','yandex','cpc','dod-professions',25,119250,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-17','yandex','cpc','prof-professions-retarget',22,24266,0,0,NULL),
	 ('2023-06-17','vk-senler','cpc','freemium',15,NULL,0,0,NULL),
	 ('2023-06-17','yandex','cpc','dod-frontend',13,NULL,0,0,NULL),
	 ('2023-06-17','yandex','cpc','dod-php',11,NULL,0,0,NULL),
	 ('2023-06-17','yandex','cpc','dod-qa',11,NULL,0,0,NULL),
	 ('2023-06-17','yandex','cpc','dod-python-java',9,19242,0,0,NULL),
	 ('2023-06-17','telegram','cpp','base-frontend',8,NULL,0,0,NULL),
	 ('2023-06-17','vk','cpc','prof-python',8,58896,0,0,NULL),
	 ('2023-06-17','yandex','cpc','base-professions-retarget',8,NULL,0,0,NULL),
	 ('2023-06-17','vk','cpc','prof-frontend',7,34818,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-17','vk','cpc','prof-java',6,24744,0,0,NULL),
	 ('2023-06-17','yandex','cpc','dod-java',6,NULL,0,0,NULL),
	 ('2023-06-17','vk','cpc','freemium-java',5,7610,0,0,NULL),
	 ('2023-06-17','vk','cpc','prof-data-analytics',5,26635,0,0,NULL),
	 ('2023-06-17','vk','social','dod-professions',5,NULL,0,0,NULL),
	 ('2023-06-17','vk','cpc','freemium-frontend',4,10144,0,0,NULL),
	 ('2023-06-17','vk','cpc','freemium-python',4,10148,0,0,NULL),
	 ('2023-06-17','telegram','cpp','prof-frontend',3,NULL,0,0,NULL),
	 ('2023-06-17','telegram','cpp','base-java',2,NULL,0,0,NULL),
	 ('2023-06-17','vk','cpc','frontend',2,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-17','vk','social','general',2,NULL,0,0,NULL),
	 ('2023-06-17','Yandex','cpc','06892634',1,NULL,0,0,NULL),
	 ('2023-06-17','Yandex','cpc','93234055',1,NULL,0,0,NULL),
	 ('2023-06-17','facebook','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-17','instagram','social','prof-data-analyst',1,NULL,0,0,NULL),
	 ('2023-06-17','telegram','cpm','base_python',1,NULL,0,0,NULL),
	 ('2023-06-17','telegram','cpm','frontend',1,NULL,0,0,NULL),
	 ('2023-06-17','telegram','cpm','java',1,NULL,0,0,NULL),
	 ('2023-06-17','telegram','cpp','base-python',1,NULL,0,0,NULL),
	 ('2023-06-17','telegram','cpp','prof-java',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-17','telegram','cpp','prof-python',1,NULL,0,0,NULL),
	 ('2023-06-17','timepad','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-17','vk','cpc','prof-qa',1,NULL,0,0,NULL),
	 ('2023-06-17','vk','cpm','base',1,NULL,0,0,NULL),
	 ('2023-06-17','vk','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-17','vk','social','prof-data-analytics',1,NULL,0,0,NULL),
	 ('2023-06-17','vk','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-17','yandex-direct','cpc','50088205',1,NULL,0,0,NULL),
	 ('2023-06-17','zen','social','zen_post',1,NULL,0,0,NULL),
	 ('2023-06-18','yandex','cpc','freemium',219,3678762,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-18','yandex','cpc','prof-python',163,6394979,0,0,NULL),
	 ('2023-06-18','yandex','cpc','prof-frontend',149,7570094,0,0,NULL),
	 ('2023-06-18','yandex','cpc','prof-java',111,3175155,0,0,NULL),
	 ('2023-06-18','yandex','cpc','base-java',61,NULL,0,0,NULL),
	 ('2023-06-18','yandex','cpc','prof-professions-brand',51,168300,0,0,NULL),
	 ('2023-06-18','admitad','cpa','admitad',50,NULL,0,0,NULL),
	 ('2023-06-18','yandex','cpc','base-python',43,NULL,0,0,NULL),
	 ('2023-06-18','yandex','cpc','base-frontend',27,NULL,0,0,NULL),
	 ('2023-06-18','yandex','cpc','prof-data-analytics',27,174042,0,0,NULL),
	 ('2023-06-18','yandex','cpc','prof-professions-retarget',25,37275,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-18','yandex','cpc','dod-frontend',21,NULL,0,0,NULL),
	 ('2023-06-18','yandex','cpc','dod-professions',14,104132,0,0,NULL),
	 ('2023-06-18','vk-senler','cpc','freemium',13,NULL,0,0,NULL),
	 ('2023-06-18','yandex','cpc','dod-php',11,NULL,0,0,NULL),
	 ('2023-06-18','telegram','cpp','base-frontend',9,NULL,0,0,NULL),
	 ('2023-06-18','vk','cpc','prof-data-analytics',9,32211,0,0,NULL),
	 ('2023-06-18','yandex','cpc','base-professions-retarget',9,NULL,0,0,NULL),
	 ('2023-06-18','vk-senler','cpc','dod-professions',8,NULL,0,0,NULL),
	 ('2023-06-18','yandex','cpc','dod-java',8,NULL,0,0,NULL),
	 ('2023-06-18','yandex','cpc','dod-python-java',8,26992,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-18','vk','cpc','freemium-python',6,15216,0,0,NULL),
	 ('2023-06-18','vk','cpc','prof-java',6,27978,0,0,NULL),
	 ('2023-06-18','vk','cpc','freemium-frontend',5,12675,0,0,NULL),
	 ('2023-06-18','vk','cpc','prof-python',4,18364,0,0,NULL),
	 ('2023-06-18','vk','social','dod-professions',4,NULL,0,0,NULL),
	 ('2023-06-18','yandex','cpc','dod-qa',4,NULL,0,0,NULL),
	 ('2023-06-18','telegram','cpp','base-java',2,NULL,0,0,NULL),
	 ('2023-06-18','telegram','cpp','base-python',2,NULL,0,0,NULL),
	 ('2023-06-18','telegram','cpp','prof-python',2,NULL,0,0,NULL),
	 ('2023-06-18','vc','cpp','dod-professions',2,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-18','vk','cpc','prof-frontend',2,5824,0,0,NULL),
	 ('2023-06-18','Yandex','cpc','39770358',1,NULL,0,0,NULL),
	 ('2023-06-18','Yandex','cpc','77386453',1,NULL,0,0,NULL),
	 ('2023-06-18','Yandex','cpc','81276251',1,NULL,0,0,NULL),
	 ('2023-06-18','facebook','cpc','freemium',1,NULL,0,0,NULL),
	 ('2023-06-18','partners','cpm','all',1,NULL,0,0,NULL),
	 ('2023-06-18','telegram','cpp','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-18','telegram','cpp','prof-java',1,NULL,0,0,NULL),
	 ('2023-06-18','telegram','cpp','prof-qa',1,NULL,0,0,NULL),
	 ('2023-06-18','telegram','social','base-frontend',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-18','telegram','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-18','telegram','social','mdtruehaskell--funktsionalnyy-yazyk',1,NULL,0,0,NULL),
	 ('2023-06-18','twitter','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-18','twitter','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-18','vk','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-18','vk','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-18','vk','social','prof-python',1,NULL,0,0,NULL),
	 ('2023-06-18','vk-senler','cpc','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-18','vkontakte','social','button-vk',1,NULL,0,0,NULL),
	 ('2023-06-18','yandex-direct','cpc','97574364',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-18','zen','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-18','zen','social','prof-data-analyst',1,NULL,0,0,NULL),
	 ('2023-06-19','yandex','cpc','freemium',239,4113668,0,0,NULL),
	 ('2023-06-19','yandex','cpc','prof-python',185,8508150,0,0,NULL),
	 ('2023-06-19','yandex','cpc','prof-java',143,5024448,0,0,NULL),
	 ('2023-06-19','yandex','cpc','prof-frontend',135,9850410,0,0,NULL),
	 ('2023-06-19','yandex','cpc','base-java',66,NULL,0,0,NULL),
	 ('2023-06-19','yandex','cpc','base-python',60,NULL,0,0,NULL),
	 ('2023-06-19','yandex','cpc','prof-professions-brand',45,139995,0,0,NULL),
	 ('2023-06-19','yandex','cpc','base-frontend',43,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-19','admitad','cpa','admitad',35,NULL,0,0,NULL),
	 ('2023-06-19','yandex','cpc','prof-data-analytics',35,211680,0,0,NULL),
	 ('2023-06-19','yandex','cpc','dod-frontend',18,NULL,0,0,NULL),
	 ('2023-06-19','yandex','cpc','prof-professions-retarget',18,19026,0,0,NULL),
	 ('2023-06-19','vk','cpc','prof-python',15,74010,0,0,NULL),
	 ('2023-06-19','yandex','cpc','base-professions-retarget',14,NULL,0,0,NULL),
	 ('2023-06-19','vk-senler','cpc','freemium',12,NULL,0,0,NULL),
	 ('2023-06-19','vk','cpc','prof-java',10,54690,0,0,NULL),
	 ('2023-06-19','vk','cpc','prof-frontend',9,45702,0,0,NULL),
	 ('2023-06-19','telegram','cpp','base-frontend',8,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-19','vk','cpc','freemium-python',8,19832,0,0,NULL),
	 ('2023-06-19','vk','cpc','prof-data-analytics',8,42608,0,0,NULL),
	 ('2023-06-19','yandex','cpc','dod-python-java',8,16096,0,0,NULL),
	 ('2023-06-19','yandex','cpc','dod-qa',8,NULL,0,0,NULL),
	 ('2023-06-19','yandex','cpc','dod-java',6,NULL,0,0,NULL),
	 ('2023-06-19','yandex','cpc','dod-php',6,NULL,0,0,NULL),
	 ('2023-06-19','yandex','cpc','dod-professions',6,22098,0,0,NULL),
	 ('2023-06-19','vk','cpp','dod-python-java',4,NULL,0,0,NULL),
	 ('2023-06-19','twitter.com','social','istorii-uspeha-nashih-uchenikov-i-vypuskni',3,NULL,0,0,NULL),
	 ('2023-06-19','vk','cpc','freemium-java',3,7269,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-19','vk','social','base-python',3,NULL,0,0,NULL),
	 ('2023-06-19','telegram','cpp','prof-python',2,NULL,0,0,NULL),
	 ('2023-06-19','twitter','social','hexlet-blog',2,NULL,0,0,NULL),
	 ('2023-06-19','vk','cpc','freemium-frontend',2,5072,0,0,NULL),
	 ('2023-06-19','vk','social','base-java',2,NULL,0,0,NULL),
	 ('2023-06-19','vk','social','general',2,NULL,0,0,NULL),
	 ('2023-06-19','Yandex','cpc','52168119',1,NULL,0,0,NULL),
	 ('2023-06-19','Yandex','cpm','84109871',1,NULL,0,0,NULL),
	 ('2023-06-19','dzen','social','dzen-post',1,NULL,0,0,NULL),
	 ('2023-06-19','instagram','social','all-courses',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-19','instagram','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-19','telegram','cpm','java',1,NULL,0,0,NULL),
	 ('2023-06-19','telegram','cpp','base-python',1,NULL,0,0,NULL),
	 ('2023-06-19','telegram','cpp','dod-java',1,NULL,0,0,NULL),
	 ('2023-06-19','telegram','social','kak-blagodarya-heksletu-ya-ustroilsya-v-epa',1,NULL,0,0,NULL),
	 ('2023-06-19','telegram','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-19','telegram','social','special-newyear23',1,NULL,0,0,NULL),
	 ('2023-06-19','timepad','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-19','twitter','social','devushki_v_it',1,NULL,0,0,NULL),
	 ('2023-06-19','twitter','social','obuchenie-programmirovaniyu-v-30 -let-pod',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-19','vc','cpp','dod-professions',1,NULL,0,0,NULL),
	 ('2023-06-19','vk','cpp','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-19','vk','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-19','vk','social','base-php',1,NULL,0,0,NULL),
	 ('2023-06-19','vk','social','dod-professions',1,NULL,0,0,NULL),
	 ('2023-06-19','zen','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-19','zen','social','hexlet',1,NULL,0,0,NULL),
	 ('2023-06-20','yandex','cpc','freemium',242,3907090,0,0,NULL),
	 ('2023-06-20','yandex','cpc','prof-python',184,8474120,0,0,NULL),
	 ('2023-06-20','yandex','cpc','prof-frontend',148,10145252,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-20','yandex','cpc','prof-java',119,3339497,0,0,NULL),
	 ('2023-06-20','yandex','cpc','base-python',58,NULL,0,0,NULL),
	 ('2023-06-20','yandex','cpc','base-java',53,201665,0,0,NULL),
	 ('2023-06-20','yandex','cpc','prof-professions-brand',47,153361,0,0,NULL),
	 ('2023-06-20','admitad','cpa','admitad',43,NULL,1,0,NULL),
	 ('2023-06-20','yandex','cpc','prof-data-analytics',38,258210,0,0,NULL),
	 ('2023-06-20','yandex','cpc','base-frontend',33,NULL,0,0,NULL),
	 ('2023-06-20','yandex','cpc','prof-professions-retarget',27,21168,0,0,NULL),
	 ('2023-06-20','yandex','cpc','dod-frontend',17,NULL,0,0,NULL),
	 ('2023-06-20','yandex','cpc','dod-professions',17,109174,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-20','vk-senler','cpc','freemium',14,NULL,0,0,NULL),
	 ('2023-06-20','vk','cpc','prof-python',13,75907,0,0,NULL),
	 ('2023-06-20','vk','cpc','freemium-frontend',11,31361,0,0,NULL),
	 ('2023-06-20','yandex','cpc','dod-python-java',10,32690,0,0,NULL),
	 ('2023-06-20','vk','cpc','freemium-java',8,20304,0,0,NULL),
	 ('2023-06-20','vk','cpc','prof-java',8,41640,0,0,NULL),
	 ('2023-06-20','instagram','social','base-frontend',7,NULL,0,0,NULL),
	 ('2023-06-20','yandex','cpc','dod-php',7,NULL,0,0,NULL),
	 ('2023-06-20','telegram','cpp','base-frontend',6,NULL,0,0,NULL),
	 ('2023-06-20','yandex','cpc','dod-java',6,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-20','telegram','social','dod-professions',5,NULL,0,0,NULL),
	 ('2023-06-20','vk','cpc','prof-data-analytics',5,24705,0,0,NULL),
	 ('2023-06-20','vk','cpp','dod-python-java',5,NULL,0,0,NULL),
	 ('2023-06-20','yandex','cpc','dod-qa',5,NULL,0,0,NULL),
	 ('2023-06-20','instagram','social','prof-frontend',4,NULL,0,0,NULL),
	 ('2023-06-20','instagram','social','prof-qa-auto',4,NULL,1,0,NULL),
	 ('2023-06-20','vk','cpc','freemium-python',3,6381,0,0,NULL),
	 ('2023-06-20','vk','cpc','prof-frontend',3,15234,0,0,NULL),
	 ('2023-06-20','vk','social','dod-professions',3,NULL,0,0,NULL),
	 ('2023-06-20','instagram','social','prof-backend',2,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-20','telegram','cpp','base-python',2,NULL,0,0,NULL),
	 ('2023-06-20','vk','social','hexlet-blog',2,NULL,0,0,NULL),
	 ('2023-06-20','yandex','cpc','base-professions-retarget',2,NULL,0,0,NULL),
	 ('2023-06-20','Yandex','cpm','14191988',1,NULL,0,0,NULL),
	 ('2023-06-20','instagram','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-20','instagram','social','prof-java',1,NULL,0,0,NULL),
	 ('2023-06-20','instagram','social','prof-python',1,NULL,0,0,NULL),
	 ('2023-06-20','instagram','social','prof-qa',1,NULL,0,0,NULL),
	 ('2023-06-20','instagram','social','prof-rails',1,NULL,0,0,NULL),
	 ('2023-06-20','telegram','cpm','frontend',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-20','telegram','cpp','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-20','telegram','cpp','prof-java',1,NULL,0,0,NULL),
	 ('2023-06-20','telegram','social','mdtruereshenie-zadach--horoshiy-sposob-z',1,NULL,0,0,NULL),
	 ('2023-06-20','twitter','social','my-poprosili-nastavnikov-heksleta-rasska',1,NULL,0,0,NULL),
	 ('2023-06-20','twitter.com','social','buffer',1,NULL,0,0,NULL),
	 ('2023-06-20','vc','cpp','dod-professions',1,NULL,1,0,NULL),
	 ('2023-06-20','vk','social','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-20','vk','social','base-java',1,NULL,0,0,NULL),
	 ('2023-06-20','vk','social','base-python',1,NULL,0,0,NULL),
	 ('2023-06-20','vk','social','dod-python-java',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-20','vk-senler','cpc','dod-professions',1,NULL,0,0,NULL),
	 ('2023-06-20','yandex-direct','cpc','26593528',1,NULL,0,0,NULL),
	 ('2023-06-20','yandex-direct','cpc','70989018',1,NULL,0,0,NULL),
	 ('2023-06-20','yandex-direct','cpc','85838400',1,NULL,0,0,NULL),
	 ('2023-06-20','zen','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-21','yandex','cpc','freemium',225,4268925,0,0,NULL),
	 ('2023-06-21','yandex','cpc','prof-python',155,7260200,0,0,NULL),
	 ('2023-06-21','yandex','cpc','prof-frontend',140,9023560,0,0,NULL),
	 ('2023-06-21','yandex','cpc','prof-java',126,3672144,0,0,NULL),
	 ('2023-06-21','yandex','cpc','base-java',59,304263,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-21','yandex','cpc','base-frontend',55,NULL,0,0,NULL),
	 ('2023-06-21','admitad','cpa','admitad',51,NULL,0,0,NULL),
	 ('2023-06-21','yandex','cpc','base-python',44,208604,0,0,NULL),
	 ('2023-06-21','yandex','cpc','prof-professions-brand',42,181440,0,0,NULL),
	 ('2023-06-21','yandex','cpc','prof-data-analytics',32,125440,0,0,NULL),
	 ('2023-06-21','yandex','cpc','prof-professions-retarget',25,21850,0,0,NULL),
	 ('2023-06-21','vk','cpc','prof-python',18,106020,0,0,NULL),
	 ('2023-06-21','yandex','cpc','dod-frontend',16,NULL,0,0,NULL),
	 ('2023-06-21','vk','cpc','prof-data-analytics',13,79170,0,0,NULL),
	 ('2023-06-21','yandex','cpc','dod-java',13,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-21','vk-senler','cpc','freemium',12,NULL,0,0,NULL),
	 ('2023-06-21','yandex','cpc','dod-python-java',12,24072,0,0,NULL),
	 ('2023-06-21','telegram','cpp','prof-java',11,NULL,0,0,NULL),
	 ('2023-06-21','yandex','cpc','dod-professions',11,NULL,0,0,NULL),
	 ('2023-06-21','telegram','cpp','prof-python',10,NULL,1,0,NULL),
	 ('2023-06-21','vk','cpc','prof-frontend',9,45711,0,0,NULL),
	 ('2023-06-21','yandex','cpc','dod-qa',9,NULL,0,0,NULL),
	 ('2023-06-21','vk','cpc','prof-java',8,42056,0,0,NULL),
	 ('2023-06-21','vk','cpc','freemium-frontend',7,17759,0,0,NULL),
	 ('2023-06-21','vk','cpp','dod-python-java',7,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-21','vk','cpc','freemium-java',6,15222,0,0,NULL),
	 ('2023-06-21','yandex','cpc','base-professions-retarget',6,NULL,0,0,NULL),
	 ('2023-06-21','telegram','cpp','base-java',5,NULL,0,0,NULL),
	 ('2023-06-21','vk','cpc','freemium-python',5,10965,0,0,NULL),
	 ('2023-06-21','yandex','cpc','dod-php',5,NULL,0,0,NULL),
	 ('2023-06-21','instagram','social','prof-frontend',4,NULL,0,0,NULL),
	 ('2023-06-21','telegram','cpp','base-frontend',3,NULL,0,0,NULL),
	 ('2023-06-21','instagram','social','prof-qa',2,NULL,0,0,NULL),
	 ('2023-06-21','telegram','social','dod-professions',2,NULL,0,0,NULL),
	 ('2023-06-21','vk','social','general',2,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-21','Yandex','cpc','08409986',1,NULL,0,0,NULL),
	 ('2023-06-21','Yandex','cpc','74431025',1,NULL,0,0,NULL),
	 ('2023-06-21','admitad','cpc','442763',1,NULL,0,0,NULL),
	 ('2023-06-21','dzen','social','dzen-post',1,NULL,0,0,NULL),
	 ('2023-06-21','facebook','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-21','instagram','social','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-21','instagram','social','prof-backend',1,NULL,0,0,NULL),
	 ('2023-06-21','instagram','social','prof-data-analytics',1,NULL,0,0,NULL),
	 ('2023-06-21','instagram','social','prof-java',1,NULL,0,0,NULL),
	 ('2023-06-21','instagram','social','prof-python',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-21','telegram','cpm','python',1,NULL,0,0,NULL),
	 ('2023-06-21','telegram','cpp','dod-java',1,NULL,0,0,NULL),
	 ('2023-06-21','telegram','cpp','prof-data-analytics',1,NULL,0,0,NULL),
	 ('2023-06-21','telegram','social','kak-optimizirovat-tretiy-proekt-v-professii-python',1,NULL,0,0,NULL),
	 ('2023-06-21','telegram','social','mdtruehaskell--funktsionalnyy-yazyk',1,NULL,0,0,NULL),
	 ('2023-06-21','telegram','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-21','telegram','social','u-nas-chasto-sprashivayut--kakie-knigi-nuzhn',1,NULL,0,0,NULL),
	 ('2023-06-21','tg','social','hostel',1,NULL,0,0,NULL),
	 ('2023-06-21','twitter','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-21','twitter','social','promo',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-21','vk','cpc','freemium',1,NULL,0,0,NULL),
	 ('2023-06-21','vk','cpc','prof-php',1,NULL,0,0,NULL),
	 ('2023-06-21','vk','social','base-java',1,NULL,0,0,NULL),
	 ('2023-06-21','vk','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-21','vk','social','dod-professions',1,NULL,0,0,NULL),
	 ('2023-06-21','vk','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-21','vk','social','prof-python',1,NULL,0,0,NULL),
	 ('2023-06-21','vk.com','social','skolko-stoit-obuchenie-na-hekslete-dlya',1,NULL,0,0,NULL),
	 ('2023-06-21','yandex-direct','cpc','71522986',1,NULL,0,0,NULL),
	 ('2023-06-21','zen','social','hexlet',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-21','zen','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-22','yandex','cpc','freemium',251,3684680,0,0,NULL),
	 ('2023-06-22','yandex','cpc','prof-frontend',175,12245800,0,0,NULL),
	 ('2023-06-22','yandex','cpc','prof-python',163,8244377,0,0,NULL),
	 ('2023-06-22','yandex','cpc','prof-java',129,4628649,0,0,NULL),
	 ('2023-06-22','admitad','cpa','admitad',67,NULL,0,0,NULL),
	 ('2023-06-22','yandex','cpc','base-java',66,540210,0,0,NULL),
	 ('2023-06-22','yandex','cpc','base-python',65,259090,0,0,NULL),
	 ('2023-06-22','yandex','cpc','base-frontend',51,NULL,0,0,NULL),
	 ('2023-06-22','yandex','cpc','prof-professions-brand',41,170601,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-22','yandex','cpc','prof-data-analytics',29,42398,0,0,NULL),
	 ('2023-06-22','yandex','cpc','dod-frontend',20,NULL,0,0,NULL),
	 ('2023-06-22','yandex','cpc','prof-professions-retarget',19,20387,0,0,NULL),
	 ('2023-06-22','vk-senler','cpc','freemium',18,NULL,0,0,NULL),
	 ('2023-06-22','vk','cpc','prof-python',17,93925,0,0,NULL),
	 ('2023-06-22','vk','cpc','prof-java',13,54899,0,0,NULL),
	 ('2023-06-22','yandex','cpc','dod-professions',12,NULL,0,0,NULL),
	 ('2023-06-22','yandex','cpc','dod-php',11,NULL,0,0,NULL),
	 ('2023-06-22','yandex','cpc','dod-python-java',10,49880,0,0,NULL),
	 ('2023-06-22','vk','cpc','freemium-frontend',9,23607,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-22','vk','cpc','prof-data-analytics',9,53676,0,0,NULL),
	 ('2023-06-22','telegram','cpp','prof-java',7,NULL,0,0,NULL),
	 ('2023-06-22','vk','cpc','prof-frontend',7,25788,0,0,NULL),
	 ('2023-06-22','vk','cpp','dod-python-java',7,NULL,0,0,NULL),
	 ('2023-06-22','yandex','cpc','base-professions-retarget',7,NULL,0,0,NULL),
	 ('2023-06-22','yandex','cpc','dod-java',7,NULL,0,0,NULL),
	 ('2023-06-22','telegram','cpp','prof-python',6,NULL,0,0,NULL),
	 ('2023-06-22','vk','cpc','freemium-java',4,8576,0,0,NULL),
	 ('2023-06-22','yandex','cpc','dod-qa',4,NULL,0,0,NULL),
	 ('2023-06-22','dzen','social','dzen-post',3,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-22','vk','cpc','freemium-python',3,5616,0,0,NULL),
	 ('2023-06-22','telegram','social','dod-professions',2,NULL,0,0,NULL),
	 ('2023-06-22','tg','social','hostel',2,NULL,0,0,NULL),
	 ('2023-06-22','zen','social','all-courses',2,NULL,0,0,NULL),
	 ('2023-06-22','facebook','cpc','freemium',1,NULL,0,0,NULL),
	 ('2023-06-22','instagram','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-22','instagram','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-22','podcast','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-22','telegram','cpm','base_java',1,NULL,0,0,NULL),
	 ('2023-06-22','telegram','cpp','base-frontend',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-22','telegram','cpp','base-java',1,NULL,0,0,NULL),
	 ('2023-06-22','telegram','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-22','timepad','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-22','twitter','social','grokaem_algoritmy',1,NULL,0,0,NULL),
	 ('2023-06-22','vk','cpc','python',1,NULL,0,0,NULL),
	 ('2023-06-22','vk','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-22','vk','social','base-html',1,NULL,0,0,NULL),
	 ('2023-06-22','vk','social','base-python',1,NULL,0,0,NULL),
	 ('2023-06-22','vk','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-22','vk','social','dod-python-java',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-22','vk','social','planiruy-uchebu--fokusiruysya-na-protsesse',1,NULL,0,0,NULL),
	 ('2023-06-22','vk','social','prof-python',1,NULL,0,0,NULL),
	 ('2023-06-22','vk','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-22','yandex-direct','cpc','18177858',1,NULL,0,0,NULL),
	 ('2023-06-22','zen','social','hexlet',1,NULL,0,0,NULL),
	 ('2023-06-22','zen_from_telegram','social',NULL,1,NULL,0,0,NULL),
	 ('2023-06-23','yandex','cpc','freemium',255,4649925,0,0,NULL),
	 ('2023-06-23','yandex','cpc','prof-python',207,8620101,0,0,NULL),
	 ('2023-06-23','yandex','cpc','prof-frontend',182,10258976,0,0,NULL),
	 ('2023-06-23','yandex','cpc','prof-java',134,4615496,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-23','yandex','cpc','base-java',71,769853,0,0,NULL),
	 ('2023-06-23','yandex','cpc','base-python',66,546216,0,0,NULL),
	 ('2023-06-23','yandex','cpc','base-frontend',58,NULL,0,0,NULL),
	 ('2023-06-23','yandex','cpc','prof-professions-brand',49,197421,0,0,NULL),
	 ('2023-06-23','yandex','cpc','prof-data-analytics',43,351095,0,0,NULL),
	 ('2023-06-23','admitad','cpa','admitad',36,NULL,1,0,NULL),
	 ('2023-06-23','telegram','social','hexlet-blog',36,NULL,0,0,NULL),
	 ('2023-06-23','yandex','cpc','prof-professions-retarget',34,43316,0,0,NULL),
	 ('2023-06-23','yandex','cpc','dod-frontend',22,NULL,0,0,NULL),
	 ('2023-06-23','telegram','cpp','prof-java',18,NULL,1,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-23','yandex','cpc','dod-professions',18,NULL,0,0,NULL),
	 ('2023-06-23','vk','cpc','prof-data-analytics',16,79232,0,0,NULL),
	 ('2023-06-23','vk','cpc','prof-python',16,66384,0,0,NULL),
	 ('2023-06-23','vk-senler','cpc','freemium',16,NULL,0,0,NULL),
	 ('2023-06-23','vk','cpc','prof-frontend',11,41877,0,0,NULL),
	 ('2023-06-23','vk','cpc','freemium-frontend',9,22851,0,0,NULL),
	 ('2023-06-23','yandex','cpc','dod-python-java',9,6084,0,0,NULL),
	 ('2023-06-23','telegram','cpp','prof-python',8,NULL,0,0,NULL),
	 ('2023-06-23','yandex','cpc','base-professions-retarget',8,NULL,0,0,NULL),
	 ('2023-06-23','yandex','cpc','dod-php',8,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-23','yandex','cpc','dod-java',7,NULL,0,0,NULL),
	 ('2023-06-23','telegram','cpp','base-frontend',6,NULL,0,0,NULL),
	 ('2023-06-23','vk','cpc','freemium-java',6,15234,0,0,NULL),
	 ('2023-06-23','vk','cpc','base-python',5,11420,0,0,NULL),
	 ('2023-06-23','vk','cpc','prof-java',5,31730,0,0,NULL),
	 ('2023-06-23','yandex','cpc','dod-qa',5,NULL,0,0,NULL),
	 ('2023-06-23','timepad','cpp','base-frontend',3,NULL,0,0,NULL),
	 ('2023-06-23','telegram','social','dod-professions',2,NULL,0,0,NULL),
	 ('2023-06-23','vk','cpp','dod-python-java',2,NULL,0,0,NULL),
	 ('2023-06-23','vk','social','all-courses',2,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-23','vk','social','prof-python',2,NULL,0,0,NULL),
	 ('2023-06-23','zen','social','hexlet',2,NULL,0,0,NULL),
	 ('2023-06-23','facebook','cpc','freemium',1,NULL,0,0,NULL),
	 ('2023-06-23','instagram','social','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-23','instagram','social','prof-qa-auto',1,NULL,0,0,NULL),
	 ('2023-06-23','telegram','cpm','base_python',1,NULL,0,0,NULL),
	 ('2023-06-23','telegram','cpm','java',1,NULL,0,0,NULL),
	 ('2023-06-23','telegram','cpp','dod-php',1,NULL,0,0,NULL),
	 ('2023-06-23','telegram','cpp','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-23','telegram','social','base',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-23','telegram','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-23','twitter','social','how-to-sleep',1,NULL,0,0,NULL),
	 ('2023-06-23','vk','cpc','freemium-python',1,2034,0,0,NULL),
	 ('2023-06-23','vk','social','8-statey--kotorye-budut-polezny-novichku',1,NULL,0,0,NULL),
	 ('2023-06-23','vk','social','base-python',1,NULL,0,0,NULL),
	 ('2023-06-23','vk','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-23','vk','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-23','vk','social','open_lectures23',1,NULL,0,0,NULL),
	 ('2023-06-24','yandex','cpc','freemium',263,3768790,0,0,NULL),
	 ('2023-06-24','yandex','cpc','prof-frontend',172,9038256,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-24','yandex','cpc','prof-python',164,5732456,0,0,NULL),
	 ('2023-06-24','yandex','cpc','prof-java',129,3790149,0,0,NULL),
	 ('2023-06-24','yandex','cpc','base-java',58,478964,0,0,NULL),
	 ('2023-06-24','yandex','cpc','base-frontend',41,NULL,0,0,NULL),
	 ('2023-06-24','yandex','cpc','base-python',40,485280,0,0,NULL),
	 ('2023-06-24','admitad','cpa','admitad',35,NULL,2,0,NULL),
	 ('2023-06-24','yandex','cpc','prof-professions-brand',35,108255,0,0,NULL),
	 ('2023-06-24','yandex','cpc','prof-data-analytics',29,149785,0,0,NULL),
	 ('2023-06-24','yandex','cpc','prof-professions-retarget',27,27459,0,0,NULL),
	 ('2023-06-24','telegram','social','hexlet-blog',26,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-24','yandex','cpc','dod-frontend',24,NULL,0,0,NULL),
	 ('2023-06-24','yandex','cpc','dod-professions',23,NULL,0,0,NULL),
	 ('2023-06-24','vk','cpc','prof-python',18,103284,0,0,NULL),
	 ('2023-06-24','vk','cpc','prof-data-analytics',14,60508,0,0,NULL),
	 ('2023-06-24','telegram','cpp','base-frontend',11,NULL,0,0,NULL),
	 ('2023-06-24','telegram','cpp','prof-java',10,NULL,0,0,NULL),
	 ('2023-06-24','yandex','cpc','dod-python-java',10,NULL,0,0,NULL),
	 ('2023-06-24','vk','cpc','prof-java',9,57123,0,0,NULL),
	 ('2023-06-24','yandex','cpc','dod-java',9,NULL,0,0,NULL),
	 ('2023-06-24','vk','cpc','prof-frontend',8,40608,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-24','yandex','cpc','dod-php',8,NULL,0,0,NULL),
	 ('2023-06-24','vk','cpc','base-python',7,15988,0,0,NULL),
	 ('2023-06-24','vk','cpc','freemium-python',6,13638,0,0,NULL),
	 ('2023-06-24','yandex','cpc','base-professions-retarget',6,NULL,0,0,NULL),
	 ('2023-06-24','vk','cpc','freemium-frontend',5,12695,0,0,NULL),
	 ('2023-06-24','vk-senler','cpc','freemium',5,NULL,0,0,NULL),
	 ('2023-06-24','yandex','cpc','dod-qa',5,NULL,0,0,NULL),
	 ('2023-06-24','telegram','cpp','prof-frontend',2,NULL,0,0,NULL),
	 ('2023-06-24','telegram','cpp','prof-python',2,NULL,0,0,NULL),
	 ('2023-06-24','vk','cpc','freemium-java',2,3446,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-24','vk','cpp','dod-python-java',2,NULL,0,0,NULL),
	 ('2023-06-24','vk','social','base-python',2,NULL,0,0,NULL),
	 ('2023-06-24','vk','social','prof-python',2,NULL,0,0,NULL),
	 ('2023-06-24','facebook','cpc','python',1,NULL,0,0,NULL),
	 ('2023-06-24','telegram','cpm','frontend',1,NULL,0,0,NULL),
	 ('2023-06-24','telegram','cpp','base-java',1,NULL,0,0,NULL),
	 ('2023-06-24','timepad','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-24','vk','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-24','vk','social','hexlet-blog',1,NULL,1,0,NULL),
	 ('2023-06-24','vk','social','matematika-ilnar',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-24','vk','social','reshenie-zadach--horoshiy-sposob-zakrepit',1,NULL,0,0,NULL),
	 ('2023-06-24','vk-senler','cpc','base-python',1,NULL,0,0,NULL),
	 ('2023-06-24','vk-senler','cpc','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-24','vk-senler','cpc','dod-python-java',1,NULL,0,0,NULL),
	 ('2023-06-24','yandex-direct','cpc','57063851',1,NULL,0,0,NULL),
	 ('2023-06-25','yandex','cpc','freemium',211,2998943,0,0,NULL),
	 ('2023-06-25','yandex','cpc','prof-python',157,6510476,0,0,NULL),
	 ('2023-06-25','yandex','cpc','prof-java',149,5577219,0,0,NULL),
	 ('2023-06-25','yandex','cpc','prof-frontend',147,8417808,0,0,NULL),
	 ('2023-06-25','yandex','cpc','base-java',66,791934,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-25','yandex','cpc','base-python',61,488366,0,0,NULL),
	 ('2023-06-25','admitad','cpa','admitad',49,NULL,0,0,NULL),
	 ('2023-06-25','yandex','cpc','prof-professions-brand',46,237452,0,0,NULL),
	 ('2023-06-25','yandex','cpc','base-frontend',40,NULL,0,0,NULL),
	 ('2023-06-25','yandex','cpc','prof-professions-retarget',29,26651,0,0,NULL),
	 ('2023-06-25','vk','cpc','prof-python',25,151050,0,0,NULL),
	 ('2023-06-25','yandex','cpc','prof-data-analytics',23,107962,0,0,NULL),
	 ('2023-06-25','yandex','cpc','dod-frontend',22,NULL,0,0,NULL),
	 ('2023-06-25','vk','cpc','prof-java',21,191898,0,0,NULL),
	 ('2023-06-25','telegram','cpp','prof-java',16,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-25','vk','cpc','prof-data-analytics',14,53298,0,0,NULL),
	 ('2023-06-25','yandex','cpc','dod-professions',12,NULL,0,0,NULL),
	 ('2023-06-25','vk','cpc','base-python',10,35220,0,0,NULL),
	 ('2023-06-25','yandex','cpc','dod-java',9,NULL,0,0,NULL),
	 ('2023-06-25','vk','cpc','freemium-frontend',8,20304,0,0,NULL),
	 ('2023-06-25','vk','cpc','freemium-python',7,14595,0,0,NULL),
	 ('2023-06-25','yandex','cpc','dod-php',7,NULL,0,0,NULL),
	 ('2023-06-25','yandex','cpc','dod-qa',6,NULL,0,0,NULL),
	 ('2023-06-25','telegram','social','hexlet-blog',4,NULL,0,0,NULL),
	 ('2023-06-25','yandex','cpc','base-professions-retarget',4,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-25','yandex','cpc','dod-python-java',4,NULL,0,0,NULL),
	 ('2023-06-25','vk','cpc','prof-frontend',3,18273,0,0,NULL),
	 ('2023-06-25','vk-senler','cpc','freemium',3,NULL,0,0,NULL),
	 ('2023-06-25','telegram','cpp','base-frontend',2,NULL,0,0,NULL),
	 ('2023-06-25','telegram','cpp','prof-python',2,NULL,0,0,NULL),
	 ('2023-06-25','timepad','cpp','base-frontend',2,NULL,0,0,NULL),
	 ('2023-06-25','vk','cpc','freemium-java',2,3046,0,0,NULL),
	 ('2023-06-25','vk','cpp','base-frontend',2,NULL,0,0,NULL),
	 ('2023-06-25','instagram','social','base-pyton',1,NULL,0,0,NULL),
	 ('2023-06-25','telegram','cpp','base-java',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-25','telegram','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-25','telegram','social','studenty-heksleta-inogda-rasstraivayutsya',1,NULL,0,0,NULL),
	 ('2023-06-25','twitter','social','devushki_v_it',1,NULL,0,0,NULL),
	 ('2023-06-25','vk','social','base-python',1,NULL,0,0,NULL),
	 ('2023-06-25','vk','social','dod-python-java',1,NULL,0,0,NULL),
	 ('2023-06-25','vk','social','general',1,NULL,0,0,NULL),
	 ('2023-06-25','vk','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-25','vk','social','prof-python',1,NULL,0,0,NULL),
	 ('2023-06-25','vk-senler','cpc','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-25','vkontakte','social','button-vk',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-25','zen','social','hexlet',1,NULL,0,0,NULL),
	 ('2023-06-26','yandex','cpc','freemium',251,4183668,0,0,NULL),
	 ('2023-06-26','yandex','cpc','prof-python',187,7769289,0,0,NULL),
	 ('2023-06-26','yandex','cpc','prof-frontend',166,9814418,0,0,NULL),
	 ('2023-06-26','yandex','cpc','prof-java',121,4286909,0,0,NULL),
	 ('2023-06-26','admitad','cpa','admitad',72,NULL,0,0,NULL),
	 ('2023-06-26','telegram','social','hexlet-blog',66,NULL,0,0,NULL),
	 ('2023-06-26','telegram','cpp','base-python',58,NULL,0,0,NULL),
	 ('2023-06-26','yandex','cpc','base-python',57,452580,0,0,NULL),
	 ('2023-06-26','yandex','cpc','base-java',52,557856,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-26','yandex','cpc','base-frontend',43,NULL,0,0,NULL),
	 ('2023-06-26','yandex','cpc','prof-professions-brand',40,171440,0,0,NULL),
	 ('2023-06-26','yandex','cpc','prof-data-analytics',36,169164,0,0,NULL),
	 ('2023-06-26','vk','cpc','prof-python',21,121863,0,0,NULL),
	 ('2023-06-26','yandex','cpc','dod-frontend',19,NULL,0,0,NULL),
	 ('2023-06-26','yandex','cpc','dod-professions',19,NULL,0,0,NULL),
	 ('2023-06-26','yandex','cpc','prof-professions-retarget',18,25758,0,0,NULL),
	 ('2023-06-26','vk','cpc','prof-java',17,135864,0,0,NULL),
	 ('2023-06-26','vk-senler','cpc','freemium',12,NULL,0,0,NULL),
	 ('2023-06-26','yandex','cpc','dod-python-java',11,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-26','telegram','cpp','base-java',9,NULL,0,0,NULL),
	 ('2023-06-26','vk','cpc','freemium-frontend',8,20304,0,0,NULL),
	 ('2023-06-26','vk','cpc','freemium-python',7,13769,0,0,NULL),
	 ('2023-06-26','yandex','cpc','dod-qa',7,NULL,0,0,NULL),
	 ('2023-06-26','yandex','cpc','dod-java',6,NULL,0,0,NULL),
	 ('2023-06-26','facebook','social','hexlet-blog',4,NULL,0,0,NULL),
	 ('2023-06-26','telegram','cpp','prof-python',4,NULL,0,0,NULL),
	 ('2023-06-26','vk','cpc','prof-data-analytics',4,5604,0,0,NULL),
	 ('2023-06-26','vk','cpc','prof-frontend',4,17276,0,0,NULL),
	 ('2023-06-26','vk','social','hexlet-blog',4,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-26','yandex','cpc','base-professions-retarget',4,NULL,0,0,NULL),
	 ('2023-06-26','telegram','cpp','prof-java',3,NULL,0,0,NULL),
	 ('2023-06-26','vk','cpc','base-python',3,5658,0,0,NULL),
	 ('2023-06-26','yandex','cpc','dod-php',3,NULL,0,0,NULL),
	 ('2023-06-26','vk','cpp','base-java',2,NULL,0,0,NULL),
	 ('2023-06-26','vk','social','base-java',2,NULL,0,0,NULL),
	 ('2023-06-26','vk','social','prof-python',2,NULL,0,0,NULL),
	 ('2023-06-26','admitad','cpa','442763',1,NULL,0,0,NULL),
	 ('2023-06-26','admitad','cpc','183258',1,NULL,0,0,NULL),
	 ('2023-06-26','dzen','social','dzen-post',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-26','instagram','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-26','instagram','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-26','instagram','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-26','podcast','social','interview',1,NULL,0,0,NULL),
	 ('2023-06-26','telegram','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-26','telegram','cpp','prof-data-analytics',1,NULL,0,0,NULL),
	 ('2023-06-26','telegram','cpp','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-26','telegram','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-26','telegram','social','dod-professions',1,NULL,0,0,NULL),
	 ('2023-06-26','telegram','social','uyazvimost-v-java-ugrozhaet-sotnyam-tysyach',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-26','twitter','social','9-marta-v-1930-po-moskovskomu-vremeni-p',1,NULL,0,0,NULL),
	 ('2023-06-26','vk','cpc','freemium-java',1,1516,0,0,NULL),
	 ('2023-06-26','vk','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-26','vk','cpp','dod-python-java',1,NULL,0,0,NULL),
	 ('2023-06-26','vk','social','base-python',1,NULL,0,0,NULL),
	 ('2023-06-26','vk','social','general',1,NULL,0,0,NULL),
	 ('2023-06-26','vk-senler','cpc','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-26','zen','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-26','zen','social','prof-python',1,NULL,0,0,NULL),
	 ('2023-06-27','yandex','cpc','freemium',238,3259172,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-27','yandex','cpc','prof-python',175,6989325,0,0,NULL),
	 ('2023-06-27','yandex','cpc','prof-frontend',158,9632154,0,0,NULL),
	 ('2023-06-27','yandex','cpc','prof-java',128,3614080,0,0,NULL),
	 ('2023-06-27','yandex','cpc','base-java',58,323872,0,0,NULL),
	 ('2023-06-27','yandex','cpc','base-python',58,595718,0,0,NULL),
	 ('2023-06-27','yandex','cpc','prof-professions-brand',58,304906,0,0,NULL),
	 ('2023-06-27','admitad','cpa','admitad',45,NULL,0,0,NULL),
	 ('2023-06-27','yandex','cpc','base-frontend',39,NULL,0,0,NULL),
	 ('2023-06-27','yandex','cpc','prof-data-analytics',38,269496,0,0,NULL),
	 ('2023-06-27','yandex','cpc','prof-professions-retarget',32,21408,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-27','yandex','cpc','dod-professions',27,NULL,0,0,NULL),
	 ('2023-06-27','telegram','social','hexlet-blog',23,NULL,0,0,NULL),
	 ('2023-06-27','vk-senler','cpc','freemium',20,NULL,0,0,NULL),
	 ('2023-06-27','telegram','cpp','base-python',19,NULL,0,0,NULL),
	 ('2023-06-27','vk','cpc','prof-python',16,74816,0,0,NULL),
	 ('2023-06-27','yandex','cpc','dod-frontend',13,NULL,0,0,NULL),
	 ('2023-06-27','telegram','cpp','base-java',11,NULL,0,0,NULL),
	 ('2023-06-27','vk','cpc','freemium-frontend',11,27918,0,0,NULL),
	 ('2023-06-27','telegram','cpp','base-frontend',10,NULL,0,0,NULL),
	 ('2023-06-27','yandex','cpc','dod-python-java',10,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-27','vk','cpc','base-python',9,21690,0,0,NULL),
	 ('2023-06-27','vk','cpc','prof-java',9,48546,0,0,NULL),
	 ('2023-06-27','yandex','cpc','dod-java',9,NULL,0,0,NULL),
	 ('2023-06-27','vk','cpc','freemium-python',7,14105,0,0,NULL),
	 ('2023-06-27','vk','cpc','prof-frontend',5,33300,0,0,NULL),
	 ('2023-06-27','yandex','cpc','dod-qa',5,NULL,0,0,NULL),
	 ('2023-06-27','facebook','social','hexlet-blog',4,NULL,0,0,NULL),
	 ('2023-06-27','yandex','cpc','dod-php',3,NULL,0,0,NULL),
	 ('2023-06-27','telegram','cpp','prof-java',2,NULL,0,0,NULL),
	 ('2023-06-27','vk','cpc','freemium-java',2,3046,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-27','vk','social','all-courses',2,NULL,0,0,NULL),
	 ('2023-06-27','vk','social','general',2,NULL,0,0,NULL),
	 ('2023-06-27','yandex','cpc','base-professions-retarget',2,NULL,0,0,NULL),
	 ('2023-06-27','Yandex','cpc','73043444',1,NULL,0,0,NULL),
	 ('2023-06-27','admitad','cpc','183258',1,NULL,0,0,NULL),
	 ('2023-06-27','dzen','social','dzen_post',1,NULL,0,0,NULL),
	 ('2023-06-27','telegram','cpp','prof-frontend',1,NULL,0,0,NULL),
	 ('2023-06-27','telegram','cpp','prof-python',1,NULL,0,0,NULL),
	 ('2023-06-27','telegram','social','20-sovetov-dlya-buduschih-programmistov--ko',1,NULL,0,0,NULL),
	 ('2023-06-27','telegram','social','all-courses',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-27','telegram','social','dod-professions',1,NULL,0,0,NULL),
	 ('2023-06-27','twitter','social','analitik-dannyh',1,NULL,0,0,NULL),
	 ('2023-06-27','twitter','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-27','twitter','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-27','vk','cpc','yaintern',1,NULL,0,0,NULL),
	 ('2023-06-27','vk','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-27','vk','cpp','base-java',1,NULL,0,0,NULL),
	 ('2023-06-27','vk','social','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-27','vk','social','base-python',1,NULL,0,0,NULL),
	 ('2023-06-27','vk','social','dod-professions',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-27','vk','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-27','vk','social','prof-python',1,NULL,0,0,NULL),
	 ('2023-06-27','yandex-direct','cpc','26980930',1,NULL,0,0,NULL),
	 ('2023-06-27','zen','social','blog',1,NULL,0,0,NULL),
	 ('2023-06-28','yandex','cpc','freemium',239,3798188,0,0,NULL),
	 ('2023-06-28','yandex','cpc','prof-python',186,8347866,0,0,NULL),
	 ('2023-06-28','yandex','cpc','prof-frontend',139,9133412,0,0,NULL),
	 ('2023-06-28','yandex','cpc','prof-java',112,3253376,0,0,NULL),
	 ('2023-06-28','admitad','cpa','admitad',75,NULL,0,0,NULL),
	 ('2023-06-28','yandex','cpc','base-python',60,575400,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-28','yandex','cpc','base-java',47,503323,0,0,NULL),
	 ('2023-06-28','yandex','cpc','base-frontend',43,NULL,0,0,NULL),
	 ('2023-06-28','yandex','cpc','prof-professions-brand',34,162894,0,0,NULL),
	 ('2023-06-28','telegram','cpp','base-python',32,NULL,0,0,NULL),
	 ('2023-06-28','yandex','cpc','prof-data-analytics',27,166833,0,0,NULL),
	 ('2023-06-28','yandex','cpc','prof-professions-retarget',27,38205,0,0,NULL),
	 ('2023-06-28','yandex','cpc','dod-frontend',19,NULL,0,0,NULL),
	 ('2023-06-28','telegram','cpp','prof-python',16,NULL,0,0,NULL),
	 ('2023-06-28','telegram','cpp','base-java',15,NULL,0,0,NULL),
	 ('2023-06-28','vk','cpc','prof-python',15,64770,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-28','vk','cpc','freemium-frontend',14,35532,0,0,NULL),
	 ('2023-06-28','telegram','social','hexlet-blog',13,NULL,0,0,NULL),
	 ('2023-06-28','yandex','cpc','dod-professions',11,NULL,0,0,NULL),
	 ('2023-06-28','vk-senler','cpc','freemium',10,NULL,0,0,NULL),
	 ('2023-06-28','yandex','cpc','dod-python-java',9,NULL,0,0,NULL),
	 ('2023-06-28','vk','cpc','freemium-python',8,15632,1,0,NULL),
	 ('2023-06-28','vk','cpc','prof-java',8,46056,0,0,NULL),
	 ('2023-06-28','yandex','cpc','dod-qa',8,17912,0,0,NULL),
	 ('2023-06-28','vk','cpc','base-python',7,18942,0,0,NULL),
	 ('2023-06-28','vk','cpc','prof-frontend',6,39768,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-28','yandex','cpc','base-professions-retarget',6,NULL,0,0,NULL),
	 ('2023-06-28','facebook','social','hexlet-blog',5,NULL,0,0,NULL),
	 ('2023-06-28','telegram','cpp','base-frontend',5,NULL,0,0,NULL),
	 ('2023-06-28','vk','cpp','base-java',5,NULL,0,0,NULL),
	 ('2023-06-28','yandex','cpc','dod-java',5,NULL,0,0,NULL),
	 ('2023-06-28','vk','cpc','freemium-java',3,4563,0,0,NULL),
	 ('2023-06-28','vk','social','hexlet-blog',3,NULL,0,0,NULL),
	 ('2023-06-28','vk','social','prof-python',3,NULL,0,0,NULL),
	 ('2023-06-28','yandex','cpc','dod-php',3,NULL,0,0,NULL),
	 ('2023-06-28','telegram','cpp','prof-java',2,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-28','telegram','social','course_completed',2,NULL,0,0,NULL),
	 ('2023-06-28','vk','social','all-courses',2,NULL,0,0,NULL),
	 ('2023-06-28','Yandex','cpc','67469241',1,NULL,0,0,NULL),
	 ('2023-06-28','admitad','cpc','183258',1,NULL,0,0,NULL),
	 ('2023-06-28','instagram','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-28','instagram','social','prof-java',1,NULL,0,0,NULL),
	 ('2023-06-28','mytarget','cpc','freemium',1,NULL,0,0,NULL),
	 ('2023-06-28','mytarget','cpc','retarget',1,NULL,0,0,NULL),
	 ('2023-06-28','partners','cpm','prof-data-analytics',1,NULL,0,0,NULL),
	 ('2023-06-28','telegram','cpm','base',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-28','telegram','social','dod-professions',1,NULL,0,0,NULL),
	 ('2023-06-28','telegram.me','social','kakoy-yazyk-programmirovaniya-vybrat-dlya',1,NULL,0,0,NULL),
	 ('2023-06-28','twitter','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-28','twitter','social','webinars',1,NULL,0,0,NULL),
	 ('2023-06-28','vk','cpc','prof-data-analytics',1,381,0,0,NULL),
	 ('2023-06-28','vk','cpm','java',1,NULL,0,0,NULL),
	 ('2023-06-28','vk','social','base-python',1,NULL,0,0,NULL),
	 ('2023-06-28','vk','social','prof-qa',1,NULL,0,0,NULL),
	 ('2023-06-28','vk','social','promo',1,NULL,0,0,NULL),
	 ('2023-06-28','vk-senler','cpc','dod-php',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-29','yandex','cpc','freemium',227,3400687,0,0,NULL),
	 ('2023-06-29','yandex','cpc','prof-python',194,8917598,0,0,NULL),
	 ('2023-06-29','yandex','cpc','prof-frontend',149,9759351,0,0,NULL),
	 ('2023-06-29','yandex','cpc','prof-java',122,4290740,0,0,NULL),
	 ('2023-06-29','yandex','cpc','base-python',61,986614,0,0,NULL),
	 ('2023-06-29','admitad','cpa','admitad',56,NULL,0,0,NULL),
	 ('2023-06-29','yandex','cpc','base-java',49,568694,0,0,NULL),
	 ('2023-06-29','vk-senler','cpc','base-python',46,NULL,0,0,NULL),
	 ('2023-06-29','telegram','cpp','base-python',43,NULL,0,0,NULL),
	 ('2023-06-29','yandex','cpc','prof-professions-brand',37,120694,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-29','yandex','cpc','base-frontend',35,140105,0,0,NULL),
	 ('2023-06-29','yandex','cpc','prof-data-analytics',29,NULL,0,0,NULL),
	 ('2023-06-29','yandex','cpc','prof-professions-retarget',25,22575,0,0,NULL),
	 ('2023-06-29','vk','cpc','freemium-frontend',20,50760,0,0,NULL),
	 ('2023-06-29','vk-senler','cpc','freemium',19,NULL,0,0,NULL),
	 ('2023-06-29','yandex','cpc','dod-frontend',18,NULL,0,0,NULL),
	 ('2023-06-29','telegram','social','hexlet-blog',16,NULL,0,0,NULL),
	 ('2023-06-29','yandex','cpc','dod-professions',14,NULL,0,0,NULL),
	 ('2023-06-29','vk','cpc','prof-python',13,55939,0,0,NULL),
	 ('2023-06-29','telegram','cpp','prof-java',12,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-29','yandex','cpc','dod-python-java',12,NULL,0,0,NULL),
	 ('2023-06-29','yandex','cpc','dod-java',11,NULL,0,0,NULL),
	 ('2023-06-29','vk','cpc','prof-frontend',10,54420,1,0,NULL),
	 ('2023-06-29','telegram','cpp','dod-qa',9,NULL,0,0,NULL),
	 ('2023-06-29','telegram','cpp','base-java',8,NULL,0,0,NULL),
	 ('2023-06-29','vk','cpc','prof-java',8,45944,0,0,NULL),
	 ('2023-06-29','vk','social','base-python',7,NULL,0,0,NULL),
	 ('2023-06-29','vk','cpc','freemium-python',6,12312,0,0,NULL),
	 ('2023-06-29','vk','social','base-frontend',6,NULL,0,0,NULL),
	 ('2023-06-29','telegram','cpp','base-frontend',5,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-29','yandex','cpc','dod-qa',5,36455,0,0,NULL),
	 ('2023-06-29','telegram','cpp','prof-python',4,NULL,0,0,NULL),
	 ('2023-06-29','vk','cpp','base-java',4,NULL,0,0,NULL),
	 ('2023-06-29','vk','social','general',4,NULL,0,0,NULL),
	 ('2023-06-29','yandex','cpc','dod-php',4,NULL,0,0,NULL),
	 ('2023-06-29','vk','cpc','base-python',3,7533,0,0,NULL),
	 ('2023-06-29','vk','social','base-java',3,NULL,0,0,NULL),
	 ('2023-06-29','telegram','social','promo',2,NULL,0,0,NULL),
	 ('2023-06-29','vc','cpp','dod-qa',2,NULL,0,0,NULL),
	 ('2023-06-29','vk','cpc','freemium-java',2,3046,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-29','yandex','cpc','base-professions-retarget',2,756,0,0,NULL),
	 ('2023-06-29','admitad','cpc','442763',1,NULL,0,0,NULL),
	 ('2023-06-29','facebook','cpm','freemium-en',1,NULL,0,0,NULL),
	 ('2023-06-29','instagram','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-29','instagram','social','prof-python',1,NULL,0,0,NULL),
	 ('2023-06-29','partners','cpm','all',1,NULL,0,0,NULL),
	 ('2023-06-29','telegram','cpm','base',1,NULL,0,0,NULL),
	 ('2023-06-29','telegram','cpp','dod-data-analytics',1,NULL,0,0,NULL),
	 ('2023-06-29','telegram','cpp','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-29','telegram','cpp','prof-frontend',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-29','telegram','social','analitik-dannyh',1,NULL,0,0,NULL),
	 ('2023-06-29','telegram','social','dod-professions',1,NULL,0,0,NULL),
	 ('2023-06-29','timepad','cpp','base-frontend',1,NULL,0,0,NULL),
	 ('2023-06-29','twitter','social','hexlet-blog',1,NULL,0,0,NULL),
	 ('2023-06-29','twitter.com','social','chto-napisat-v-soprovoditelnom-pisme-i',1,NULL,0,0,NULL),
	 ('2023-06-29','vk','cpc','freemium',1,NULL,0,0,NULL),
	 ('2023-06-29','vk','cpc','prof-data-analytics',1,NULL,0,0,NULL),
	 ('2023-06-29','vk','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-29','vk','social','prof-data-analyst',1,NULL,0,0,NULL),
	 ('2023-06-29','vk','social','unpack',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-29','vk-senler','cpc','dod-frontend',1,NULL,0,0,NULL),
	 ('2023-06-30','yandex','cpc','freemium',200,3572200,0,0,NULL),
	 ('2023-06-30','yandex','cpc','prof-python',179,6735412,0,0,NULL),
	 ('2023-06-30','yandex','cpc','prof-frontend',165,8777175,0,0,NULL),
	 ('2023-06-30','yandex','cpc','prof-java',125,4633500,0,0,NULL),
	 ('2023-06-30','yandex','cpc','base-python',77,860398,0,0,NULL),
	 ('2023-06-30','admitad','cpa','admitad',71,NULL,0,0,NULL),
	 ('2023-06-30','yandex','cpc','base-java',64,469632,0,0,NULL),
	 ('2023-06-30','yandex','cpc','prof-professions-brand',43,121303,0,0,NULL),
	 ('2023-06-30','yandex','cpc','base-frontend',37,304547,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-30','yandex','cpc','prof-data-analytics',37,NULL,0,0,NULL),
	 ('2023-06-30','telegram','cpp','base-java',29,NULL,0,0,NULL),
	 ('2023-06-30','yandex','cpc','dod-frontend',20,NULL,0,0,NULL),
	 ('2023-06-30','yandex','cpc','prof-professions-retarget',19,24605,0,0,NULL),
	 ('2023-06-30','telegram','social','hexlet-blog',16,NULL,0,0,NULL),
	 ('2023-06-30','vk-senler','cpc','freemium',16,NULL,0,0,NULL),
	 ('2023-06-30','vk-senler','cpc','base-python',15,NULL,0,0,NULL),
	 ('2023-06-30','vk','cpc','prof-java',14,105406,0,0,NULL),
	 ('2023-06-30','telegram','cpp','base-frontend',13,NULL,0,0,NULL),
	 ('2023-06-30','telegram','cpp','base-python',13,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-30','vk','cpc','freemium-python',12,25212,1,0,NULL),
	 ('2023-06-30','yandex','cpc','dod-professions',12,NULL,0,0,NULL),
	 ('2023-06-30','telegram','cpp','prof-java',8,NULL,1,0,NULL),
	 ('2023-06-30','vk','cpc','freemium-frontend',8,20312,0,0,NULL),
	 ('2023-06-30','yandex','cpc','dod-java',8,NULL,0,0,NULL),
	 ('2023-06-30','telegram','cpp','prof-python',7,NULL,1,0,NULL),
	 ('2023-06-30','vk','cpc','prof-python',7,34923,0,0,NULL),
	 ('2023-06-30','yandex','cpc','dod-python-java',7,NULL,0,0,NULL),
	 ('2023-06-30','vk','cpc','prof-frontend',6,25836,1,0,NULL),
	 ('2023-06-30','vk','cpp','base-java',6,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-30','vk','social','base-frontend',5,NULL,0,0,NULL),
	 ('2023-06-30','yandex','cpc','base-professions-retarget',5,3040,0,0,NULL),
	 ('2023-06-30','yandex','cpc','dod-php',5,NULL,0,0,NULL),
	 ('2023-06-30','yandex','cpc','dod-qa',5,32550,0,0,NULL),
	 ('2023-06-30','vk','cpc','freemium-java',4,6096,0,0,NULL),
	 ('2023-06-30','vk','cpc','base-python',3,6852,0,0,NULL),
	 ('2023-06-30','vk','social','base-java',3,NULL,0,0,NULL),
	 ('2023-06-30','facebook','social','hexlet-blog',2,NULL,0,0,NULL),
	 ('2023-06-30','twitter','social','promo',2,NULL,0,0,NULL),
	 ('2023-06-30','vk','cpp','base-frontend',2,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-30','vk','social','all-courses',2,NULL,0,0,NULL),
	 ('2023-06-30','vk','social','base-python',2,NULL,0,0,NULL),
	 ('2023-06-30','vk','social','general',2,NULL,0,0,NULL),
	 ('2023-06-30','vk','social','hexlet',2,NULL,0,0,NULL),
	 ('2023-06-30','vk','social','prof-python',2,NULL,0,0,NULL),
	 ('2023-06-30','admitad','cpc','183258',1,NULL,0,0,NULL),
	 ('2023-06-30','facebook','cpc','freemium',1,NULL,0,0,NULL),
	 ('2023-06-30','partners','cpm','prof-data-analytics',1,NULL,0,0,NULL),
	 ('2023-06-30','rutube','social','all-courses',1,NULL,0,0,NULL),
	 ('2023-06-30','social','youtube','php-open-lesson-260321',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-30','telegram','cpp','dod-java',1,NULL,0,0,NULL),
	 ('2023-06-30','telegram','social','course_completed',1,NULL,0,0,NULL),
	 ('2023-06-30','telegram','social','dod-professions',1,NULL,0,0,NULL),
	 ('2023-06-30','telegram','social','ni-dlya-kogo-ne-sekret--chto-iz-knig-mozhno',1,NULL,0,0,NULL),
	 ('2023-06-30','telegram.me','social','neobhodimyy-minimum-linux-dlya-produktivn',1,NULL,0,0,NULL),
	 ('2023-06-30','tg','social','internship_summer23',1,NULL,0,0,NULL),
	 ('2023-06-30','vk','cpc','frontend',1,NULL,0,0,NULL),
	 ('2023-06-30','vk','cpc','yaintern',1,NULL,0,0,NULL),
	 ('2023-06-30','vk','cpp','dod-qa',1,NULL,0,0,NULL),
	 ('2023-06-30','vk','cpp','intensive-python',1,NULL,0,0,NULL);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        DATE(s.visit_date) AS visit_date
    FROM sessions AS s
    WHERE
        s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
        AND NOT EXISTS (
            SELECT 1
            FROM sessions AS s2
            WHERE
                s2.visitor_id = s.visitor_id
                AND s2.medium IN (
                    'cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social'
                )
                AND s2.visit_date > s.visit_date
        )
),

ad_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date AS visit_date,
        SUM(daily_spent) AS total_cost
    FROM vk_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date

    UNION ALL

    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        campaign_date,
        SUM(daily_spent)
    FROM ya_ads
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(SUM(ac.total_cost), NULL) AS total_cost,
    COUNT(l.lead_id) AS leads_count,
    COUNT(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN 1
    END) AS purchases_count,
    SUM(CASE
        WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142
            THEN l.amount
    END) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN leads AS l
    ON
        lpc.visitor_id = l.visitor_id
        AND DATE(l.created_at) >= lpc.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign
ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-30','vkontakte','social','button-vk',1,NULL,0,0,NULL),
	 ('2023-06-30','zen','social','prof-frontend',1,NULL,0,0,NULL);

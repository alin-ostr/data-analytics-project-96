INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        s.visit_date AS full_visit_date,
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

lead_attribution AS (
    SELECT
        l.lead_id,
        l.amount,
        l.closing_reason,
        l.status_id,
        l.created_at,
        l.visitor_id,
        lpc.utm_source,
        lpc.utm_medium,
        lpc.utm_campaign,
        lpc.visit_date
    FROM leads AS l
    LEFT JOIN LATERAL (
        SELECT *
        FROM last_paid_click AS lpc2
        WHERE
            lpc2.visitor_id = l.visitor_id
            AND lpc2.full_visit_date <= l.created_at
        ORDER BY lpc2.full_visit_date DESC
        LIMIT 1
    ) AS lpc ON TRUE
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
        ya.utm_source,
        ya.utm_medium,
        ya.utm_campaign,
        ya.campaign_date,
        SUM(ya.daily_spent) AS daily_spent
    FROM ya_ads AS ya
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(ac.total_cost, 0) AS total_cost,
    COUNT(DISTINCT la.lead_id) AS leads_count,
    COUNT(DISTINCT CASE
        WHEN la.closing_reason = 'Успешно реализовано' OR la.status_id = 142
            THEN la.lead_id
    END) AS purchases_count,
    COALESCE(SUM(CASE
        WHEN la.closing_reason = 'Успешно реализовано' OR la.status_id = 142
            THEN la.amount
    END), 0) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN lead_attribution AS la
    ON
        lpc.visitor_id = la.visitor_id
        AND lpc.utm_source = la.utm_source
        AND lpc.utm_medium = la.utm_medium
        AND lpc.utm_campaign = la.utm_campaign
        AND lpc.visit_date = la.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
WHERE la.lead_id IS NOT NULL OR TRUE
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    ac.total_cost
ORDER BY
    revenue DESC NULLS LAST,
    lpc.visit_date ASC,
    visitors_count DESC,
    lpc.utm_source ASC,
    lpc.utm_medium ASC,
    lpc.utm_campaign ASC
LIMIT 15
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-01','yandex','cpc','freemium',103,21654,100,25,1654810),
	 ('2023-06-01','yandex','cpc','prof-frontend',78,57138,73,12,1057000),
	 ('2023-06-01','yandex','cpc','prof-python',62,33026,61,7,613196),
	 ('2023-06-01','yandex','cpc','base-python',31,12524,28,7,476021),
	 ('2023-06-01','vk','cpc','prof-python',71,2028,40,5,355564),
	 ('2023-06-01','vk','cpc','freemium-frontend',80,3160,43,5,338083),
	 ('2023-06-01','yandex','cpc','prof-java',49,29490,49,4,284590),
	 ('2023-06-01','yandex','cpc','base-frontend',40,18061,39,3,268515),
	 ('2023-06-01','vk','cpc','prof-java',51,3115,23,2,232726),
	 ('2023-06-01','yandex','cpc','prof-data-analytics',14,10086,14,2,220264);
INSERT INTO "WITH last_paid_click AS (
    SELECT
        s.visitor_id,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        s.visit_date AS full_visit_date,
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

lead_attribution AS (
    SELECT
        l.lead_id,
        l.amount,
        l.closing_reason,
        l.status_id,
        l.created_at,
        l.visitor_id,
        lpc.utm_source,
        lpc.utm_medium,
        lpc.utm_campaign,
        lpc.visit_date
    FROM leads AS l
    LEFT JOIN LATERAL (
        SELECT *
        FROM last_paid_click AS lpc2
        WHERE
            lpc2.visitor_id = l.visitor_id
            AND lpc2.full_visit_date <= l.created_at
        ORDER BY lpc2.full_visit_date DESC
        LIMIT 1
    ) AS lpc ON TRUE
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
        ya.utm_source,
        ya.utm_medium,
        ya.utm_campaign,
        ya.campaign_date,
        SUM(ya.daily_spent) AS daily_spent
    FROM ya_ads AS ya
    GROUP BY utm_source, utm_medium, utm_campaign, campaign_date
)

SELECT
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    COUNT(DISTINCT lpc.visitor_id) AS visitors_count,
    COALESCE(ac.total_cost, 0) AS total_cost,
    COUNT(DISTINCT la.lead_id) AS leads_count,
    COUNT(DISTINCT CASE
        WHEN la.closing_reason = 'Успешно реализовано' OR la.status_id = 142
            THEN la.lead_id
    END) AS purchases_count,
    COALESCE(SUM(CASE
        WHEN la.closing_reason = 'Успешно реализовано' OR la.status_id = 142
            THEN la.amount
    END), 0) AS revenue
FROM last_paid_click AS lpc
LEFT JOIN lead_attribution AS la
    ON
        lpc.visitor_id = la.visitor_id
        AND lpc.utm_source = la.utm_source
        AND lpc.utm_medium = la.utm_medium
        AND lpc.utm_campaign = la.utm_campaign
        AND lpc.visit_date = la.visit_date
LEFT JOIN ad_costs AS ac
    ON
        lpc.utm_source = ac.utm_source
        AND lpc.utm_medium = ac.utm_medium
        AND lpc.utm_campaign = ac.utm_campaign
        AND lpc.visit_date = ac.visit_date
WHERE la.lead_id IS NOT NULL OR TRUE
GROUP BY
    lpc.visit_date,
    lpc.utm_source,
    lpc.utm_medium,
    lpc.utm_campaign,
    ac.total_cost
ORDER BY
    revenue DESC NULLS LAST,
    lpc.visit_date ASC,
    visitors_count DESC,
    lpc.utm_source ASC,
    lpc.utm_medium ASC,
    lpc.utm_campaign ASC
LIMIT 15
" (visit_date,utm_source,utm_medium,utm_campaign,visitors_count,total_cost,leads_count,purchases_count,revenue) VALUES
	 ('2023-06-01','yandex','cpc','prof-professions-brand',13,4818,13,3,154287),
	 ('2023-06-20','telegram','cpp','base-java',3,0,1,1,151192),
	 ('2023-06-01','yandex','cpc','dod-php',4,5964,4,1,150255),
	 ('2023-06-01','yandex','cpc','base-professions-retarget',4,151,4,1,134100),
	 ('2023-06-07','vk','social','hexlet-blog',3,0,1,1,84000);

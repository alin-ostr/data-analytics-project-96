WITH last_paid_click AS (
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
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
LIMIT 15;

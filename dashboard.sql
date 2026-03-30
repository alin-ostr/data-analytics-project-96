-- пользователи: количество за период
SELECT COUNT(DISTINCT visitor_id) AS total_visitors
FROM sessions;


-- лиды: количество за период 
SELECT COUNT(*) AS total_leads
FROM leads;


-- распределение по дням недели
SELECT
    source AS channel,
    CASE EXTRACT(DOW FROM visit_date)
        WHEN 1 THEN 'Пн'
        WHEN 2 THEN 'Вт'
        WHEN 3 THEN 'Ср'
        WHEN 4 THEN 'Чт'
        WHEN 5 THEN 'Пт'
        WHEN 6 THEN 'Сб'
        WHEN 0 THEN 'Вс'
    END AS day_of_week,
    COUNT(*) AS total_transitions
FROM sessions
GROUP BY EXTRACT(DOW FROM visit_date), source
ORDER BY EXTRACT(DOW FROM visit_date), total_transitions DESC;


-- распределение по неделям
SELECT
    source AS channel,
    EXTRACT(WEEK FROM visit_date) AS week_number,
    COUNT(*) AS total_transitions
FROM sessions
GROUP BY EXTRACT(WEEK FROM visit_date), source
ORDER BY week_number ASC, total_transitions DESC;


-- распределение по месяцам
SELECT
    source AS channel,
    EXTRACT(MONTH FROM visit_date) AS month_number,
    COUNT(*) AS total_transitions
FROM sessions
GROUP BY EXTRACT(MONTH FROM visit_date), source
ORDER BY month_number ASC, total_transitions DESC;


-- конверсия
SELECT
    ROUND(
        COUNT(DISTINCT l.lead_id)::NUMERIC / COUNT(DISTINCT s.visitor_id) * 100,
        2
    ) AS click_to_lead,
    ROUND(
        COUNT(DISTINCT CASE WHEN l.amount > 0 THEN l.lead_id END)::NUMERIC
        / COUNT(DISTINCT l.lead_id)
        * 100,
        2
    ) AS lead_to_payment
FROM sessions AS s
LEFT JOIN leads AS l ON s.visitor_id = l.visitor_id;


-- затраты по каналам
SELECT
    campaign_date::DATE AS date_day,
    SUM(daily_spent) AS total_spent
FROM (
    SELECT
        campaign_date,
        daily_spent
    FROM vk_ads
    UNION ALL
    SELECT
        campaign_date,
        daily_spent
    FROM ya_ads
) AS all_ads
GROUP BY campaign_date::DATE
ORDER BY date_day DESC;

-- прибыль и расходы по каналам 
SELECT
    utm_source AS channel,
    SUM(daily_spent) AS spent,
    COALESCE((
        SELECT SUM(l.amount)
        FROM sessions AS s
        INNER JOIN leads AS l ON s.visitor_id = l.visitor_id
        WHERE
            s.source = ads.utm_source
            AND l.created_at >= s.visit_date
    ), 0) AS revenue,
    COALESCE((
        SELECT SUM(l.amount)
        FROM sessions AS s
        INNER JOIN leads AS l ON s.visitor_id = l.visitor_id
        WHERE
            s.source = ads.utm_source
            AND l.created_at >= s.visit_date
    ), 0) - SUM(daily_spent) AS profit
FROM (
    SELECT
        utm_source,
        daily_spent
    FROM vk_ads
    UNION ALL
    SELECT
        utm_source,
        daily_spent
    FROM ya_ads
) AS ads
GROUP BY utm_source
ORDER BY profit DESC;


-- сводная таблица ключевые меьрики 
SELECT
    c.utm_source,
    c.utm_medium,
    c.utm_campaign,
    ROUND(c.total_cost::NUMERIC / NULLIF(s.visitors, 0), 2) AS cpu,
    ROUND(c.total_cost::NUMERIC / NULLIF(s.leads, 0), 2) AS cpl,
    ROUND(c.total_cost::NUMERIC / NULLIF(s.purchases, 0), 2) AS cppu,
    ROUND((s.revenue - c.total_cost)::NUMERIC / c.total_cost * 100, 2) AS roi
FROM (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        SUM(daily_spent) AS total_cost
    FROM (
        SELECT
            utm_source,
            utm_medium,
            utm_campaign,
            daily_spent
        FROM vk_ads
        UNION ALL
        SELECT
            utm_source,
            utm_medium,
            utm_campaign,
            daily_spent
        FROM ya_ads
    ) AS a
    GROUP BY utm_source, utm_medium, utm_campaign
) AS c
LEFT JOIN (
    SELECT
        s.source,
        s.medium,
        s.campaign,
        COUNT(DISTINCT s.visitor_id) AS visitors,
        COUNT(DISTINCT l.lead_id) AS leads,
        COUNT(DISTINCT CASE WHEN l.amount > 0 THEN l.lead_id END) AS purchases,
        SUM(l.amount) AS revenue
    FROM sessions AS s
    LEFT JOIN
        leads AS l
        ON s.visitor_id = l.visitor_id AND s.visit_date <= l.created_at
    GROUP BY s.source, s.medium, s.campaign
) AS s
    ON
        c.utm_source = s.source
        AND c.utm_medium = s.medium
        AND c.utm_campaign = s.campaign
WHERE c.total_cost > 0
ORDER BY roi DESC NULLS LAST;

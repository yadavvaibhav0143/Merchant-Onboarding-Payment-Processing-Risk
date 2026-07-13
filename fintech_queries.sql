-- ====================================================
-- FINTECH ECOSYSTEM ENHANCED BUSINESS REPORTING SUITE
-- ====================================================

-- [QUERY 01]: MONTHLY REVENUE TREND
-- Purpose: Tracks the overall net platform revenue growth trajectory MoM.
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', execution_time) AS sales_month,
        SUM(gross_amount - processing_fee) AS net_sales
    FROM transactions 
    WHERE routing_status = 'Success'
    GROUP BY DATE_TRUNC('month', execution_time)
)
SELECT 
    TO_CHAR(sales_month, 'YYYY-MM') AS calendar_month,
    net_sales,
    ROUND(LAG(net_sales, 1) OVER (ORDER BY sales_month), 2) AS previous_month_sales,
    ROUND(((net_sales - LAG(net_sales, 1) OVER (ORDER BY sales_month)) * 100.0) / 
          NULLIF(LAG(net_sales, 1) OVER (ORDER BY sales_month), 0), 2) AS mom_growth_pct
FROM monthly_revenue;


-- [QUERY 02]: MERCHANT ONBOARDING STATUS
-- Purpose: Audits compliance onboarding bottlenecks by measuring merchant distribution density.
SELECT 
    kyc_status,
    COUNT(merchant_id) AS total_merchants,
    ROUND((COUNT(merchant_id) * 100.0) / (SELECT COUNT(*) FROM merchants), 2) AS status_share_pct
FROM merchants 
GROUP BY kyc_status;


-- [QUERY 03]: TRANSACTION SUCCESS RATE
-- Purpose: Quantifies the volume processing share split across platform routing states.
SELECT 
    routing_status,
    COUNT(transaction_id) AS transaction_count,
    ROUND(SUM(gross_amount), 2) AS aggregate_value,
    ROUND((COUNT(transaction_id) * 100.0) / (SELECT COUNT(*) FROM transactions), 2) AS pipeline_share_pct
FROM transactions 
GROUP BY routing_status;


-- [QUERY 04]: FRAUD RISK ANALYSIS ALERT QUARANTINE LEDGER
-- Purpose: Isolates critical high-risk transaction attempts triggering automated holds (>80).
SELECT 
    f.hold_id, f.transaction_id, f.risk_score, f.trigger_reason, t.gross_amount, m.business_name
FROM fraud_holds f
JOIN transactions t ON f.transaction_id = t.transaction_id
JOIN merchants m ON t.merchant_id = m.merchant_id
WHERE f.risk_score > 80;


-- [QUERY 05]: SETTLEMENT COMPLETION FLOAT SUMMARY REPORT
-- Purpose: Quantifies the net capital float currently frozen or floating in transit across clearance cycles.
SELECT 
    payout_status,
    COUNT(settlement_id) AS batch_count,
    ROUND(SUM(net_payout), 2) AS aggregate_floating_value
FROM settlements 
GROUP BY payout_status;


-- [QUERY 06]: MERCHANT LIFETIME PROCESSING REVENUE RANKING
-- Purpose: Ranks your active merchant database accounts based on clear lifetime processing volumes.
SELECT 
    m.merchant_id, m.business_name,
    ROUND(SUM(t.gross_amount), 2) AS lifetime_processed_volume,
    ROW_NUMBER() OVER (ORDER BY SUM(t.gross_amount) DESC) AS processing_value_rank
FROM transactions t
JOIN merchants m ON t.merchant_id = m.merchant_id
WHERE t.routing_status = 'Success'
GROUP BY m.merchant_id, m.business_name;


-- [QUERY 07]: VOLUME DISTRIBUTION BY MERCHANT INDUSTRY VERTICAL
-- Purpose: Measures industry sector performance and transaction sizing across platform verticals.
SELECT 
    m.industry_type,
    COUNT(t.transaction_id) AS completed_orders,
    ROUND(SUM(t.gross_amount), 2) AS total_gross_volume,
    ROUND(AVG(t.gross_amount), 2) AS average_ticket_size
FROM transactions t
JOIN merchants m ON t.merchant_id = m.merchant_id
WHERE t.routing_status = 'Success'
GROUP BY m.industry_type;


-- [QUERY 08]: INTERCHANGE PROCESSING FEE ANALYSIS BY MERCHANT
-- Purpose: Calculates the direct percentage financial margin erosion caused by network processing fees.
SELECT
    merchant_id,
    COUNT(*) AS transactions,
    SUM(gross_amount) AS gross_volume,
    SUM(processing_fee) AS total_processing_fee,
    ROUND((SUM(processing_fee) * 100.0) / SUM(gross_amount), 2) AS fee_percentage
FROM transactions
WHERE routing_status = 'Success'
GROUP BY merchant_id;

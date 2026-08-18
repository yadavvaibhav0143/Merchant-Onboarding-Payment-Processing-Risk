-- ==============================================================================
-- PORTFOLIO ASSET: DIGITAL PAYMENT GATEWAY CORE
-- ==============================================================================

-- 1. Clear existing records to ensure a fresh, clean execution run
TRUNCATE webhooks, fraud_holds, settlements, transactions, terminals, merchants RESTART IDENTITY CASCADE;

-- 2. Populating Master Merchant Profiles 
INSERT INTO merchants (merchant_id, business_name, industry_type, kyc_status, acquisition_channel, settlement_currency) VALUES
(301, 'Pune Aggregator SaaS Gateway Ltd', 'SaaS', 'Approved', 'Meta_Ads', 'INR'),
(302, 'Deccan Retail Global Hub', 'E-commerce', 'Approved', 'Google_SEO', 'INR'),
(303, 'Aundh Tech EdLearning Academy', 'EdTech', 'Pending_Review', 'Direct_Traffic', 'INR'),
(304, 'Viman Nagar Logistics Corp', 'Logistics', 'Approved', 'Affiliate', 'INR'),
(305, 'Hinjewadi Tech Solutions', 'SaaS', 'Rejected', 'Meta_Ads', 'INR');

-- 3. Provisioning Production Active Processing Terminals 
INSERT INTO terminals (terminal_id, merchant_id, environment, secret_api_key, is_active) VALUES
('TERM-PUN-001', 301, 'Production_Live', 'sec_key_live_9921a4f', 1),
('TERM-PUN-003', 302, 'Production_Live', 'sec_key_live_5543c2x', 1),
('TERM-PUN-004', 304, 'Production_Live', 'sec_key_live_8832a1z', 1);

-- 4. Ingesting Transaction History Rows
INSERT INTO transactions (transaction_id, merchant_id, terminal_id, gross_amount, processing_fee, execution_time, routing_status) VALUES
('TXN-FIN-001', 301, 'TERM-PUN-001', 45000.00, 900.00, '2026-01-15 10:00:00', 'Success'),
('TXN-FIN-002', 301, 'TERM-PUN-001', 65000.00, 1300.00, '2026-02-18 11:00:00', 'Success'),
('TXN-FIN-003', 302, 'TERM-PUN-003', 85000.00, 1700.00, '2026-03-10 14:00:00', 'Success'),
('TXN-FIN-004', 304, 'TERM-PUN-004', 110000.00, 2200.00, '2026-04-05 09:00:00', 'Success'),
('TXN-FIN-005', 301, 'TERM-PUN-001', 130000.00, 2600.00, '2026-05-22 16:00:00', 'Success'),
('TXN-FIN-006', 302, 'TERM-PUN-003', 450000.00, 9000.00, '2026-06-12 11:15:00', 'Suspicious_Hold'),
('TXN-FIN-007', 302, 'TERM-PUN-003', 25000.00, 500.00, '2026-06-14 15:00:00', 'Failed'),
('TXN-FIN-008', 304, 'TERM-PUN-004', 195000.00, 3900.00, '2026-07-04 13:20:00', 'Success'),
('TXN-FIN-009', 301, 'TERM-PUN-001', 220000.00, 4400.00, '2026-07-11 10:15:00', 'Success');

-- 5. Ingesting Risk Engine Incidents
INSERT INTO fraud_holds (hold_id, transaction_id, risk_score, trigger_reason, review_status) VALUES
(501, 'TXN-FIN-006', 92, 'Velocity threshold spike matching sweep patterns', 'Under_Review');

-- 6. Recording Transaction Notification Logs
INSERT INTO webhooks (webhook_id, transaction_id, delivered_timestamp, response_code, retry_count) VALUES
('WH-PUN-001', 'TXN-FIN-001', '2026-01-15 10:00:05', 200, 1),
('WH-PUN-002', 'TXN-FIN-002', '2026-02-18 11:00:04', 200, 1),
('WH-PUN-003', 'TXN-FIN-003', '2026-03-10 14:00:02', 200, 1),
('WH-PUN-004', 'TXN-FIN-004', '2026-04-05 09:00:03', 200, 1),
('WH-PUN-005', 'TXN-FIN-005', '2026-05-22 16:00:02', 200, 1),
('WH-PUN-006', 'TXN-FIN-006', '2026-06-12 11:15:05', 200, 1),
('WH-PUN-007', 'TXN-FIN-007', '2026-06-14 15:01:00', 504, 3),
('WH-PUN-008', 'TXN-FIN-008', '2026-07-04 13:20:04', 200, 1),
('WH-PUN-009', 'TXN-FIN-009', '2026-07-11 10:15:03', 200, 1);

-- 7. Logging Bank Automated Outbound Transfers
INSERT INTO settlements (settlement_id, merchant_id, settlement_date, net_amount_settled, settlement_status, utr_reference) VALUES
(80001, 301, '2026-01-16', 44100.00, 'Settled_Cleared', 'UTR-NEFT-RBI001A'),
(80002, 301, '2026-02-19', 63700.00, 'Settled_Cleared', 'UTR-NEFT-RBI002B'),
(80003, 302, '2026-03-11', 83300.00, 'Settled_Cleared', 'UTR-NEFT-RBI003C'),
(80004, 304, '2026-04-06', 107800.00, 'Settled_Cleared', 'UTR-NEFT-RBI004D'),
(80005, 301, '2026-05-23', 127400.00, 'Settled_Cleared', 'UTR-NEFT-RBI005E'),
(80006, 302, '2026-06-13', 0.00, 'Frozen_Suspended', NULL),
(80007, 304, '2026-07-05', 191100.00, 'In_Transit', NULL),
(80008, 301, '2026-07-12', 215600.00, 'In_Transit', NULL);

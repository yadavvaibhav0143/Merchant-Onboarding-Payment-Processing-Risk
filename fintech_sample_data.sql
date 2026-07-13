-- ==============================================================================
-- INGESTION LAYER SEEDS
-- ==============================================================================
INSERT INTO merchants VALUES
(301, 'Pune Aggregator SaaS Gateway Ltd', 'SaaS', 'Approved', 'Meta_Ads', 'INR'),
(302, 'Deccan Retail Global Hub', 'E-commerce', 'Approved', 'Google_SEO', 'INR'),
(303, 'Aundh Tech EdLearning Academy', 'EdTech', 'Pending_Review', 'Direct_Traffic', 'INR'),
(304, 'Viman Nagar Logistics Corp', 'Logistics', 'Approved', 'Affiliate', 'INR'),
(305, 'Hinjewadi Tech Solutions', 'SaaS', 'Rejected', 'Meta_Ads', 'INR');

INSERT INTO terminals VALUES
('TERM-PUN-001', 301, 'Production_Live', 'sec_key_live_9921a4f', 1),
('TERM-PUN-002', 301, 'Sandbox_Test', 'sec_key_test_1102b5e', 1),
('TERM-PUN-003', 302, 'Production_Live', 'sec_key_live_5543c2x', 1),
('TERM-PUN-004', 304, 'Production_Live', 'sec_key_live_8832a1z', 1);

INSERT INTO transactions VALUES
('TXN-FIN-9001', 301, 'TERM-PUN-001', 50000.00, 1000.00, '2026-07-01 10:15:00', 'Success'),
('TXN-FIN-9002', 301, 'TERM-PUN-001', 120000.00, 2400.00, '2026-07-02 11:30:00', 'Success'),
('TXN-FIN-9003', 302, 'TERM-PUN-003', 450000.00, 9000.00, '2026-07-02 14:22:00', 'Suspicious_Hold'),
('TXN-FIN-9004', 302, 'TERM-PUN-003', 15000.00, 300.00, '2026-07-03 15:45:00', 'Failed'),
('TXN-FIN-9005', 301, 'TERM-PUN-001', 85000.00, 1700.00, '2026-07-04 09:10:00', 'Success'),
('TXN-FIN-9006', 304, 'TERM-PUN-004', 95000.00, 1900.00, '2026-07-04 13:20:00', 'Success'),
('TXN-FIN-9007', 304, 'TERM-PUN-004', 110000.00, 2200.00, '2026-07-05 16:45:00', 'Success'),
('TXN-FIN-9008', 302, 'TERM-PUN-003', 25000.00, 500.00, '2026-07-05 18:10:00', 'Success');

INSERT INTO fraud_holds VALUES
(501, 'TXN-FIN-9003', 92, 'Velocity threshold spike matching sweep patterns', 'Under_Review');

INSERT INTO webhooks VALUES
('WH-DELIV-001', 'TXN-FIN-9001', '2026-07-01 10:15:05', 200, 1),
('WH-DELIV-002', 'TXN-FIN-9002', '2026-07-02 11:30:04', 200, 1),
('WH-DELIV-003', 'TXN-FIN-9003', '2026-07-02 14:22:02', 200, 1),
('WH-DELIV-004', 'TXN-FIN-9004', '2026-07-03 15:46:00', 504, 3),
('WH-DELIV-005', 'TXN-FIN-9005', '2026-07-04 09:10:03', 200, 1),
('WH-DELIV-006', 'TXN-FIN-9006', '2026-07-04 13:20:05', 200, 1),
('WH-DELIV-007', 'TXN-FIN-9007', '2026-07-05 16:45:02', 200, 1),
('WH-DELIV-008', 'TXN-FIN-9008', '2026-07-05 18:10:04', 200, 1);

INSERT INTO settlements VALUES
(80001, 301, '2026-07-03', 166600.00, 'Settled_Cleared', 'UTR-NEFT-RBI9912048A'),
(80002, 302, '2026-07-04', 0.00, 'Frozen_Suspended', NULL),
(80003, 304, '2026-07-06', 200900.00, 'In_Transit', NULL);

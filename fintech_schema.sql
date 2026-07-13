-- ==============================================================================
-- FINTECH FLAGSHIP CORE PLATFORM STRUCTURE (DDL)
-- ==============================================================================
DROP TABLE IF EXISTS settlements;
DROP TABLE IF EXISTS webhooks;
DROP TABLE IF EXISTS fraud_holds;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS terminals;
DROP TABLE IF EXISTS merchants;

CREATE TABLE merchants (
    merchant_id INT PRIMARY KEY,
    business_name VARCHAR(100) NOT NULL UNIQUE,
    industry_type VARCHAR(50) NOT NULL,
    kyc_status VARCHAR(20) NOT NULL CHECK (kyc_status IN ('Approved', 'Rejected', 'Pending_Review')),
    acquisition_channel VARCHAR(30) NOT NULL CHECK (acquisition_channel IN ('Google_SEO', 'Meta_Ads', 'Direct_Traffic', 'Affiliate')),
    settlement_currency VARCHAR(3) DEFAULT 'INR'
);

CREATE TABLE terminals (
    terminal_id VARCHAR(50) PRIMARY KEY,
    merchant_id INT NOT NULL,
    environment VARCHAR(20) NOT NULL CHECK (environment IN ('Sandbox_Test', 'Production_Live')),
    api_secret_key VARCHAR(100) NOT NULL UNIQUE,
    is_active INT DEFAULT 1 CHECK (is_active IN (0, 1)),
    CONSTRAINT fk_terminals_merchant FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id) ON DELETE CASCADE
);

CREATE TABLE transactions (
    transaction_id VARCHAR(50) PRIMARY KEY,
    merchant_id INT NOT NULL,
    terminal_id VARCHAR(50) NOT NULL,
    gross_amount DECIMAL(15,2) NOT NULL CHECK (gross_amount > 0),
    processing_fee DECIMAL(10,2) NOT NULL CHECK (processing_fee >= 0),
    execution_time TIMESTAMP NOT NULL,
    routing_status VARCHAR(20) NOT NULL CHECK (routing_status IN ('Success', 'Failed', 'Suspicious_Hold')),
    CONSTRAINT fk_txn_merchant FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id) ON DELETE CASCADE,
    CONSTRAINT fk_txn_terminal FOREIGN KEY (terminal_id) REFERENCES terminals(terminal_id)
);

CREATE TABLE fraud_holds (
    hold_id INT PRIMARY KEY,
    transaction_id VARCHAR(50) NOT NULL UNIQUE,
    risk_score INT NOT NULL CHECK (risk_score BETWEEN 0 AND 100),
    trigger_reason VARCHAR(100) NOT NULL,
    review_status VARCHAR(30) DEFAULT 'Under_Review' CHECK (review_status IN ('Under_Review', 'Released_Cleared', 'Voided_Refunded')),
    CONSTRAINT fk_holds_txn FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE CASCADE
);

CREATE TABLE webhooks (
    webhook_id VARCHAR(50) PRIMARY KEY,
    transaction_id VARCHAR(50) NOT NULL,
    dispatch_time TIMESTAMP NOT NULL,
    http_status_code INT NOT NULL,
    retry_count INT DEFAULT 1 CHECK (retry_count >= 1),
    CONSTRAINT fk_webhooks_txn FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE CASCADE
);

CREATE TABLE settlements (
    settlement_id INT PRIMARY KEY,
    merchant_id INT NOT NULL,
    clearing_date DATE NOT NULL,
    net_payout DECIMAL(15,2) NOT NULL,
    payout_status VARCHAR(20) NOT NULL CHECK (payout_status IN ('Settled_Cleared', 'In_Transit', 'Frozen_Suspended')),
    utr_code VARCHAR(50) NULL,
    CONSTRAINT fk_settlements_merchant FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id) ON DELETE CASCADE
);

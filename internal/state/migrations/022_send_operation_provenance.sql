-- Durable provenance for robot-send receipts.
--
-- A receipt must identify both the actor that requested the send and the
-- trusted surface through which it arrived and the target authorization that
-- allowed it. Empty defaults keep historical short-lived rows readable; new
-- receipt creation rejects missing values.
ALTER TABLE send_operations ADD COLUMN actor TEXT NOT NULL DEFAULT '';
ALTER TABLE send_operations ADD COLUMN origin TEXT NOT NULL DEFAULT '';
ALTER TABLE send_operations ADD COLUMN target_authorization TEXT NOT NULL DEFAULT '';

-- This immutable claim event is created in the same SQLite transaction as a
-- new receipt. It mirrors the provenance before any pane actuation occurs.
CREATE TABLE IF NOT EXISTS send_operation_events (
    operation_id TEXT NOT NULL,
    session_name TEXT NOT NULL,
    event_type TEXT NOT NULL,
    actor TEXT NOT NULL,
    origin TEXT NOT NULL,
    target_authorization TEXT NOT NULL,
    payload_sha256 TEXT NOT NULL,
    payload_bytes INTEGER NOT NULL,
    created_at DATETIME NOT NULL,
    PRIMARY KEY (operation_id, session_name, event_type, created_at)
);

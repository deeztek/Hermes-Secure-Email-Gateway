-- ============================================================================
-- v260901 — TEST RELEASE (Session G validation of #221)
--
-- Harmless test artifact to exercise the system_update_docker.sh orchestrator.
-- Adds a single seed row to system_settings + advances build_no.
-- To be reverted in a cleanup commit after end-to-end validation.
--
-- All statements idempotent (INSERT IGNORE / value-gated UPDATE) per the
-- methodology doc at docs/install/release-and-update-methodology.md.
-- ============================================================================

-- Test marker — visible signal that Phase 3 SQL ran on the Test box.
INSERT IGNORE INTO system_settings (parameter, value)
VALUES ('orchestrator_test_marker', 'v260901 applied');

-- Standard release stamp (must be the last statements in this file).
UPDATE system_settings SET value = 'v260901' WHERE parameter = 'build_no';
UPDATE system_settings SET value = 'Docker'  WHERE parameter = 'version_no';

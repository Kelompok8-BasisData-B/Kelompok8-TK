CREATE OR REPLACE FUNCTION check_delete_procedure()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.timestamp < NOW() - INTERVAL '1 day') THEN
        RETURN NEW;
    ELSE
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Membuat trigger yang dipanggil sebelum operasi DELETE
CREATE TRIGGER before_delete_check
BEFORE DELETE ON "TAYANGAN_TERUNDUH"
FOR EACH ROW
EXECUTE FUNCTION check_delete_procedure();

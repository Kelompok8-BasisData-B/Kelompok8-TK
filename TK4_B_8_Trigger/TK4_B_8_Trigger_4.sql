CREATE OR REPLACE FUNCTION check_delete_procedure()
RETURNS TRIGGER AS $$
BEGIN
    IF (OLD.timestamp > NOW() - INTERVAL '1 day') THEN
        RAISE EXCEPTION 'Tayangan minimal harus berada di daftar unduhan selama 1 hari agar bisa dihapus.';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER before_delete_check
BEFORE DELETE ON "TAYANGAN_TERUNDUH"
FOR EACH ROW
EXECUTE PROCEDURE check_delete_procedure();

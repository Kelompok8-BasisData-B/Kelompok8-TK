-- Trigger & Stored Procedure 3 (Pengecekan ulasan)
-- Ketika user membuat ulasan, akan diperiksa apakah user sudah pernah membuat ulasan untuk tayangan tersebut atau belum. Jika sudah pernah akan ada pesan error (insert tidak berhasil), namun jika belum pernah maka insert akan dilakukan dan berhasil
CREATE OR REPLACE FUNCTION check_ulasan_exists()
RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS (SELECT 1 FROM "ULASAN" WHERE id_tayangan = NEW.id_tayangan AND username = NEW.username) THEN
        RAISE EXCEPTION 'Username % sudah memberikan ulasan pada tayangan ini', NEW.username;
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- Trigger untuk cek ulasan
CREATE OR REPLACE TRIGGER check_ulasan_trigger
     BEFORE INSERT ON "ULASAN"
     FOR EACH ROW EXECUTE PROCEDURE check_ulasan_exists();
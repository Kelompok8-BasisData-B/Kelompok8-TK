-- Trigger & Stored Procedure 2 (Pengecekan username)
-- Ketika akun baru mendaftar, akan diperiksa apakah username sudah terdaftar atau belum. Jika sudah terdaftar akan ada pesan error (insert tidak berhasil), namun jika username belum terdaftar maka insert akan dilakukan dan berhasil
CREATE OR REPLACE FUNCTION check_username()
RETURNS TRIGGER AS
$$
BEGIN
     IF EXISTS (SELECT 1 FROM "PENGGUNA" WHERE username = NEW.username) THEN
          RAISE EXCEPTION 'Username % sudah terdaftar.', NEW.username;
     END IF;
     RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- Trigger untuk cek username
CREATE OR REPLACE TRIGGER check_username_trigger
     BEFORE INSERT OR UPDATE ON "PENGGUNA"
     FOR EACH ROW EXECUTE PROCEDURE check_username();
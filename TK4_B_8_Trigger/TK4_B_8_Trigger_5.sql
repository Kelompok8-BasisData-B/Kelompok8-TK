-- Trigger 5
-- Memeriksa Paket yang aktif (Jika ada maka dilakukan operasi update, jika tidak maka dilakukan operasi insert)
-- Supabase AI is experimental and may produce incorrect answers
-- Always verify the output before executing

CREATE OR REPLACE FUNCTION update_or_insert_package()
RETURNS TRIGGER AS
$$
DECLARE
	activate_package_exists BOOLEAN;
BEGIN
	SELECT EXISTS (
    	SELECT 1
    	FROM "TRANSACTION" AS T
    	JOIN "PAKET" AS P ON P.nama = T.nama_paket
    	JOIN "DUKUNGAN_PERANGKAT" AS D ON D.nama_paket = P.nama
    	WHERE
        	T.nama_paket IS NOT NULL
        	AND T.username = NEW.username
        	AND CURRENT_DATE < T.end_date_time
        	AND CURRENT_DATE >= T.start_date_time
) INTO activate_package_exists;

	IF activate_package_exists THEN
    	UPDATE "TRANSACTION"
    	SET
        	nama_paket = NEW.nama_paket,
        	start_date_time = CURRENT_DATE ,
        	end_date_time = CURRENT_DATE + INTERVAL '1 month', 
        	metode_pembayaran = NEW.metode_pembayaran,
        	timestamp_pembayaran = CURRENT_TIMESTAMP
    	WHERE nama_paket IS NOT NULL
        	AND username = NEW.username
        	AND CURRENT_DATE < end_date_time
        	AND CURRENT_DATE >= start_date_time;
        RETURN NULL;
	END IF;
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- Trigger ketika ingin menambahkan transaksi langganan untuk memeriksa apakah ada paket yang aktif atau tidak
CREATE TRIGGER check_activate_package
BEFORE INSERT ON "TRANSACTION"
FOR EACH ROW EXECUTE PROCEDURE update_or_insert_package();

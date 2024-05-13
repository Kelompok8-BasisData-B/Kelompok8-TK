-- Trigger 5
-- Memeriksa Paket yang aktif (Jika ada maka dilakukan operasi update, jika tidak maka dilakukan operasi insert)
create or replace function update_or_insert_package () returns trigger as $$
DECLARE
    activate_package_exists BOOLEAN;
BEGIN
    WITH transaction_check AS (
    SELECT 1
    FROM "TRANSACTION" T
    INNER JOIN "PAKET" P ON T.nama_paket = P.nama
    INNER JOIN "DUKUNGAN_PERANGKAT" D ON P.nama = D.nama_paket
    WHERE T.nama_paket IS NOT NULL
      AND T.username = NEW.username  
      AND CURRENT_DATE < T.end_date_time
      AND CURRENT_DATE >= T.start_date_time
    )
    SELECT EXISTS (SELECT 1 FROM transaction_check) INTO activate_package_exists;
    IF (activate_package_exists) THEN
        UPDATE "TRANSACTION" AS T
        SET
            nama_paket = NEW.nama_paket,
            start_date_time = NEW.start_date_time,
            end_date_time = NEW.end_date_time, 
            metode_pembayaran = NEW.metode_pembayaran,
            timestamp_pembayaran = NEW.timestamp_pembayaran
        WHERE T.username = NEW.username
            AND CURRENT_DATE < T.end_date_time
            AND CURRENT_DATE >= T.start_date_time;
    END IF;

    RETURN NEW;
END;
$$ language plpgsql;

-- Trigger ketika ingin menambahkan transaksi langganan untuk memeriksa apakah ada paket yang aktif atau tidak
CREATE TRIGGER check_activate_package
BEFORE INSERT ON "TRANSACTION"
FOR EACH ROW EXECUTE PROCEDURE update_or_insert_package();

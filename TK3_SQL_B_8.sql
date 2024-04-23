-- PENGGUNA
CREATE TABLE PENGGUNA(
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL,
    id_tayangan UUID NOT NULL,
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN (id_tayangan)
);

-- PAKET
CREATE TABLE PAKET(
    nama VARCHAR(50) PRIMARY KEY,
    harga INT NOT NULL CHECK (harga >= 0),
    resolusi_layar VARCHAR(50) NOT NULL
);

-- DUKUNGAN_PERANGKAT
CREATE TABLE DUKUNGAN_PERANGKAT(
    nama_paket VARCHAR(50) NOT NULL,
    dukungan_perangkat VARCHAR(50) NOT NULL,
    PRIMARY KEY (nama_paket, dukungan_perangkat),
    FOREIGN KEY (nama_paket) REFERENCES PAKET(nama)
);

-- TRANSACTION
CREATE TABLE TRANSACTION(
    username VARCHAR(50) NOT NULL,
    start_date_time DATE NOT NULL,
    end_date_time DATE,
    nama_paket VARCHAR(50) NOT NULL,
    metode_pembayaran VARCHAR(50) NOT NULL,
    timestamp_pembayaran DATETIME NOT NULL,
    PRIMARY KEY (username, start_date_time), 
    FOREIGN KEY (username) REFERENCES PENGGUNA(username),
    FOREIGN KEY (nama_paket) REFERENCES PAKET(nama)
);

-- CONTRIBUTORS
CREATE TABLE CONTRIBUTORS(
    id UUID PRIMARY KEY, 
    nama VARCHAR(50) NOT NULL,
    jenis_kelamin INT NOT NULL CHECK (jenis_kelamin IN (0, 1)),
    kewarganegaraan VARCHAR(50) NOT NULL
);

-- PENULIS_SKENARIO
CREATE TABLE PENULIS_SKENARIO(
    id UUID PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES CONTRIBUTORS(id)
);

-- PEMAIN
CREATE TABLE PEMAIN(
    id UUID PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES CONTRIBUTORS(id)
);

-- SUTRADARA
CREATE TABLE SUTRADARA(
    id UUID PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES CONTRIBUTORS(id)
);

-- TAYANGAN
CREATE TABLE TAYANGAN(
    id UUID PRIMARY KEY,
    judul VARCHAR(100) NOT NULL,
    sinopsis VARCHAR(255) NOT NULL,
    asal_negara VARCHAR(50) NOT NULL,
    sinopsis_trailer VARCHAR(255) NOT NULL,
    url_video_trailer VARCHAR(255) NOT NULL,
    release_date_trailer DATE NOT NULL,
    id_sutradara UUID NOT NULL,
    FOREIGN KEY (id_sutradara) REFERENCES CONTRIBUTORS(id)
);

-- MEMAINKAN_TAYANGAN
CREATE TABLE MEMAINKAN_TAYANGAN(
    id_tayangan UUID NOT NULL,
    id_pemain UUID NOT NULL,
    PRIMARY KEY (id_tayangan, id_pemain),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id),
    FOREIGN KEY (id_pemain) REFERENCES CONTRIBUTORS(id)
);

-- MENULIS_SKENARIO_TAYANGAN
CREATE TABLE MENULIS_SKENARIO_TAYANGAN(
    id_tayangan UUID NOT NULL,
    id_pemain UUID NOT NULL,
    PRIMARY KEY (id_tayangan, id_pemain),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id),
    FOREIGN KEY (id_pemain) REFERENCES CONTRIBUTORS(id)
);

-- GENRE_TAYANGAN
CREATE TABLE GENRE_TAYANGAN(
    id_tayangan UUID NOT NULL,
    genre VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_tayangan, genre),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN (id)
);

-- PERUSAHAAN_PRODUKSI
CREATE TABLE PERUSAHAAN_PRODUKSI(
    nama VARCHAR(100) PRIMARY KEY
);

-- PERSETUJUAN
CREATE TABLE PERSETUJUAN(
    nama VARCHAR(100) NOT NULL,
    id_tayangan UUID NOT NULL,
    tanggal_persetujuan DATE NOT NULL,
    durasi INT NOT NULL CHECK (durasi >= 0),
    biaya INT NOT NULL CHECK (biaya >= 0),
    tanggal_mulai_penayangan DATE NOT NULL,
    PRIMARY KEY (nama, id_tayangan, tanggal_persetujuan),
    FOREIGN KEY (nama) REFERENCES PERUSAHAAN_PRODUKSI(nama),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id)
);

-- SERIES
CREATE TABLE SERIES(
    id_tayangan DATE NOT NULL
);

-- FILM
CREATE TABLE FILM(
    id_tayangan UUID NOT PRIMARY KEY,
    url_video_film VARCHAR(255) NOT NULL,
    release_date_film DATE NOT NULL,
    durasi_film INT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN (id)
);

-- EPISODE
CREATE TABLE EPISODE(
    id_series UUID NOT NULL,
    sub_judul VARCHAR(100) NOT NULL,
    sinopsis VARCHAR (255) NOT NULL,
    durasi INT NOT NULL DEFAULT 0,
    url_video VARCHAR(255) NOT NULL,
    release_date DATE NOT NULL,
    PRIMARY KEY (id_series, sub_judul),
    FOREIGN KEY (id_series) SERIES (id)
);

-- ULASAN
CREATE TABLE ULASAN(
    id_tayangan UUID NOT NULL,
    username VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    rating INT NOT NULL DEFAULT 0,
    deskripsi VARCHAR(255),
    PRIMARY KEY (username, timestamp),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id),
    FOREIGN KEY (username) REFERENCES PENGGUNA(username)
);

-- TAYANGAN_MEMILIKI_DAFTAR_FAVORIT
CREATE TABLE TAYANGAN_MEMILIKI_DAFTAR_FAVORIT(
    id_tayangan UUID NOT NULL,
    timestamp TIMESTAMP NOT NULL, 
    username VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_tayangan, timestamp, username)
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id),
    FOREIGN KEY (timestamp) REFERENCES DAFTAR_FAVORIT(timestamp),
    FOREIGN KEY (username) REFERENCES DAFTAR_FAVORIT(username)
);

-- DAFTAR_FAVORIT
CREATE TABLE DAFTAR_FAVORIT(
    timestamp TIMESTAMP NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    judul VARCHAR(50) NOT NULL,
    PRIMARY KEY (timestamp, username)
    FOREIGN KEY (username) REFERENCES PENGGUNA(username)
);

-- RIWAYAT_NONTON
CREATE TABLE RIWAYAT_NONTON(
    id_tayangan UUID NOT NULL,
    username VARCHAR(50) NOT NULL,
    start_date_time TIMESTAMP NOT NULL,
    end_date_time TIMESTAMP NOT NULL,
    PRIMARY KEY (username, start_date_time),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id),
    FOREIGN KEY (username) REFERENCES PENGGUNA(username)
);

-- TAYANGAN_TERUNDUH
CREATE TABLE TAYANGAN_TERUNDUH(
    id_tayangan UUID NOT NULL,
    username VARCHAR(50) NOT NULL, 
    timestamp TIMESTAMP,
    PRIMARY KEY(id_tayangan, username, timestamp),
    FOREIGN KEY(id_tayangan) REFERENCES TAYANGAN(id),
    FOREIGN KEY (username) REFERENCES PENGGUNA(username)
);
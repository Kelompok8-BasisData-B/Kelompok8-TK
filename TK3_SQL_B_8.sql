-- PENGGUNA --
CREATE TABLE PENGGUNA(
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL,
    id_tayangan UUID,
    negara_asal VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN (id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- PAKET --
CREATE TABLE PAKET(
    nama VARCHAR(50) PRIMARY KEY,
    harga INT NOT NULL CHECK (harga >= 0),
    resolusi_layar VARCHAR(50) NOT NULL
);

-- DUKUNGAN_PERANGKAT -- 
CREATE TABLE DUKUNGAN_PERANGKAT(
    nama_paket VARCHAR(50),
    dukungan_perangkat VARCHAR(50),
    PRIMARY KEY (nama_paket, dukungan_perangkat),
    FOREIGN KEY (nama_paket) REFERENCES PAKET(nama) ON UPDATE CASCADE ON DELETE CASCADE
);

-- TRANSACTION --
CREATE TABLE TRANSACTION(
    username VARCHAR(50),
    start_date_time DATE,
    end_date_time DATE,
    nama_paket VARCHAR(50),
    metode_pembayaran VARCHAR(50) NOT NULL,
    timestamp_pembayaran TIMESTAMP NOT NULL,
    PRIMARY KEY (username, start_date_time), 
    FOREIGN KEY (username) REFERENCES PENGGUNA(username) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (nama_paket) REFERENCES PAKET(nama) ON UPDATE CASCADE ON DELETE CASCADE
);

-- CONTRIBUTORS -- 
CREATE TABLE CONTRIBUTORS(
    id UUID PRIMARY KEY, 
    nama VARCHAR(50) NOT NULL,
    jenis_kelamin INT NOT NULL CHECK (jenis_kelamin IN (0, 1)),
    kewarganegaraan VARCHAR(50) NOT NULL
);

-- PENULIS_SKENARIO --
CREATE TABLE PENULIS_SKENARIO(
    id UUID PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES CONTRIBUTORS(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- PEMAIN --
CREATE TABLE PEMAIN(
    id UUID PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES CONTRIBUTORS(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- SUTRADARA --
CREATE TABLE SUTRADARA(
    id UUID PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES CONTRIBUTORS(id) ON UPDATE CASCADE ON DELETE CASCADE
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
    id_sutradara UUID,
    FOREIGN KEY (id_sutradara) REFERENCES SUTRADARA(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- MEMAINKAN_TAYANGAN --
CREATE TABLE MEMAINKAN_TAYANGAN(
    id_tayangan UUID,
    id_pemain UUID,
    PRIMARY KEY (id_tayangan, id_pemain),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id)  ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_pemain) REFERENCES PEMAIN(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- MENULIS_SKENARIO_TAYANGAN 
CREATE TABLE MENULIS_SKENARIO_TAYANGAN(
    id_tayangan UUID,
    id_penulis_skenario UUID,
    PRIMARY KEY (id_tayangan, id_penulis_skenario),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_penulis_skenario) REFERENCES PENULIS_SKENARIO(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- GENRE_TAYANGAN --
CREATE TABLE GENRE_TAYANGAN(
    id_tayangan UUID,
    genre VARCHAR(50),
    PRIMARY KEY (id_tayangan, genre),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN (id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- PERUSAHAAN_PRODUKSI --
CREATE TABLE PERUSAHAAN_PRODUKSI(
    nama VARCHAR(100) PRIMARY KEY
);

-- PERSETUJUAN --
CREATE TABLE PERSETUJUAN(
    nama VARCHAR(100),
    id_tayangan UUID,
    tanggal_persetujuan DATE,
    durasi INT NOT NULL CHECK (durasi >= 0),
    biaya INT NOT NULL CHECK (biaya >= 0),
    tanggal_mulai_penayangan DATE NOT NULL,
    PRIMARY KEY (nama, id_tayangan, tanggal_persetujuan),
    FOREIGN KEY (nama) REFERENCES PERUSAHAAN_PRODUKSI(nama) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- SERIES --
CREATE TABLE SERIES(
    id_tayangan UUID PRIMARY KEY,
    FOREIGN KEY(id_tayangan) REFERENCES TAYANGAN(id)
);

-- FILM --
CREATE TABLE FILM(
    id_tayangan UUID PRIMARY KEY,
    url_video_film VARCHAR(255) NOT NULL,
    release_date_film DATE NOT NULL,
    durasi_film INT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN (id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- EPISODE --
CREATE TABLE EPISODE(
    id_series UUID,
    sub_judul VARCHAR(100),
    sinopsis VARCHAR (255) NOT NULL,
    durasi INT NOT NULL DEFAULT 0,
    url_video VARCHAR(255) NOT NULL,
    release_date DATE NOT NULL,
    PRIMARY KEY (id_series, sub_judul),
    FOREIGN KEY (id_series) REFERENCES SERIES (id_tayangan) ON UPDATE CASCADE ON DELETE CASCADE
);

-- ULASAN --
CREATE TABLE ULASAN(
    id_tayangan UUID,
    username VARCHAR(50),
    timestamp TIMESTAMP,
    rating INT NOT NULL DEFAULT 0,
    deskripsi VARCHAR(255),
    PRIMARY KEY (username, timestamp),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (username) REFERENCES PENGGUNA(username) ON UPDATE CASCADE ON DELETE CASCADE
);

-- TAYANGAN_MEMILIKI_DAFTAR_FAVORIT --
CREATE TABLE TAYANGAN_MEMILIKI_DAFTAR_FAVORIT(
    id_tayangan UUID,
    timestamp TIMESTAMP, 
    username VARCHAR(50),
    PRIMARY KEY (id_tayangan, timestamp, username),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (username, timestamp) REFERENCES DAFTAR_FAVORIT(username, timestamp) ON UPDATE CASCADE ON DELETE CASCADE
);

-- DAFTAR_FAVORIT --
CREATE TABLE DAFTAR_FAVORIT(
    timestamp TIMESTAMP,
    username VARCHAR(50),
    judul VARCHAR(50) NOT NULL,
    PRIMARY KEY (timestamp, username),
    FOREIGN KEY (username) REFERENCES PENGGUNA(username) ON UPDATE CASCADE ON DELETE CASCADE
);

-- RIWAYAT_NONTON --
CREATE TABLE RIWAYAT_NONTON(
    id_tayangan UUID,
    username VARCHAR(50),
    start_date_time TIMESTAMP,
    end_date_time TIMESTAMP NOT NULL,
    PRIMARY KEY (username, start_date_time),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (username) REFERENCES PENGGUNA(username) ON UPDATE CASCADE ON DELETE CASCADE
);

-- TAYANGAN_TERUNDUH --
CREATE TABLE TAYANGAN_TERUNDUH(
    id_tayangan UUID,
    username VARCHAR(50), 
    timestamp TIMESTAMP,
    PRIMARY KEY(id_tayangan, username, timestamp),
    FOREIGN KEY(id_tayangan) REFERENCES TAYANGAN(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (username) REFERENCES PENGGUNA(username) ON UPDATE CASCADE ON DELETE CASCADE
);

-- INSERT PENGGUNA --
INSERT INTO PENGGUNA VALUES ('andi1234','pass1ABC','c789d4e6-dbdf-4d80-9d54-62e2c010effa','Indonesia'),
	('budi5678','pass2DEF','8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','Indonesia'),
	('citra9012','pass3GHI','e3dec337-6afe-4959-a181-b85b4006f956','Indonesia'),
	('dewi3456','pass4JKL','e0f1fc0c-02a7-494d-96ba-e9519326202a','Indonesia'),
	('eko7890','pass5MNO','1fdc19f5-89e5-496c-b6e6-162fae666d96','Indonesia'),
	('fani1234','pass6PQR','5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','Indonesia'),
	('gita5678','pass7STU','ad291c00-061f-40ba-920c-8d59b9420d33','Indonesia'),
	('hendra9012','pass8VWX','ad291c00-061f-40ba-920c-8d59b9420d33','Indonesia');

-- INSERT PAKET -- 
INSERT INTO PAKET VALUES ('Basic',50000.0,'720p'),
	('Standar',100000.0,'1080p'),
	('Premium',150000.0,'4K');

-- INSERT DUKUNGAN PERANGKAT --
INSERT INTO DUKUNGAN_PERANGKAT VALUES ('Premium','Televisi'),
	('Premium','Komputer'),
	('Premium','Telepon genggam'),
	('Premium','Tablet'),
	('Standar','Komputer'),
	('Standar','Telepon genggam'),
	('Standar','Tablet'),
	('Basic','Telepon genggam');

-- INSERT TRANSACTION --
INSERT INTO TRANSACTION VALUES ('andi1234','2024-01-01 00:00:00','2024-02-01 00:00:00','Basic','Transfer Bank','2024-01-01 08:32:15'),
	('budi5678','2024-01-02 00:00:00','2024-02-02 00:00:00','Basic','Transfer Bank','2024-01-02 10:45:27'),
	('citra9012','2024-01-02 00:00:00','2024-02-02 00:00:00','Standar','Transfer Bank','2024-01-02 12:20:38'),
	('dewi3456','2024-01-03 00:00:00','2024-02-03 00:00:00','Basic','Kartu Kredit','2024-01-03 14:55:49'),
	('eko7890','2024-01-05 00:00:00','2024-02-05 00:00:00','Premium','Transfer Bank','2024-01-05 16:10:52'),
	('fani1234','2024-01-05 00:00:00','2024-02-05 00:00:00','Standar','Transfer Bank','2024-01-05 18:25:33'),
	('gita5678','2024-01-07 00:00:00','2024-02-07 00:00:00','Standar','Transfer Bank','2024-01-07 20:45:44'),
	('hendra9012','2024-01-08 00:00:00','2024-02-08 00:00:00','Premium','Kartu Kredit','2024-01-08 22:35:16'),
	('eko7890','2024-02-09 00:00:00','2024-03-09 00:00:00','Basic','Transfer Bank','2024-02-09 09:15:27'),
	('citra9012','2024-02-10 00:00:00','2024-03-10 00:00:00','Standar','Kartu Kredit','2024-02-10 11:20:18'),
	('andi1234','2024-02-11 00:00:00','2024-03-11 00:00:00','Basic','Transfer Bank','2024-02-11 13:40:29'),
	('fani1234','2024-02-12 00:00:00','2024-03-12 00:00:00','Standar','Transfer Bank','2024-02-12 15:55:30'),
	('budi5678','2024-02-13 00:00:00','2024-03-13 00:00:00','Basic','Kartu Kredit','2024-02-13 17:30:31'),
	('gita5678','2024-02-08 00:00:00','2024-03-08 00:00:00','Premium','Transfer Bank','2024-02-08 18:20:22'),
	('dewi3456','2024-02-15 00:00:00','2024-03-15 00:00:00','Premium','Kartu Kredit','2024-02-15 20:10:23'),
	('eko7890','2024-03-16 00:00:00','2024-04-16 00:00:00','Basic','Transfer Bank','2024-03-16 09:45:24'),
	('andi1234','2024-03-17 00:00:00','2024-04-17 00:00:00','Basic','Kartu Kredit','2024-03-17 11:35:35'),
	('citra9012','2024-03-18 00:00:00','2024-04-18 00:00:00','Standar','Transfer Bank','2024-03-18 13:55:26'),
	('hendra9012','2024-02-19 00:00:00','2024-03-19 00:00:00','Premium','Kartu Kredit','2024-02-19 15:40:37'),
	('fani1234','2024-03-20 00:00:00','2024-04-20 00:00:00','Standar','Transfer Bank','2024-03-20 17:25:48'),
	('budi5678','2024-03-21 00:00:00','2024-04-21 00:00:00','Premium','Kartu Kredit','2024-03-21 19:15:39'),
	('gita5678','2024-03-22 00:00:00','2024-04-22 00:00:00','Basic','Transfer Bank','2024-03-22 20:30:40'),
	('dewi3456','2024-03-23 00:00:00','2024-04-23 00:00:00','Basic','Kartu Kredit','2024-03-23 22:05:41'),
	('hendra9012','2024-03-23 00:00:00','2024-04-23 00:00:00','Premium','Kartu Kredit','2024-03-23 08:45:52');

-- INSERT COLABORATORS --
INSERT INTO CONTRIBUTORS VALUES ('8fa38df9-4c2b-3bef-a2a6-01097e2c4e05','Travon Ferry',0.0,'Zambia'),
	('49d37f66-038b-329d-92b6-024637cec90d','Mrs. Jazmin Towne Sr.',1.0,'Botswana'),
	('948b330b-0751-3502-a418-02650ebd35f2','Isabel Schaden',1.0,'Bulgaria'),
	('ef86988d-b59f-3a65-a4bf-02b0bc102a78','Lamont Simonis DDS',1.0,'Montserrat'),
	('82d98460-7aff-3ec5-8e41-04226681185f','Zelda Rath',0.0,'Turkmenistan'),
	('00ffb3f0-e611-38a4-8351-0796f1fb21d6','Antonetta Monahan',1.0,'Singapore'),
	('3860b4a2-921f-36be-80c7-07b6f55b122f','Tyree Daugherty',0.0,'Falkland Islands (Malvinas)'),
	('7f621528-d17c-33e1-80f3-0abf8fb059bc','Alysson Ruecker',1.0,'Croatia'),
	('b7bd9127-c61d-3934-a05b-0b4afe30cd98','Dr. Rocio Muller',0.0,'Albania'),
	('e176f588-8f8b-33e7-abc3-0d12b0661cdf','Maria Koelpin',0.0,'Tajikistan'),
	('46039e48-bd98-3b2f-b9a7-10a809adf865','Tabitha Hansen',0.0,'Morocco'),
	('68a61560-cf4b-3f14-bbbe-130226b34a5d','Chris Barton',1.0,'Kazakhstan'),
	('d6a40a31-ab02-35c8-a72d-141787f10ca2','Prof. Mark Kozey',1.0,'Monaco'),
	('da8ab35d-6b80-33bc-916c-15f1263029f8','Juana Ruecker',0.0,'Hungary'),
	('ba24fc81-a9b4-3998-8b1f-169832f4e943','Elisa Weissnat',1.0,'Saint Pierre and Miquelon'),
	('1ece913d-e5a0-3a1f-8e35-175a134b07c7','Geovanny Kub',0.0,'Slovakia (Slovak Republic)'),
	('136eccc7-ca0c-3ffe-bddf-17e21ef2220a','Cassandra Runolfsson',0.0,'Holy See (Vatican City State)'),
	('22e12277-1d38-3fa4-b7e1-197739b64c98','Emmitt Nienow',1.0,'Saint Martin'),
	('b7f6bc99-1340-3991-befb-1e67286b5076','Nayeli Donnelly',0.0,'Anguilla'),
	('ed19732a-d6f8-389c-b93f-1e73fa800ba9','Elena Schoen',0.0,'Lao People''s Democratic Republic'),
	('4e75be4a-0a20-34f9-a6ee-24fb7cfc8aaf','Angelita Hammes',0.0,'Saint Vincent and the Grenadines'),
	('ada162e8-5cee-3abe-976d-2557ca166d72','Michel Block',0.0,'Lithuania'),
	('37ee720a-f1b2-386d-bb07-2758e9d2933f','Rosario Hackett',1.0,'Guadeloupe'),
	('d9cf225b-88e7-3f7b-a940-27600d1d9f6f','Dr. Samson Blick',1.0,'Myanmar'),
	('056ee446-926b-3431-a297-29a48b03c7cc','Dr. Stone Reichel',1.0,'Somalia'),
	('c19cc3e7-fde2-3a9c-b491-2d083d25dba4','Felix Nitzsche I',1.0,'Austria'),
	('39064dad-a29c-3ae5-bfb1-2d117233fdf7','Dr. Brian Champlin Sr.',0.0,'Costa Rica'),
	('22b6a38d-d1bf-3e3d-8391-2d49937031f2','Martine Cruickshank',0.0,'Saint Pierre and Miquelon'),
	('38f4a1d8-ee37-39a6-af7e-2f02004d3433','Dr. Estell White DVM',0.0,'Algeria'),
	('a780956e-2905-3a7b-8874-31e16d76fd4a','Annie Connelly IV',0.0,'Sudan'),
	('7878aca9-a714-3f48-be46-325f6b4b32b6','Payton Marquardt',0.0,'Malta'),
	('69a06fd0-9eb3-3979-a0f4-327304685d34','Reilly Robel',0.0,'France'),
	('241b0dba-2690-30a3-bbbd-32c5dd8ea2d0','Lucie Runte',0.0,'Falkland Islands (Malvinas)'),
	('a83522a4-13c5-3ed8-94d3-36967a037472','Tyrel Considine',0.0,'Burkina Faso'),
	('a8ba3928-b87d-3be5-b5e2-387559b654e1','Felton Gutkowski',1.0,'Cook Islands'),
	('98273256-ee10-3cb6-8917-39c8f2c2704e','Lavern Hessel',1.0,'Falkland Islands (Malvinas)'),
	('3295a7a8-4998-37d9-8ed6-433fca05c1ce','Reina Windler',0.0,'Korea'),
	('59856dee-f83b-3989-88bd-4342847e203d','Chyna Runolfsdottir',0.0,'Guyana'),
	('76213b92-e75e-3fc1-a328-4382c731474e','Makenna Marquardt',1.0,'Albania'),
	('8eced8ed-9912-34f2-8701-43b2e6387d61','Annalise Bernhard V',0.0,'Yemen'),
	('49007aed-76df-36f9-881b-44a2d86a39a2','Adrain Kemmer',1.0,'Libyan Arab Jamahiriya'),
	('7275815c-de7c-381b-8607-44abcd568d87','Aaron Hudson',0.0,'Tonga'),
	('94ff6764-3940-31dc-bbde-46b5ff6a9297','Katlynn Spinka',1.0,'Cameroon'),
	('e1755b42-5e7a-3ba1-8f5e-472f00f5570e','Ross Medhurst IV',0.0,'Botswana'),
	('9baac995-e771-3cad-890a-4a2361a5bc5f','Jerel Kemmer',1.0,'Liechtenstein'),
	('62a03bf8-6f8b-3274-a7f7-4b82973a1beb','Mrs. Vincenza Macejkovic IV',1.0,'Guam'),
	('e0aef48d-58c1-3b55-bde9-4d65656e6d0b','Elenor Schoen',0.0,'Central African Republic'),
	('08e082f9-b8af-3f32-bf92-4f657b2d976e','Prof. Lisette Gibson Jr.',1.0,'Lao People''s Democratic Republic'),
	('83299f9e-5a29-332f-a8bf-534da87dd146','Vanessa Thompson',1.0,'New Caledonia'),
	('ef721d95-f7cf-3bdb-a62d-5398e300e11d','Prof. Marshall Volkman',1.0,'Serbia'),
	('e5cbc9b5-1cd7-340a-9d7b-54dd7e10e393','Kaci Schmitt',0.0,'Haiti'),
	('96c4ed3c-3005-3e59-a1b3-56a70599e94e','Weston Luettgen V',0.0,'Guam'),
	('91bb7623-a72c-373c-b0a7-58b7779a7595','Alan McLaughlin',0.0,'Guatemala'),
	('f74b61d8-abe3-3a37-a0d4-59555c545a2c','Sarah Hagenes',1.0,'Thailand'),
	('7b6570ff-f8ef-3e64-a25e-59dd3797238a','Abelardo Dicki',1.0,'Niue'),
	('ab8f7d29-5a48-3bf7-a806-5a315d54b5f5','Ms. Theodora Kessler',1.0,'Slovakia (Slovak Republic)'),
	('3df3fe7b-bd39-3310-b184-5c434a69af47','Berniece Torphy',0.0,'Jamaica'),
	('f8068cc1-8cda-3794-a951-5efe707fb134','Ernestina Kemmer',0.0,'Mayotte'),
	('bd73df8f-4480-3f33-8f36-63c76e939e86','Dr. Chadrick Williamson',0.0,'Malaysia'),
	('9b1eaece-0dcf-3d01-8d4d-63f954796f8e','Weldon Ernser Sr.',0.0,'Iraq'),
	('26e719b7-bfc8-3d05-83d5-6534fab2abcb','Deven Davis',0.0,'Ireland'),
	('89a8611e-603f-36d0-91c4-668764f31343','King Breitenberg',0.0,'Ireland'),
	('e9c477af-9cf2-37c6-9eef-66a6500cefbf','Prof. Manley Volkman DVM',1.0,'Morocco'),
	('497fd52e-39d7-37da-9cb8-67399483b06d','Jabari Sipes',0.0,'Paraguay'),
	('327c8e32-4ea5-330e-a94f-68b0c0d1cbc6','Courtney Kreiger',0.0,'Liberia'),
	('b23c2089-20cc-3d79-a855-68fce31f1d91','Dr. Mathias McClure',1.0,'Cambodia'),
	('dd6c0ad8-142c-3233-9f9d-6906c15614b2','Magnus Zulauf',1.0,'Lao People''s Democratic Republic'),
	('810e90d3-00b9-3cf3-aa02-693795c1c9d7','Brisa Baumbach',1.0,'India'),
	('280dc5be-6283-36cf-bb98-6b023bc08136','Gordon Hirthe',0.0,'Malaysia'),
	('509740e8-b117-3fd7-a481-6b0aaf31bb52','Jena King',1.0,'Norfolk Island'),
	('6a0971fd-3fab-3bd1-a006-7097cbef92b0','Carlo Konopelski V',0.0,'Monaco'),
	('0f036bc6-1fc3-3c5b-8a36-724a50c35998','Chanel Robel Sr.',1.0,'Argentina'),
	('506d50ba-1e5c-3a53-b998-73fdce38581c','Hanna Padberg',1.0,'Germany'),
	('a61597db-f5f8-3694-8077-786d3e633544','Prof. Arely Emmerich IV',0.0,'Belize'),
	('be5aee9f-a79a-324c-b272-7c15f74613d9','Dawn Champlin',0.0,'South Georgia and the South Sandwich Islands'),
	('5c68c702-eed4-3bf1-b688-7cab14147254','Wyatt Ward',0.0,'Australia'),
	('2f5c5214-23ed-3c3c-9aa0-7f2fb6dbd9e1','Alverta Huels',1.0,'Reunion'),
	('72b185ad-40f1-31b2-90a9-820989f8214a','Cindy Kutch',1.0,'Nicaragua'),
	('4feab376-758d-30c2-b656-83ca796f9c04','Renee Russel',1.0,'El Salvador'),
	('ffe3af0c-14ba-328c-9c0a-84e07b7532cc','Alta Ernser',0.0,'Macao'),
	('8a2d3b36-499e-3358-90c5-85c2cec418fc','Frieda Rau',1.0,'Macao'),
	('0bba211c-4b7d-35c2-9700-8a4ffc99e453','Lorna Fisher',1.0,'Turkey'),
	('877b6c42-acab-39b4-8cd5-8c46443e82d9','Bart Abbott DVM',0.0,'Honduras'),
	('f82a6789-ca74-3c03-9bd8-8d0f0a2e0c69','Perry Wintheiser',1.0,'Korea'),
	('15254dd9-9ad9-3025-9799-91f66ce35bc0','Maynard Bergnaum',1.0,'Burundi'),
	('9568257e-50fd-348e-a0d5-92324a340082','Jules Gerlach',1.0,'Ireland'),
	('f3aa7b01-8871-3eee-9585-9449451975d6','Sidney Ebert',1.0,'Honduras'),
	('6587c181-50b6-326f-94c4-95ade22954e3','Lisette Hamill',0.0,'Slovakia (Slovak Republic)'),
	('7c752282-81f6-30b7-8802-97702ab76fc3','Prof. Kailyn Lubowitz II',1.0,'Cameroon'),
	('b43ffb8b-3eb4-3ce7-b136-98a77e967820','Ericka Johnston',0.0,'Falkland Islands (Malvinas)'),
	('627b72a5-6b3f-3ac6-9b8e-9b3c68d776f0','Florida Hilll IV',1.0,'Armenia'),
	('32bae4d1-5531-3176-84cb-9b427228dc60','Leola Stracke',0.0,'Zambia'),
	('45cb9676-cb77-31b2-ab2f-9d4d7f9d70a7','Zack Tillman DVM',1.0,'Suriname'),
	('7ad78dcd-a2e3-3234-9475-9d86e48d8a8b','Dr. Allene Wehner',1.0,'Thailand'),
	('d9e43365-ca23-3028-8817-a0291c47fcbe','Miss Laurie Jones PhD',1.0,'Reunion'),
	('0c728e23-59da-3bd4-a496-a0567d2a3145','Kenna Mayer',1.0,'Martinique'),
	('87c78805-c924-32dd-963e-a1f4a6f0b6c9','Albin Collier',1.0,'Estonia'),
	('74085c98-f74d-32c4-a293-a48445050b26','Prof. Jalon Hauck',0.0,'Gabon'),
	('5940abe4-28e9-3c35-90ed-a4898173e991','Mrs. Ludie Langosh',1.0,'Japan'),
	('b8c16296-2d5d-3fd8-8471-a7bcbbe5038f','Athena O''Keefe I',1.0,'Timor-Leste');

-- INSERT PENULIS SKENARIO -- 
INSERT INTO PENULIS_SKENARIO VALUES ('8fa38df9-4c2b-3bef-a2a6-01097e2c4e05'),
	('49d37f66-038b-329d-92b6-024637cec90d'),
	('948b330b-0751-3502-a418-02650ebd35f2'),
	('ef86988d-b59f-3a65-a4bf-02b0bc102a78'),
	('82d98460-7aff-3ec5-8e41-04226681185f'),
	('00ffb3f0-e611-38a4-8351-0796f1fb21d6'),
	('3860b4a2-921f-36be-80c7-07b6f55b122f'),
	('7f621528-d17c-33e1-80f3-0abf8fb059bc'),
	('b7bd9127-c61d-3934-a05b-0b4afe30cd98'),
	('e176f588-8f8b-33e7-abc3-0d12b0661cdf'),
	('46039e48-bd98-3b2f-b9a7-10a809adf865'),
	('68a61560-cf4b-3f14-bbbe-130226b34a5d'),
	('d6a40a31-ab02-35c8-a72d-141787f10ca2'),
	('da8ab35d-6b80-33bc-916c-15f1263029f8'),
	('ba24fc81-a9b4-3998-8b1f-169832f4e943'),
	('1ece913d-e5a0-3a1f-8e35-175a134b07c7'),
	('136eccc7-ca0c-3ffe-bddf-17e21ef2220a'),
	('22e12277-1d38-3fa4-b7e1-197739b64c98'),
	('b7f6bc99-1340-3991-befb-1e67286b5076'),
	('ed19732a-d6f8-389c-b93f-1e73fa800ba9'),
	('4e75be4a-0a20-34f9-a6ee-24fb7cfc8aaf'),
	('ada162e8-5cee-3abe-976d-2557ca166d72'),
	('37ee720a-f1b2-386d-bb07-2758e9d2933f'),
	('d9cf225b-88e7-3f7b-a940-27600d1d9f6f'),
	('056ee446-926b-3431-a297-29a48b03c7cc'),
	('c19cc3e7-fde2-3a9c-b491-2d083d25dba4'),
	('39064dad-a29c-3ae5-bfb1-2d117233fdf7'),
	('22b6a38d-d1bf-3e3d-8391-2d49937031f2'),
	('38f4a1d8-ee37-39a6-af7e-2f02004d3433'),
	('a780956e-2905-3a7b-8874-31e16d76fd4a');

-- INSERT PEMAIN --
INSERT INTO PEMAIN VALUES ('7878aca9-a714-3f48-be46-325f6b4b32b6'),
	('69a06fd0-9eb3-3979-a0f4-327304685d34'),
	('241b0dba-2690-30a3-bbbd-32c5dd8ea2d0'),
	('a83522a4-13c5-3ed8-94d3-36967a037472'),
	('a8ba3928-b87d-3be5-b5e2-387559b654e1'),
	('98273256-ee10-3cb6-8917-39c8f2c2704e'),
	('3295a7a8-4998-37d9-8ed6-433fca05c1ce'),
	('59856dee-f83b-3989-88bd-4342847e203d'),
	('76213b92-e75e-3fc1-a328-4382c731474e'),
	('8eced8ed-9912-34f2-8701-43b2e6387d61'),
	('49007aed-76df-36f9-881b-44a2d86a39a2'),
	('7275815c-de7c-381b-8607-44abcd568d87'),
	('94ff6764-3940-31dc-bbde-46b5ff6a9297'),
	('e1755b42-5e7a-3ba1-8f5e-472f00f5570e'),
	('9baac995-e771-3cad-890a-4a2361a5bc5f'),
	('62a03bf8-6f8b-3274-a7f7-4b82973a1beb'),
	('e0aef48d-58c1-3b55-bde9-4d65656e6d0b'),
	('08e082f9-b8af-3f32-bf92-4f657b2d976e'),
	('83299f9e-5a29-332f-a8bf-534da87dd146'),
	('ef721d95-f7cf-3bdb-a62d-5398e300e11d'),
	('e5cbc9b5-1cd7-340a-9d7b-54dd7e10e393'),
	('96c4ed3c-3005-3e59-a1b3-56a70599e94e'),
	('91bb7623-a72c-373c-b0a7-58b7779a7595'),
	('f74b61d8-abe3-3a37-a0d4-59555c545a2c'),
	('7b6570ff-f8ef-3e64-a25e-59dd3797238a'),
	('ab8f7d29-5a48-3bf7-a806-5a315d54b5f5'),
	('3df3fe7b-bd39-3310-b184-5c434a69af47'),
	('f8068cc1-8cda-3794-a951-5efe707fb134'),
	('bd73df8f-4480-3f33-8f36-63c76e939e86'),
	('9b1eaece-0dcf-3d01-8d4d-63f954796f8e'),
	('26e719b7-bfc8-3d05-83d5-6534fab2abcb'),
	('89a8611e-603f-36d0-91c4-668764f31343'),
	('e9c477af-9cf2-37c6-9eef-66a6500cefbf'),
	('497fd52e-39d7-37da-9cb8-67399483b06d'),
	('327c8e32-4ea5-330e-a94f-68b0c0d1cbc6'),
	('b23c2089-20cc-3d79-a855-68fce31f1d91'),
	('dd6c0ad8-142c-3233-9f9d-6906c15614b2'),
	('810e90d3-00b9-3cf3-aa02-693795c1c9d7'),
	('280dc5be-6283-36cf-bb98-6b023bc08136'),
	('509740e8-b117-3fd7-a481-6b0aaf31bb52');

-- INSERT SUTRADARA --
INSERT INTO SUTRADARA VALUES ('6a0971fd-3fab-3bd1-a006-7097cbef92b0'),
	('0f036bc6-1fc3-3c5b-8a36-724a50c35998'),
	('506d50ba-1e5c-3a53-b998-73fdce38581c'),
	('a61597db-f5f8-3694-8077-786d3e633544'),
	('be5aee9f-a79a-324c-b272-7c15f74613d9'),
	('5c68c702-eed4-3bf1-b688-7cab14147254'),
	('2f5c5214-23ed-3c3c-9aa0-7f2fb6dbd9e1'),
	('72b185ad-40f1-31b2-90a9-820989f8214a'),
	('4feab376-758d-30c2-b656-83ca796f9c04'),
	('ffe3af0c-14ba-328c-9c0a-84e07b7532cc');

-- INSERT TAYANGAN --
INSERT INTO TAYANGAN VALUES ('9e527ebb-d739-4cbd-92db-1e92c1786705','Godzilla Minus One','Jepang baru saja pulih dari Perang Dunia Kedua ketika bahaya besar muncul di lepas pantai Tokyo. Koichi, seorang pembelot yang trauma dengan konfrontasi pertamanya dengan Godzilla, melihat ini sebagai kesempatan untuk menebus perilakunya selama perang.','Jepang','Di Jepang pascaperang, teror baru muncul; Godzilla. Akankah orang-orang yang menderita dapat bertahan hidup... apalagi melawan?','https://www.youtube.com/watch?v=r7DqccP1Q_4','2023-09-04 00:00:00','6a0971fd-3fab-3bd1-a006-7097cbef92b0'),
	('e3dec337-6afe-4959-a181-b85b4006f956','Barbie','Barbie dan Ken bersenang-senang di dunia Barbie Land yang penuh warna dan tampak sempurna. Namun, ketika mereka mendapat kesempatan untuk pergi ke dunia nyata, mereka segera menemukan suka dan duka hidup di antara manusia.','Amerika Serikat','Tinggal di Barbie Land berarti menjadi makhluk sempurna di tempat yang sempurna. Kecuali jika Anda sedang mengalami krisis eksistensial yang parah. Atau Anda seorang Ken.','https://www.youtube.com/watch?v=pBk4NYhWNMM','2023-05-25 00:00:00','0f036bc6-1fc3-3c5b-8a36-724a50c35998'),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','Oppenheimer','Selama Perang Dunia II, Oppenheimer dan tim ilmuwan menghabiskan waktu bertahun-tahun merancang bom atom. Pekerjaan mereka membuahkan hasil pada 16 Juli 1945, ketika mereka menyaksikan ledakan nuklir pertama di dunia, yang mengubah jalannya sejarah.','Amerika Serikat','Film ini didasarkan pada buku pemenang Hadiah Pulitzer American Prometheus: The Triumph and Tragedy of J. Robert Oppenheimer karya Kai Bird dan mendiang Martin J. Sherwin.','https://www.youtube.com/watch?v=uYPbbksJxIg','2023-05-08 00:00:00','506d50ba-1e5c-3a53-b998-73fdce38581c'),
	('e525d4be-cd8c-4ddd-88c9-46a7cf625ed0','Smugglers','Dua perempuan tiba-tiba terjebak dalam skema penyelundupan berisiko tinggi di sebuah desa kecil yang damai di tepi laut pada tahun 1970an.','Korea Selatan','Di tahun 70-an, dua wanita yang dulunya adalah penyelam laut, tiba-tiba terjun ke bisnis penyelundupan. ','https://www.youtube.com/watch?v=ruCpNQBGXe0','2023-07-24 00:00:00','a61597db-f5f8-3694-8077-786d3e633544'),
	('4de82623-997f-4cf4-8042-d752b3cc68a4','Agak Laen','Empat petugas rumah hantu bertugas sebagai hantu yang menakut-nakuti pengunjung rumah hantu yang ada di sebuah pasar malam. Mengetahui bahwa wahananya tidak menyeramkan, pihak pengelola mencoba sebisa mungkin untuk menghadirkan wahana yang menyeramkan.','Indonesia','Kek mana jadinya kalau Boris, Indra, Bene, dan Oki berniat hati pengen renovasi rumah hantu supaya jadi seram, eh malah ada yang kena serangan jantung di situ?','https://www.youtube.com/watch?v=0YLSPyGA4h0','2023-12-12 00:00:00','be5aee9f-a79a-324c-b272-7c15f74613d9'),
	('c789d4e6-dbdf-4d80-9d54-62e2c010effa','The Boy and the Heron','Mahito berjuang untuk menetap di kota baru setelah kematian ibunya. Namun, ketika seekor bangau yang bisa berbicara memberi tahu Mahito bahwa ibunya masih hidup, dia memasuki menara terbengkalai untuk mencarinya, yang membawanya ke dunia lain.','Jepang','Seorang anak laki-laki bernama Mahito merindukan ibunya berpetualang ke dunia yang dihuni oleh orang hidup dan orang mati. Di sana, kematian berakhir, dan kehidupan menemukan awal yang baru.','https://www.youtube.com/watch?v=f7EDFdA10pg','2023-09-06 00:00:00','5c68c702-eed4-3bf1-b688-7cab14147254'),
	('ea6edb7a-a28a-42a3-97b1-4ed5ebea8e39','Society of the Snow','Pada tahun 1972, sebuah penerbangan Uruguay jatuh di jantung pegunungan Andes yang terpencil, memaksa para penyintas untuk menjadi harapan terbaik bagi satu sama lain.','Spanyol','Bertahan hidup adalah upaya kelompok.','https://www.youtube.com/watch?v=pDak4qLyF4Q','2023-11-27 00:00:00','2f5c5214-23ed-3c3c-9aa0-7f2fb6dbd9e1'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','Petualangan Sherina 2','Sadam, seorang petualang, bertemu kembali dengan teman masa kecilnya yang pemberani, Sherina, saat dia memulai ekspedisi jurnalistik.','Indonesia','Apakah semua rasa penasaran dan kerinduan mulai terbayar? Apa yang akan Sherina dan Sadam lalui dalam petualangan kali ini?','https://www.youtube.com/watch?v=nAx3GaOE5xI','2023-07-20 00:00:00','72b185ad-40f1-31b2-90a9-820989f8214a'),
	('fb4ba980-81fb-40df-9d70-2558e561ad3b','The Zone of Interest','Pada tahun 1943, komandan Auschwitz, Rudolf Höss, dan istrinya, Hedwig, berusaha membangun kehidupan impian bagi keluarga mereka di sebuah rumah tepat di sebelah kamp konsentrasi dan pemusnahan yang ia bantu ciptakan.','Britania Raya','Komandan Auschwitz, Rudolf Höss, dan istrinya Hedwig, berusaha membangun kehidupan impian bagi keluarga mereka di sebuah rumah dan taman di sebelah kamp.','https://www.youtube.com/watch?v=r-vfg3KkV54','2023-10-17 00:00:00','4feab376-758d-30c2-b656-83ca796f9c04'),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','Io Capitano','Mendambakan masa depan yang lebih cerah, dua remaja Senegal memulai perjalanan dari Afrika Barat ke Italia. Namun, antara impian dan kenyataan mereka terdapat labirin pos pemeriksaan, Gurun Sahara, dan perairan Mediterania yang luas.','Italia','Petualangan dua anak muda, Seydou dan Moussa, yang meninggalkan Dakar untuk mencapai Eropa. Sebuah pengembaraan kontemporer melalui bahaya gurun pasir, kengerian pusat penahanan di Libya dan bahaya laut.','https://www.youtube.com/watch?v=idErmD0bA_M','2023-07-25 00:00:00','ffe3af0c-14ba-328c-9c0a-84e07b7532cc'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','The Last of Us','Setelah pandemi global menghancurkan peradaban, seorang penyintas yang tangguh mengambil alih tugas seorang gadis berusia 14 tahun yang mungkin menjadi harapan terakhir umat manusia.','Amerika Serikat','Joel, seorang penyintas yang tangguh, disewa untuk menyelundupkan Ellie, seorang gadis berusia 14 tahun, keluar dari zona karantina yang menindas. Mereka berdua harus melintasi Amerika dan bergantung satu sama lain untuk bertahan hidup.','https://www.youtube.com/watch?v=uLtkt8BonwM','2022-12-04 00:00:00','6a0971fd-3fab-3bd1-a006-7097cbef92b0'),
	('db795d05-bf69-4924-a2cc-564a7b455bf1','Beef','Setelah insiden di tempat parkir, terjadilah kemarahan di jalan yang mengakibatkan perseteruan sengit antara kedua orang tersebut. Balas dendam di antara mereka semakin tidak terkendali, membahayakan segalanya dan semua orang dalam hidup mereka.','Amerika Serikat','Seorang kontraktor gagal yang mempunyai masalah di pundaknya, berhadapan langsung dengan seorang wirausahawan yang memiliki kehidupan indah. Pertaruhan mereka yang semakin besar mengungkap hubungan mereka dalam serial komedi kelam dan mengharukan ini.','https://www.youtube.com/watch?v=Gq7zgg0AQSA','2023-03-15 00:00:00','0f036bc6-1fc3-3c5b-8a36-724a50c35998'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','Poker Face','Charlie Cale, seorang pegawai kasino, memiliki kemampuan luar biasa dalam mendeteksi kebohongan. Dia berkendara keliling negeri dan mulai memecahkan kasus individu acak yang dia temui di jalan.','Amerika Serikat','Charlie yang memiliki kemampuan untuk menentukan kapan seseorang berbohong. Dia mengendarai Plymouth Barracuda-nya dan di setiap perhentian dia bertemu dengan karakter baru dan kejahatan aneh yang ingin dia selesaikan.','https://www.youtube.com/watch?v=4x2NzusLAqk','2023-01-05 00:00:00','506d50ba-1e5c-3a53-b998-73fdce38581c'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','Pluto','Di masa depan di mana robot humanoid hidup menyamar sebagai manusia, sesuatu keluar untuk menghancurkan tujuh robot besar dunia. Gesicht menyelidiki pembunuhan berantai robot misterius ini dan menemukan bahwa dirinya merupakan salah satu targetnya.','Jepang','Pembunuhan terjadi di dunia yang teratur di mana robot tidak mampu membunuh manusia. Penyelidik robot Europol, Gesicht, menangani kasus ini, tetapi misterinya semakin dalam ketika dia tidak menemukan jejak manusia di TKP.','https://www.youtube.com/watch?v=9ez8lm9I26Y','2023-10-03 00:00:00','a61597db-f5f8-3694-8077-786d3e633544'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','The Glory','Seorang siswi sekolah menengah menjadi korban kekerasan, menyebabkan dia putus sekolah dan merencanakan balas dendam. Setelah dewasa, dia memanfaatkan kesempatan untuk balas dendam ketika dia mengetahui bahwa anak dari mantan penyiksanya ada di kelasnya.','Korea Selatan','Jangan mengharapkan belas kasihan. Tirai terbuka atas tragedi suci ini.','https://www.youtube.com/watch?v=kiuPvFvVeXE','2022-12-08 00:00:00','be5aee9f-a79a-324c-b272-7c15f74613d9');

-- INSERT MEMAINKAN TAYANGAN --
INSERT INTO MEMAINKAN_TAYANGAN VALUES ('9e527ebb-d739-4cbd-92db-1e92c1786705','7878aca9-a714-3f48-be46-325f6b4b32b6'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','69a06fd0-9eb3-3979-a0f4-327304685d34'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','241b0dba-2690-30a3-bbbd-32c5dd8ea2d0'),
	('9e527ebb-d739-4cbd-92db-1e92c1786705','a83522a4-13c5-3ed8-94d3-36967a037472'),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','a8ba3928-b87d-3be5-b5e2-387559b654e1'),
	('4de82623-997f-4cf4-8042-d752b3cc68a4','98273256-ee10-3cb6-8917-39c8f2c2704e'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','3295a7a8-4998-37d9-8ed6-433fca05c1ce'),
	('e3dec337-6afe-4959-a181-b85b4006f956','59856dee-f83b-3989-88bd-4342847e203d'),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','76213b92-e75e-3fc1-a328-4382c731474e'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','8eced8ed-9912-34f2-8701-43b2e6387d61'),
	('fb4ba980-81fb-40df-9d70-2558e561ad3b','49007aed-76df-36f9-881b-44a2d86a39a2'),
	('e3dec337-6afe-4959-a181-b85b4006f956','7275815c-de7c-381b-8607-44abcd568d87'),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','94ff6764-3940-31dc-bbde-46b5ff6a9297'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','e1755b42-5e7a-3ba1-8f5e-472f00f5570e'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','9baac995-e771-3cad-890a-4a2361a5bc5f'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','62a03bf8-6f8b-3274-a7f7-4b82973a1beb'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','e0aef48d-58c1-3b55-bde9-4d65656e6d0b'),
	('e3dec337-6afe-4959-a181-b85b4006f956','08e082f9-b8af-3f32-bf92-4f657b2d976e'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','83299f9e-5a29-332f-a8bf-534da87dd146'),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','ef721d95-f7cf-3bdb-a62d-5398e300e11d'),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','e5cbc9b5-1cd7-340a-9d7b-54dd7e10e393'),
	('fb4ba980-81fb-40df-9d70-2558e561ad3b','96c4ed3c-3005-3e59-a1b3-56a70599e94e'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','91bb7623-a72c-373c-b0a7-58b7779a7595'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','f74b61d8-abe3-3a37-a0d4-59555c545a2c'),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','7b6570ff-f8ef-3e64-a25e-59dd3797238a'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','ab8f7d29-5a48-3bf7-a806-5a315d54b5f5'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','3df3fe7b-bd39-3310-b184-5c434a69af47'),
	('db795d05-bf69-4924-a2cc-564a7b455bf1','f8068cc1-8cda-3794-a951-5efe707fb134'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','bd73df8f-4480-3f33-8f36-63c76e939e86'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','9b1eaece-0dcf-3d01-8d4d-63f954796f8e'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','26e719b7-bfc8-3d05-83d5-6534fab2abcb'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','89a8611e-603f-36d0-91c4-668764f31343'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','e9c477af-9cf2-37c6-9eef-66a6500cefbf'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','497fd52e-39d7-37da-9cb8-67399483b06d'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','327c8e32-4ea5-330e-a94f-68b0c0d1cbc6'),
	('c789d4e6-dbdf-4d80-9d54-62e2c010effa','b23c2089-20cc-3d79-a855-68fce31f1d91'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','dd6c0ad8-142c-3233-9f9d-6906c15614b2'),
	('fb4ba980-81fb-40df-9d70-2558e561ad3b','810e90d3-00b9-3cf3-aa02-693795c1c9d7'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','280dc5be-6283-36cf-bb98-6b023bc08136'),
	('4de82623-997f-4cf4-8042-d752b3cc68a4','509740e8-b117-3fd7-a481-6b0aaf31bb52'),
	('c789d4e6-dbdf-4d80-9d54-62e2c010effa','49007aed-76df-36f9-881b-44a2d86a39a2'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','7275815c-de7c-381b-8607-44abcd568d87'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','94ff6764-3940-31dc-bbde-46b5ff6a9297'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','e1755b42-5e7a-3ba1-8f5e-472f00f5570e'),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','9baac995-e771-3cad-890a-4a2361a5bc5f'),
	('db795d05-bf69-4924-a2cc-564a7b455bf1','62a03bf8-6f8b-3274-a7f7-4b82973a1beb'),
	('4de82623-997f-4cf4-8042-d752b3cc68a4','e0aef48d-58c1-3b55-bde9-4d65656e6d0b'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','08e082f9-b8af-3f32-bf92-4f657b2d976e'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','83299f9e-5a29-332f-a8bf-534da87dd146'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','ef721d95-f7cf-3bdb-a62d-5398e300e11d'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','e5cbc9b5-1cd7-340a-9d7b-54dd7e10e393');

-- INSERT MENULIS_SKENARIO_TAYANGAN --
INSERT INTO MENULIS_SKENARIO_TAYANGAN VALUES ('9e527ebb-d739-4cbd-92db-1e92c1786705','8fa38df9-4c2b-3bef-a2a6-01097e2c4e05'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','49d37f66-038b-329d-92b6-024637cec90d'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','948b330b-0751-3502-a418-02650ebd35f2'),
	('9e527ebb-d739-4cbd-92db-1e92c1786705','ef86988d-b59f-3a65-a4bf-02b0bc102a78'),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','82d98460-7aff-3ec5-8e41-04226681185f'),
	('4de82623-997f-4cf4-8042-d752b3cc68a4','00ffb3f0-e611-38a4-8351-0796f1fb21d6'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','3860b4a2-921f-36be-80c7-07b6f55b122f'),
	('e3dec337-6afe-4959-a181-b85b4006f956','7f621528-d17c-33e1-80f3-0abf8fb059bc'),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','b7bd9127-c61d-3934-a05b-0b4afe30cd98'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','e176f588-8f8b-33e7-abc3-0d12b0661cdf'),
	('fb4ba980-81fb-40df-9d70-2558e561ad3b','46039e48-bd98-3b2f-b9a7-10a809adf865'),
	('e3dec337-6afe-4959-a181-b85b4006f956','68a61560-cf4b-3f14-bbbe-130226b34a5d'),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','d6a40a31-ab02-35c8-a72d-141787f10ca2'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','da8ab35d-6b80-33bc-916c-15f1263029f8'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','b7bd9127-c61d-3934-a05b-0b4afe30cd98'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','1ece913d-e5a0-3a1f-8e35-175a134b07c7'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','136eccc7-ca0c-3ffe-bddf-17e21ef2220a'),
	('e3dec337-6afe-4959-a181-b85b4006f956','22e12277-1d38-3fa4-b7e1-197739b64c98'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','b7f6bc99-1340-3991-befb-1e67286b5076'),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','ed19732a-d6f8-389c-b93f-1e73fa800ba9'),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','4e75be4a-0a20-34f9-a6ee-24fb7cfc8aaf'),
	('fb4ba980-81fb-40df-9d70-2558e561ad3b','ada162e8-5cee-3abe-976d-2557ca166d72'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','37ee720a-f1b2-386d-bb07-2758e9d2933f'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','d9cf225b-88e7-3f7b-a940-27600d1d9f6f'),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','056ee446-926b-3431-a297-29a48b03c7cc'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','c19cc3e7-fde2-3a9c-b491-2d083d25dba4'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','39064dad-a29c-3ae5-bfb1-2d117233fdf7'),
	('db795d05-bf69-4924-a2cc-564a7b455bf1','22b6a38d-d1bf-3e3d-8391-2d49937031f2'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','38f4a1d8-ee37-39a6-af7e-2f02004d3433'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','a780956e-2905-3a7b-8874-31e16d76fd4a'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','ba24fc81-a9b4-3998-8b1f-169832f4e943'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','8fa38df9-4c2b-3bef-a2a6-01097e2c4e05'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','00ffb3f0-e611-38a4-8351-0796f1fb21d6'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','7f621528-d17c-33e1-80f3-0abf8fb059bc'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','da8ab35d-6b80-33bc-916c-15f1263029f8'),
	('c789d4e6-dbdf-4d80-9d54-62e2c010effa','056ee446-926b-3431-a297-29a48b03c7cc'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','00ffb3f0-e611-38a4-8351-0796f1fb21d6'),
	('fb4ba980-81fb-40df-9d70-2558e561ad3b','8fa38df9-4c2b-3bef-a2a6-01097e2c4e05'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','da8ab35d-6b80-33bc-916c-15f1263029f8'),
	('4de82623-997f-4cf4-8042-d752b3cc68a4','4e75be4a-0a20-34f9-a6ee-24fb7cfc8aaf'),
	('c789d4e6-dbdf-4d80-9d54-62e2c010effa','d6a40a31-ab02-35c8-a72d-141787f10ca2'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','ba24fc81-a9b4-3998-8b1f-169832f4e943'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','7f621528-d17c-33e1-80f3-0abf8fb059bc'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','056ee446-926b-3431-a297-29a48b03c7cc'),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','00ffb3f0-e611-38a4-8351-0796f1fb21d6'),
	('db795d05-bf69-4924-a2cc-564a7b455bf1','ba24fc81-a9b4-3998-8b1f-169832f4e943'),
	('4de82623-997f-4cf4-8042-d752b3cc68a4','ba24fc81-a9b4-3998-8b1f-169832f4e943'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','d6a40a31-ab02-35c8-a72d-141787f10ca2'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','1ece913d-e5a0-3a1f-8e35-175a134b07c7'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','b7bd9127-c61d-3934-a05b-0b4afe30cd98'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','00ffb3f0-e611-38a4-8351-0796f1fb21d6');

-- INSERT GENRE_TAYANGAN --
INSERT INTO GENRE_TAYANGAN VALUES ('9e527ebb-d739-4cbd-92db-1e92c1786705','Science Fiction'),
	('e3dec337-6afe-4959-a181-b85b4006f956','Comedy'),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','Biographical'),
	('e525d4be-cd8c-4ddd-88c9-46a7cf625ed0','Action'),
	('4de82623-997f-4cf4-8042-d752b3cc68a4','Comedy'),
	('c789d4e6-dbdf-4d80-9d54-62e2c010effa','Fantasy'),
	('ea6edb7a-a28a-42a3-97b1-4ed5ebea8e39','Drama'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','Comedy'),
	('fb4ba980-81fb-40df-9d70-2558e561ad3b','Drama'),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','Drama'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','Drama'),
	('db795d05-bf69-4924-a2cc-564a7b455bf1','Drama');

-- INSERT PERUSAHAAN PRODUKSI --
INSERT INTO PERUSAHAAN_PRODUKSI VALUES ('Toho'),
	('Mattel Films'),
	('Atlas Entertainment'),
	('Filmmaker R&K'),
	('Imajinari'),
	('Universal Studios'),
	('Misión de Audaces Films'),
	('Miles Films'),
	('JW Films'),
	('Archimede'),
	('Sony Pictures'),
	('Alceon Entertainment Partners'),
	('Bugsy Bell Productions'),
	('SH Film'),
	('Hwa&Dam Pictures');

-- INSERT PERSETUJUAN --
INSERT INTO PERSETUJUAN VALUES ('Toho','9e527ebb-d739-4cbd-92db-1e92c1786705','2024-01-02 00:00:00',30.0,5000.0,'2024-01-04 00:00:00'),
	('Mattel Films','9e527ebb-d739-4cbd-92db-1e92c1786705','2023-12-29 00:00:00',40.0,10000.0,'2024-01-04 00:00:00'),
	('Atlas Entertainment','e3dec337-6afe-4959-a181-b85b4006f956','2023-08-08 00:00:00',50.0,15000.0,'2023-08-15 00:00:00'),
	('Filmmaker R&K','e3dec337-6afe-4959-a181-b85b4006f956','2023-08-12 00:00:00',60.0,20000.0,'2023-08-15 00:00:00'),
	('Imajinari','e0f1fc0c-02a7-494d-96ba-e9519326202a','2023-07-20 00:00:00',70.0,25000.0,'2023-07-24 00:00:00'),
	('Universal Studios','e0f1fc0c-02a7-494d-96ba-e9519326202a','2023-07-17 00:00:00',35.0,30000.0,'2023-07-24 00:00:00'),
	('Misión de Audaces Films','e525d4be-cd8c-4ddd-88c9-46a7cf625ed0','2023-09-22 00:00:00',45.0,35000.0,'2023-09-27 00:00:00'),
	('Miles Films','e525d4be-cd8c-4ddd-88c9-46a7cf625ed0','2023-09-25 00:00:00',55.0,40000.0,'2023-09-27 00:00:00'),
	('JW Films','4de82623-997f-4cf4-8042-d752b3cc68a4','2024-01-29 00:00:00',65.0,45000.0,'2024-02-03 00:00:00'),
	('Archimede','4de82623-997f-4cf4-8042-d752b3cc68a4','2024-01-31 00:00:00',75.0,50000.0,'2024-02-03 00:00:00'),
	('Sony Pictures','c789d4e6-dbdf-4d80-9d54-62e2c010effa','2023-07-10 00:00:00',33.0,5000.0,'2023-07-16 00:00:00'),
	('Alceon Entertainment Partners','ea6edb7a-a28a-42a3-97b1-4ed5ebea8e39','2024-01-01 00:00:00',43.0,10000.0,'2024-01-04 00:00:00'),
	('Bugsy Bell Productions','5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','2023-09-22 00:00:00',53.0,15000.0,'2023-09-29 00:00:00'),
	('SH Film','fb4ba980-81fb-40df-9d70-2558e561ad3b','2023-12-13 00:00:00',63.0,20000.0,'2023-12-15 00:00:00'),
	('Hwa&Dam Pictures','8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','2023-09-03 00:00:00',73.0,25000.0,'2023-09-06 00:00:00'),
	('Toho','1fdc19f5-89e5-496c-b6e6-162fae666d96','2023-01-15 00:00:00',37.0,30000.0,'2023-01-22 00:00:00'),
	('Mattel Films','db795d05-bf69-4924-a2cc-564a7b455bf1','2023-04-01 00:00:00',47.0,35000.0,'2023-04-06 00:00:00'),
	('Atlas Entertainment','38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','2023-01-21 00:00:00',57.0,40000.0,'2023-01-26 00:00:00'),
	('Filmmaker R&K','dc8f3fc2-bc19-4bb0-875f-692875c57632','2023-10-22 00:00:00',67.0,45000.0,'2023-10-26 00:00:00'),
	('Imajinari','ad291c00-061f-40ba-920c-8d59b9420d33','2022-12-24 00:00:00',77.0,50000.0,'2022-12-30 00:00:00');

-- INSERT SERIES --
INSERT INTO SERIES VALUES ('1fdc19f5-89e5-496c-b6e6-162fae666d96'),
	('db795d05-bf69-4924-a2cc-564a7b455bf1'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632'),
	('ad291c00-061f-40ba-920c-8d59b9420d33');

-- INSERT FILM --
INSERT INTO FILM VALUES ('9e527ebb-d739-4cbd-92db-1e92c1786705','https://www.youtube.com/','2023-11-03 00:00:00',7500.0),
	('e3dec337-6afe-4959-a181-b85b4006f956','https://www.youtube.com/','2023-07-21 00:00:00',6840.0),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','https://www.youtube.com/','2023-07-21 00:00:00',10800.0),
	('e525d4be-cd8c-4ddd-88c9-46a7cf625ed0','https://www.youtube.com/','2023-07-26 00:00:00',7740.0),
	('4de82623-997f-4cf4-8042-d752b3cc68a4','https://www.youtube.com/','2024-02-01 00:00:00',7140.0),
	('c789d4e6-dbdf-4d80-9d54-62e2c010effa','https://www.youtube.com/','2023-07-14 00:00:00',7440.0),
	('ea6edb7a-a28a-42a3-97b1-4ed5ebea8e39','https://www.youtube.com/','2024-01-04 00:00:00',8640.0),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','https://www.youtube.com/','2023-09-28 00:00:00',7560.0),
	('fb4ba980-81fb-40df-9d70-2558e561ad3b','https://www.youtube.com/','2023-12-15 00:00:00',6300.0),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','https://www.youtube.com/','2023-09-06 00:00:00',7260.0);

-- INSERT EPISODE --
INSERT INTO EPISODE VALUES ('1fdc19f5-89e5-496c-b6e6-162fae666d96','When You''re Lost in the Darkness','Dua puluh tahun setelah wabah jamur melanda planet ini, Joel dan Tess yang selamat ditugaskan dengan misi yang dapat mengubah segalanya.',4860.0,'https://www.youtube.com/','2023-01-15 00:00:00'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','Infected','Setelah melarikan diri dari QZ, Joel dan Tess berselisih mengenai nasib Ellie saat menjelajahi reruntuhan Boston yang telah lama ditinggalkan.',3180.0,'https://www.youtube.com/','2023-01-22 00:00:00'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','Long, Long Time','Saat orang tak dikenal mendekati kompleks rumahnya, Bill yang bertahan hidup menjalin hubungan tak terduga. Belakangan, Joel dan Ellie meminta bimbingan Bill.',4560.0,'https://www.youtube.com/','2023-01-29 00:00:00'),
	('db795d05-bf69-4924-a2cc-564a7b455bf1','The Birds Don''t Sing, They Screech in Pain','Pertemuan dengan pengendara motor yang bermusuhan membuat Danny murka -- dan terjadi kejar-kejaran di kota. Tamu tak terduga Amy meninggalkan kesan mendalam.',2340.0,'https://www.youtube.com/','2023-04-06 00:00:00'),
	('db795d05-bf69-4924-a2cc-564a7b455bf1','The Rapture of Being Alive','Amy yang marah menemukan tujuan baru saat keretakan dalam pernikahannya yang tampak sempurna mulai terlihat. Danny mencari awal baru untuk bisnis keluarganya yang gagal.',1980.0,'https://www.youtube.com/','2023-04-06 00:00:00'),
	('db795d05-bf69-4924-a2cc-564a7b455bf1','I Am Inhabited by a Cry','Danny mengalami katarsis di hadapan api lama. Hubungan Amy dengan George kembali mengalami kemunduran. Skema penangkapan ikan kucing sudah keterlaluan.',2100.0,'https://www.youtube.com/','2023-04-06 00:00:00'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','Dead Man''s Hand','Ketika seorang teman dekatnya menemui ajalnya sebelum waktunya, Charlie Cale, seorang pelayan kasino dengan bakat luar biasa dalam mengidentifikasi kebohongan, bertekad untuk mengungkap peristiwa misterius ini, meskipun itu membahayakan nyawanya sendiri.',4080.0,'https://www.youtube.com/','2023-01-26 00:00:00'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','The Night Shift','Terluka dan dalam pelarian, Charlie terpaksa singgah di New Mexico yang terpencil di mana dia mencoba membersihkan nama pengemudi truk yang dijebak atas pembunuhan seorang penduduk setempat.',3780.0,'https://www.youtube.com/','2023-01-26 00:00:00'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','Episode 1','Robot Swiss tercinta ditemukan hancur berkeping-keping. Sementara itu, inspektur robot Europol Gesicht menyelidiki pembunuhan terkait lainnya.',4260.0,'https://www.youtube.com/','2023-10-26 00:00:00'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','Episode 2','Mayat bertanduk lainnya ditemukan. Gesicht menghubungi Atom, robot tercanggih dari tujuh robot, untuk membantu menganalisis pembunuhan berantai.',3480.0,'https://www.youtube.com/','2023-10-26 00:00:00'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','Episode 1','Disiksa oleh teman-teman sekolah menengahnya dan tidak punya tempat untuk meminta bantuan, Moon Dong-eun tenggelam dalam keputusasaan sebelum memutuskan misi baru dalam hidup.',2820.0,'https://www.youtube.com/','2022-12-30 00:00:00'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','Episode 2','Menjelang pernikahan Park Yeon-jin, balas dendam Dong-eun berjalan sesuai rencana. Sementara itu, pertemuan penting di rumah sakit terjadi.',3060.0,'https://www.youtube.com/','2022-12-30 00:00:00');

-- INSERT ULASAN --
INSERT INTO ULASAN VALUES ('9e527ebb-d739-4cbd-92db-1e92c1786705','dewi3456','2024-02-18 14:32:47',8.0,'Film yang menarik dengan alur cerita yang bagus'),
	('e3dec337-6afe-4959-a181-b85b4006f956','citra9012','2024-04-01 09:20:18',5.0,'Sangat menyenangkan untuk ditonton'),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','dewi3456','2024-02-23 12:35:44',7.0,'Visual efek yang luar biasa'),
	('e525d4be-cd8c-4ddd-88c9-46a7cf625ed0','andi1234','2024-03-05 14:50:32',9.0,'Karakter yang kompleks dengan akting yang bagus'),
	('4de82623-997f-4cf4-8042-d752b3cc68a4','eko7890','2024-03-10 16:15:28',6.0,'Sedikit membosankan tetapi lumayan menghibur'),
	('c789d4e6-dbdf-4d80-9d54-62e2c010effa','andi1234','2024-02-21 18:30:50',4.0,'Tidak terlalu menarik dan membosankan'),
	('ea6edb7a-a28a-42a3-97b1-4ed5ebea8e39','gita5678','2024-03-15 20:45:33',8.0,'Suka dengan karakter utama'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','fani1234','2024-04-02 22:10:41',9.0,'Salah satu film terbaik yang pernah saya tonton'),
	('fb4ba980-81fb-40df-9d70-2558e561ad3b','citra9012','2024-01-22 09:25:52',3.0,'Kecewa dengan akting para pemain'),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','budi5678','2024-04-09 11:40:22',7.0,'Menarik namun alur cerita berlika-liku'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','eko7890','2024-02-20 13:55:38',6.0,'Cerita yang cukup menarik dan aktor sangat mendalami karakter'),
	('9e527ebb-d739-4cbd-92db-1e92c1786705','hendra9012','2024-03-17 16:20:47',9.0,'Suka dengan endingnya yang tidak terduga'),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','andi1234','2024-03-21 18:35:59',5.0,'Biasa saja, tidak ada yang istimewa dari film ini'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','gita5678','2024-01-25 20:50:14',8.0,'Suka dengan alur cerita yang tidak biasa'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','hendra9012','2024-03-29 09:05:48',7.0,'Menarik tetapi suasana yang dibangun dalam cerita masih kurang'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','eko7890','2024-03-20 20:20:01',5.0,'Harusnya pemeran utama bisa lebih mendalami karakter');

-- INSERT DAFTAR FAVORIT --
INSERT INTO DAFTAR_FAVORIT VALUES ('2024-02-25 08:32:15','andi1234','Tontonan libur'),
	('2024-04-05 10:45:27','budi5678','Favorit saya'),
	('2024-02-20 12:20:38','budi5678','Hiburan rutin'),
	('2024-03-10 14:55:49','citra9012','Rekomendasi '),
	('2024-03-05 16:30:22','dewi3456','Santai malam'),
	('2024-03-15 18:45:33','dewi3456','Favorit dewi'),
	('2024-01-22 20:20:44','dewi3456','Hiburan libur'),
	('2024-04-18 22:35:16','dewi3456','Film seru '),
	('2024-01-28 09:15:28','eko7890','Tontonan saya'),
	('2024-02-17 11:40:29','eko7890','Rekomendasi terbaru'),
	('2024-03-01 13:55:38','eko7890','Favorit saya'),
	('2024-02-05 15:20:41','fani1234','Film favorit '),
	('2024-03-20 17:40:52','fani1234','Rekomendasi favorit'),
	('2024-03-25 20:10:14','gita5678','Hiburan weekend'),
	('2024-04-08 22:45:28','gita5678','Selalu seru'),
	('2024-01-27 09:55:37','gita5678','Film kesukaan ');

-- INSERT TAYANGAN_MEMILIKI_DAFTAR_FAVORIT --
INSERT INTO TAYANGAN_MEMILIKI_DAFTAR_FAVORIT VALUES ('9e527ebb-d739-4cbd-92db-1e92c1786705','2024-02-25 08:32:15','andi1234'),
	('e3dec337-6afe-4959-a181-b85b4006f956','2024-04-05 10:45:27','budi5678'),
	('9e527ebb-d739-4cbd-92db-1e92c1786705','2024-02-20 12:20:38','budi5678'),
	('e525d4be-cd8c-4ddd-88c9-46a7cf625ed0','2024-03-10 14:55:49','citra9012'),
	('ea6edb7a-a28a-42a3-97b1-4ed5ebea8e39','2024-03-05 16:30:22','dewi3456'),
	('4de82623-997f-4cf4-8042-d752b3cc68a4','2024-03-15 18:45:33','dewi3456'),
	('e3dec337-6afe-4959-a181-b85b4006f956','2024-01-22 20:20:44','dewi3456'),
	('fb4ba980-81fb-40df-9d70-2558e561ad3b','2024-04-18 22:35:16','dewi3456'),
	('db795d05-bf69-4924-a2cc-564a7b455bf1','2024-01-28 09:15:28','eko7890'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','2024-02-17 11:40:29','eko7890'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','2024-03-01 13:55:38','eko7890'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','2024-02-05 15:20:41','fani1234'),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','2024-03-20 17:40:52','fani1234'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','2024-03-25 20:10:14','gita5678'),
	('db795d05-bf69-4924-a2cc-564a7b455bf1','2024-04-08 22:45:28','gita5678'),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','2024-01-27 09:55:37','gita5678');

-- INSERT RIWAYAT NONTON --
INSERT INTO RIWAYAT_NONTON VALUES ('9e527ebb-d739-4cbd-92db-1e92c1786705','andi1234','2024-01-04 00:00:00','2024-01-06 00:00:00'),
	('9e527ebb-d739-4cbd-92db-1e92c1786705','budi5678','2024-01-07 00:00:00','2024-01-08 00:00:00'),
	('e3dec337-6afe-4959-a181-b85b4006f956','citra9012','2023-08-22 00:00:00','2023-08-22 00:00:00'),
	('e3dec337-6afe-4959-a181-b85b4006f956','dewi3456','2023-08-19 00:00:00','2023-08-21 00:00:00'),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','eko7890','2023-08-01 00:00:00','2023-08-03 00:00:00'),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','fani1234','2023-07-28 00:00:00','2023-07-31 00:00:00'),
	('e525d4be-cd8c-4ddd-88c9-46a7cf625ed0','gita5678','2023-10-05 00:00:00','2023-10-05 00:00:00'),
	('e525d4be-cd8c-4ddd-88c9-46a7cf625ed0','hendra9012','2023-10-03 00:00:00','2023-10-04 00:00:00'),
	('4de82623-997f-4cf4-8042-d752b3cc68a4','andi1234','2024-02-05 00:00:00','2024-02-05 00:00:00'),
	('4de82623-997f-4cf4-8042-d752b3cc68a4','budi5678','2024-02-10 00:00:00','2024-02-10 00:00:00'),
	('c789d4e6-dbdf-4d80-9d54-62e2c010effa','citra9012','2023-07-18 00:00:00','2023-07-19 00:00:00'),
	('c789d4e6-dbdf-4d80-9d54-62e2c010effa','dewi3456','2023-08-20 00:00:00','2023-08-22 00:00:00'),
	('ea6edb7a-a28a-42a3-97b1-4ed5ebea8e39','eko7890','2024-01-07 00:00:00','2024-01-08 00:00:00'),
	('ea6edb7a-a28a-42a3-97b1-4ed5ebea8e39','fani1234','2024-01-08 00:00:00','2024-01-09 00:00:00'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','gita5678','2023-10-20 00:00:00','2023-10-23 00:00:00'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','hendra9012','2023-10-07 00:00:00','2023-10-11 00:00:00'),
	('fb4ba980-81fb-40df-9d70-2558e561ad3b','andi1234','2023-12-25 00:00:00','2023-12-25 00:00:00'),
	('fb4ba980-81fb-40df-9d70-2558e561ad3b','budi5678','2023-12-30 00:00:00','2023-12-31 00:00:00'),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','citra9012','2023-11-23 00:00:00','2023-11-27 00:00:00'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','dewi3456','2023-01-23 00:00:00','2023-02-01 00:00:00'),
	('db795d05-bf69-4924-a2cc-564a7b455bf1','eko7890','2023-04-08 00:00:00','2023-04-15 00:00:00'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','fani1234','2023-01-26 00:00:00','2023-02-05 00:00:00'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','gita5678','2023-10-27 00:00:00','2023-11-11 00:00:00'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','hendra9012','2022-12-31 00:00:00','2023-01-20 00:00:00');

-- INSERT TAYANGAN TERUNDUH --
INSERT INTO TAYANGAN_TERUNDUH VALUES ('9e527ebb-d739-4cbd-92db-1e92c1786705','andi1234','2024-04-22 09:21:36'),
	('9e527ebb-d739-4cbd-92db-1e92c1786705','budi5678','2024-04-24 15:47:12'),
	('e3dec337-6afe-4959-a181-b85b4006f956','citra9012','2024-04-19 17:58:29'),
	('e3dec337-6afe-4959-a181-b85b4006f956','dewi3456','2024-04-20 11:36:51'),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','eko7890','2024-04-21 08:14:05'),
	('e0f1fc0c-02a7-494d-96ba-e9519326202a','fani1234','2024-04-23 19:25:43'),
	('e525d4be-cd8c-4ddd-88c9-46a7cf625ed0','gita5678','2024-04-25 14:39:20'),
	('e525d4be-cd8c-4ddd-88c9-46a7cf625ed0','hendra9012','2024-04-20 07:50:11'),
	('e525d4be-cd8c-4ddd-88c9-46a7cf625ed0','andi1234','2024-04-23 18:55:02'),
	('4de82623-997f-4cf4-8042-d752b3cc68a4','budi5678','2024-04-21 13:05:47'),
	('c789d4e6-dbdf-4d80-9d54-62e2c010effa','citra9012','2024-04-20 10:20:18'),
	('ea6edb7a-a28a-42a3-97b1-4ed5ebea8e39','dewi3456','2024-04-24 21:38:59'),
	('ea6edb7a-a28a-42a3-97b1-4ed5ebea8e39','eko7890','2024-04-22 16:12:47'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','fani1234','2024-04-25 09:33:55'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','gita5678','2024-04-19 12:44:34'),
	('5b6ad3ce-8d1c-4f6d-8002-5a4aedf41859','hendra9012','2024-04-25 17:57:28'),
	('fb4ba980-81fb-40df-9d70-2558e561ad3b','andi1234','2024-04-22 06:58:21'),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','budi5678','2024-04-23 14:32:59'),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','citra9012','2024-04-19 10:55:08'),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','dewi3456','2024-04-19 17:10:19'),
	('8f4aba1f-aa11-4bb8-a4ff-abe37fe7d6af','eko7890','2024-04-24 21:30:20'),
	('1fdc19f5-89e5-496c-b6e6-162fae666d96','fani1234','2024-04-22 08:22:12'),
	('db795d05-bf69-4924-a2cc-564a7b455bf1','gita5678','2024-04-25 19:45:27'),
	('db795d05-bf69-4924-a2cc-564a7b455bf1','hendra9012','2024-04-21 20:20:38'),
	('38bfb8e6-e452-4edf-ac93-cfaee6c63c7c','andi1234','2024-04-18 17:55:49'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','budi5678','2024-04-19 11:20:22'),
	('dc8f3fc2-bc19-4bb0-875f-692875c57632','citra9012','2024-04-21 14:45:33'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','dewi3456','2024-04-25 16:20:44'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','eko7890','2024-04-23 09:35:16'),
	('ad291c00-061f-40ba-920c-8d59b9420d33','fani1234','2024-04-20 08:15:28');

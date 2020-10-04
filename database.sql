DROP TABLE IF EXISTS redeemcodes;
CREATE TABLE IF NOT EXISTS redeemcodes (
  code text(65535) COLLATE utf8mb4_bin DEFAULT NULL,
  type text(65535) COLLATE utf8mb4_bin DEFAULT NULL,
  amount text(65535) COLLATE utf8mb4_bin DEFAULT NULL,
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

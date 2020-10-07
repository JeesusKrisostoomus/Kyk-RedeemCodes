DROP TABLE IF EXISTS `redeemcodes`;
CREATE TABLE `redeemcodes` (
  `code` text DEFAULT NULL,
  `type` text DEFAULT NULL,
  `amount` text DEFAULT NULL,
  `item` text DEFAULT NULL,
  `count` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
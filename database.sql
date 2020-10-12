DROP TABLE IF EXISTS `redeemcodes`;
CREATE TABLE `redeemcodes` (
  `code` text DEFAULT NULL,
  `type` text DEFAULT NULL,
  `data1` text DEFAULT NULL, -- amount >> Data1
  `data2` text DEFAULT NULL -- Item >> Data2 
  -- Count >> REMOVED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
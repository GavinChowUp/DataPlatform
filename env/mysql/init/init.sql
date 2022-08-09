grant all privileges on dbname.tablename to 'platform'@'%';
grant all privileges on data_platform.* to 'platform'@'%';
# 刷新权限
flush privileges;

use data_platform;
CREATE TABLE IF NOT EXISTS `tbl`
(
    `id`       INT UNSIGNED AUTO_INCREMENT,
    `title`    VARCHAR(100) NOT NULL,
    `author`   VARCHAR(40)  NOT NULL,
    `submission_date` DATE,
    PRIMARY KEY (`id`)
);

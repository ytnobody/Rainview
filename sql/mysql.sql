DROP TABLE IF EXISTS route;
CREATE TABLE route (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(140) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at TIMESTAMP,
    index(name)
) ENGINE=InnoDB, DEFAULT CHAR SET=utf8; 

DROP TABLE IF EXISTS point;
CREATE TABLE point (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(140) NOT NULL,
    route_id BIGINT UNSIGNED NOT NULL,
    hourly_precip INT UNSIGNED,
    long_precip INT UNSIGNED,
    report_time DATETIME NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at TIMESTAMP,
    index(name),
    index(route_id)
) ENGINE=InnoDB, DEFAULT CHAR SET=utf8;


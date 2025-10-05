-- 사용자 정보 테이블
CREATE TABLE `USER` (
                        `user_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '사용자 고유 ID',
                        `email` VARCHAR(255) NOT NULL COMMENT '이메일 (로그인 ID)',
                        `password` VARCHAR(255) NOT NULL COMMENT '비밀번호 (암호화 저장)',
                        `nickname` VARCHAR(50) NOT NULL COMMENT '닉네임',
                        `created_at` DATETIME NOT NULL COMMENT '등록일',
                        `updated_at` DATETIME NOT NULL COMMENT '수정일',
                        PRIMARY KEY (`user_id`),
                        UNIQUE KEY `UK_user_email` (`email`),
                        UNIQUE KEY `UK_user_nickname` (`nickname`)
) COMMENT '사용자 정보';

-- 차량 정보 테이블
CREATE TABLE `VEHICLE` (
                           `vehicle_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '차량 고유 ID',
                           `user_id` BIGINT NOT NULL COMMENT '사용자 ID',
                           `license_plate` VARCHAR(50) NOT NULL COMMENT '차량 번호판 번호',
                           `make` VARCHAR(50) NOT NULL COMMENT '제조사',
                           `model` VARCHAR(50) NOT NULL COMMENT '모델명',
                           `year` INT COMMENT '연식',
                           `nickname` VARCHAR(50) COMMENT '차량 별칭',
                           `initial_odometer` INT COMMENT '최초 등록 시 주행거리(km)',
                           `created_at` DATETIME NOT NULL COMMENT '등록일',
                           `updated_at` DATETIME NOT NULL COMMENT '수정일',
                           PRIMARY KEY (`vehicle_id`),
                           UNIQUE KEY `UK_vehicle_license_plate` (`license_plate`),
                           FOREIGN KEY (`user_id`) REFERENCES `USER` (`user_id`) ON DELETE CASCADE
) COMMENT '차량 정보';

-- 주유 기록 테이블
CREATE TABLE `FUEL_RECORD` (
                               `record_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '기록 고유 ID',
                               `vehicle_id` BIGINT NOT NULL COMMENT '차량 ID',
                               `fuel_date` DATE NOT NULL COMMENT '주유 날짜',
                               `odometer` INT NOT NULL COMMENT '주유 시점 주행거리(km)',
                               `price_per_liter` INT COMMENT '리터당 단가',
                               `liters` DECIMAL(5,2) COMMENT '주유량 (리터)',
                               `total_price` INT NOT NULL COMMENT '총 주유 금액',
                               `memo` VARCHAR(255) COMMENT '메모',
                               `created_at` DATETIME NOT NULL COMMENT '등록일',
                               `updated_at` DATETIME NOT NULL COMMENT '수정일',
                               PRIMARY KEY (`record_id`),
                               FOREIGN KEY (`vehicle_id`) REFERENCES `VEHICLE` (`vehicle_id`) ON DELETE CASCADE
) COMMENT '주유 기록';

-- 정비 기록 테이블
CREATE TABLE `MAINTENANCE_RECORD` (
                                      `record_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '기록 고유 ID',
                                      `vehicle_id` BIGINT NOT NULL COMMENT '차량 ID',
                                      `maintenance_date` DATE NOT NULL COMMENT '정비 날짜',
                                      `odometer` INT COMMENT '정비 시점 주행거리(km)',
                                      `item` VARCHAR(100) NOT NULL COMMENT '정비 항목',
                                      `total_cost` INT NOT NULL COMMENT '총 정비 비용',
                                      `memo` VARCHAR(255) COMMENT '메모',
                                      `created_at` DATETIME NOT NULL COMMENT '등록일',
                                      `updated_at` DATETIME NOT NULL COMMENT '수정일',
                                      PRIMARY KEY (`record_id`),
                                      FOREIGN KEY (`vehicle_id`) REFERENCES `VEHICLE` (`vehicle_id`) ON DELETE CASCADE
) COMMENT '정비 기록';

CREATE TABLE IF NOT EXISTS course_service (
    id INT PRIMARY KEY,
    service_name VARCHAR(32) NOT NULL,
    status VARCHAR(16) NOT NULL
);
INSERT INTO course_service (id, service_name, status)
VALUES (1, 'MySQL', 'verified'), (2, 'Redis', 'demo')
ON DUPLICATE KEY UPDATE service_name = VALUES(service_name), status = VALUES(status);
SELECT id, service_name, status FROM course_service ORDER BY id;

CREATE USER 'crimson'@'localhost' IDENTIFIED BY 'crimson';

GRANT ALL PRIVILEGES ON crimson.* TO 'crimson'@'localhost';

FLUSH PRIVILEGES;

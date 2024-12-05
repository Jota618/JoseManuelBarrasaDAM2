sudo mysql -u root

CREATE DATABASE accesoadatos;

CREATE USER 'accesoadatos'@'localhost' IDENTIFIED BY 'accesoadatos';

GRANT ALL PRIVILEGES ON accesoadatos.* TO 'accesoadatos'@'localhost';

FLUSH PRIVILEGES;

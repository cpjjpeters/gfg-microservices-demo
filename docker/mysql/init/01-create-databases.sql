-- Create databases for both services
CREATE DATABASE IF NOT EXISTS gfgmicroservicesdemo;
CREATE DATABASE IF NOT EXISTS employeedb;

-- Grant privileges (already root user, but being explicit)
GRANT ALL PRIVILEGES ON gfgmicroservicesdemo.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON employeedb.* TO 'root'@'%';

FLUSH PRIVILEGES;

-- Use the address service database
USE gfgmicroservicesdemo;

-- Use the employee service database  
USE employeedb;
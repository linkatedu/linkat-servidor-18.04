CREATE USER 'jclic_user'@'localhost' IDENTIFIED BY 'jclic_pwd';

GRANT ALL PRIVILEGES ON JClicReports.*
TO 'jclic_user'@'localhost'
WITH GRANT OPTION;


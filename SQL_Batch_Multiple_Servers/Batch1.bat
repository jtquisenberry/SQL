Pushd \\MyPath\Directory\...  (UNC network Path to your SQL file)
SQLCMD -b -E -SMyServer1 -i.\JQDeploy.sql
SQLCMD -b -E -SMyServer2\MyInstance2 -i.\JQDeploy.sql
Popd
PAUSE

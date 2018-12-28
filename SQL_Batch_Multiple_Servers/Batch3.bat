set list=Server1
set list=%list%;Server2\Instance2


(for %%a in (%list%) do (
   SQLCMD -b -E -S%%a -i.\ProcessName.sql
 )
)


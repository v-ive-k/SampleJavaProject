https://us05web.zoom.us/j/4903422015?pwd=MOb1R3Zbbw2RqIYVAE0oSU5BacPtyP.1



OLD MACHINE : ST-UTILSRV01
NEW MACHINE : STINB2-UTLO1

yea, it will need to allow incoming ports for IIS as well, I think on previous st-utilsrv01 ports 8060-8090 were opened maybe, something like that?
 
and it will need to be able to access staging file shares, \\stgintfiles01.file.core.windows.net\clientapps and \\stgintfiles01.file.core.windows.net\reportgeneration
 
and able to reach staging SQL: STINB2-SQL01.intertel.local
 

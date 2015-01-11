
  @echo off	
	REM REMOVE SPACE IN FILE NAME IF ANY - FOR FILE NAME START
			:: Check WMIC is available
			WMIC.EXE Alias /? >NUL 2>&1 || GOTO s_error

			:: Use WMIC to retrieve date and time
			FOR /F "skip=1 tokens=1-6" %%G IN ('WMIC Path Win32_LocalTime Get Day^,Hour^,Minute^,Month^,Second^,Year /Format:table') DO (
			IF "%%~L"=="" goto s_done
			Set _yyyy=%%L
			Set _mm=00%%J
			Set _dd=00%%G
			Set _hour=00%%H
			SET _minute=00%%I
			SET _second=00%%K
			)
			:s_done

			:: Pad digits with leading zeros
			Set _mm=%_mm:~-2%
			Set _dd=%_dd:~-2%
			Set _hour=%_hour:~-2%
			Set _minute=%_minute:~-2%
			Set _second=%_second:~-2%

			Set BACKUP_FILE=%_dd%-%_mm%-%_yyyy%_%_hour%_%_minute%_%_second%
    REM REMOVE SPACE IN FILE NAME IF ANY - FOR FILE NAME END			

    REM ACTUAL BACKUP
    "C:\Program Files\PostgreSQL\9.4\bin\pg_dump.exe" -i -h localhost -p 5432 -U postgres -F c -b -v -f F:\PostgresqlBack\%BACKUP_FILE%.backup vijaydb	

	REM DELET FILES OLDER THAN 3 DAYS
	forfiles -p "F:\PostgresqlBack" -s -m *.* /D -3 /C "cmd /c del @path"	
	
    echo on

	
	

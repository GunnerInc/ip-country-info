SECTION .data
szAppName           db  "IP Lookup 1.0.0(Linux)", 0
szGladeFile         db  "ip-country-info.glade", 0
fmtst               db  "%s ", 0
szDelim             db  ";", 0
szFlagDir           db  "./flags/", 0
szFlagExt           db  ".png", 0
szErrNoGTK          db  "Error loading glade file",10, 0

; Object IDs
szIDMainWin         db  "iplkup_main", 0
szIDInvalidIP       db  "iplkup_msg_invalidip", 0

szIDip              db  "ip", 0
szIDcountry         db  "country", 0
szIDregion          db  "region", 0
szIDcity            db  "city", 0
szIDzip_code        db  "zip_code", 0
szIDtime_zone       db  "time_zone", 0
szIDlat             db  "lat", 0
szIDlong            db  "long", 0

szIDFlag            db  "img_flag", 0
szIDInfoSearch      db  "btn_search", 0
szIDInfoClear       db  "btn_clear", 0

InfoLblTable        dd  szIDcountry, szIDregion, szIDcity, szIDzip_code, szIDlat, szIDlong, szIDtime_zone
InfoLblTable_Len    equ ($ - InfoLblTable) / 4

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Error strings
szErrInvalidIP      db  "is not a valid IP address", 0
szErrNoCURL         db  "Uh oh, could not initialize cURL", 0
szErrNoSearchInfo   db  "Nothing to search for!  You forgot to enter an IP!", 0
szErrNoIP           db  "You must enter an IPv4 IP to query.", 0
szErrFile           db  "Could not open settings.ini to load IPInfo API key.", 0
szErrKey            db  "Could not load the IPInfo API Key.", 0
szErrGetKey         db  "If you do not have a key, goto: http://www.ipinfodb.com/register.php and sign up for one.", 0
szErrIPInfoAPI      db  "IPInfo API Error:", 0

szOptionsFile       db  "settings.ini", 0
szGroup_Keys        db  "keys", 0
szIniKey_IPInfo     db  "ipinfodb", 0
szIPInfoDBURL       db  "http://api.ipinfodb.com/v3/ip-city/?key=", 0
szAPIFieldIP        db  "&ip=", 0 
szAPIFieldFmt       db  "&format=raw", 0
IPInfoDBURL_Len     equ $ - szIPInfoDBURL

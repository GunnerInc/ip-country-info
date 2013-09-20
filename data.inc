SECTION .bss
oMain               resd    1 
oBuilder            resd    1
oFlag               resd    1
oSearch             resd    1
oInvalidIP          resd    1
oSearchSpin         resd    1
ThreadID            resd    1

InfoLblArray        resd    InfoLblTable_Len
oIP					resd	1
InfoBtnArray        resd    2

curl_handle         resd    1

in_addr             resd    1

lpszIP              resb    IPLIMIT + 1
lpszIPInfoKey		resb	IPINFOAPILIMIT + 1
lpszIPInfoURL       resb    IPINFOAPILIMIT + IPInfoDBURL_Len + IPLIMIT + 1
lpszFlagPng			resb	12

GKeyFile            resd    1

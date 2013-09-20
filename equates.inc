TRUE            equ     1
FALSE           equ     0
NULL            equ     0


AF_INET equ  2

%define countryCode 3
%define countryName 4
%define regionName 5
%define cityName 6
%define zipCode 7
%define latitude 8
%define longitude 9
%define timeZone 10

%define COUNTRY		0
%define REGION		4
%define CITY		8
%define ZIP			12
%define LAT			16
%define LONG		20
%define TZ			24

%define IPLIMIT		15
%define IPINFOAPILIMIT 128

%define SEARCH		0
%define CLEAR		4

%define CURL_GLOBAL_SSL (1<<0)
%define CURL_GLOBAL_WIN32 (1<<1)
%define CURL_GLOBAL_ALL (CURL_GLOBAL_SSL|CURL_GLOBAL_WIN32)
%define CURL_GLOBAL_NOTHING 0
%define CURL_GLOBAL_DEFAULT CURL_GLOBAL_ALL
%define CURLOPT_URL 10002
%define CURLOPT_WRITEFUNCTION 20011
%define CURLOPT_USERAGENT 10018
%define CURLFORM_COPYNAME 1
%define CURLFORM_COPYCONTENTS 4
%define CURLFORM_END 17
%define CURLOPT_HTTPPOST 10024

%define CURLINFO_STRING   0x100000
%define CURLINFO_LONG     0x200000
%define CURLINFO_DOUBLE   0x300000
%define CURLINFO_SLIST    0x400000
%define CURLINFO_MASK     0x0fffff
%define CURLINFO_TYPEMASK 0xf00000

CURLINFO_RESPONSE_CODE    equ CURLINFO_LONG + 2

%define G_MARKUP_DO_NOT_USE_THIS_UNSUPPORTED_FLAG  (1 << 0)
%define G_MARKUP_TREAT_CDATA_AS_TEXT               (1 << 1)
%define G_MARKUP_PREFIX_ERROR_POSITION             (1 << 2)


;enum GKeyFileFlags
%define G_KEY_FILE_NONE 0
%define G_KEY_FILE_KEEP_COMMENTS (1 << 0)
%define G_KEY_FILE_KEEP_TRANSLATIONS (1 << 1)

GDK_SELECTION_CLIPBOARD equ 69

%define GTK_DIALOG_MODAL  (1 << 0)
%define GTK_DIALOG_DESTROY_WITH_PARENT (1 << 1)

%define GTK_MESSAGE_INFO 0
%define GTK_MESSAGE_WARNING 1
%define GTK_MESSAGE_QUESTION 2
%define GTK_MESSAGE_ERROR 3
%define GTK_MESSAGE_OTHER 4

%define GTK_BUTTONBOX_SPREAD 1
%define GTK_BUTTONBOX_EDGE 2
%define GTK_BUTTONBOX_START 3
%define GTK_BUTTONBOX_END 4
%define GTK_BUTTONBOX_CENTER 5

%define GTK_BUTTONS_NONE 0 
%define GTK_BUTTONS_OK 1
%define GTK_BUTTONS_CLOSE 2
%define GTK_BUTTONS_CANCEL 3
%define GTK_BUTTONS_YES_NO 4
%define GTK_BUTTONS_OK_CANCEL 5

sys_exit        equ     1
sys_read        equ     3
sys_write       equ     4
sys_open        equ     5
sys_close       equ     6
sys_stat        equ     18
sys_brk         equ     45
sys_newstat     equ     106

O_RDONLY        equ     0
O_WRONLY        equ     1
O_RDWR          equ     2

stdin           equ     0
stdout          equ     1
stderr          equ     2

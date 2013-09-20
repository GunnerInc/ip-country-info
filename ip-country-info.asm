%include "globals.inc"
%include "externs.inc" 
%include "equates.inc"
%include "data.inc"
%include "strings.inc" 

section .text

main:
    push    CURL_GLOBAL_ALL                 ; long flags
    call    curl_global_init                ; CURLcode curl_global_init(long flags);
    add     esp, 4 * 1                      
    test    eax, eax                        
    jnz     .NoInit  

    call    curl_easy_init                  ; CURL *curl_easy_init( );
    test    eax, eax                        
    jz      .NoInit                         
    mov     [curl_handle], eax               
                                                    
    lea     ecx, [esp + 4]                  
    lea     eax, [esp + 8]                  
    push    eax                             ; argv
    push    ecx                             ; argc  
    call    gtk_init                        ; void gtk_init (int *argc, char ***argv);
    add     esp, 4 * 2
    
    call    gtk_builder_new                 ; GtkBuilder * gtk_builder_new (void);
    mov     ebp, eax                        ; ebp = GTKBuilder object

    push    NULL                            ; GError **error
    push    szGladeFile                     ; const gchar *filename
    push    ebp                             ; GtkBuilder *builder
    call    gtk_builder_add_from_file       ; guint gtk_builder_add_from_file (GtkBuilder *builder, const gchar *filename, GError **error);'
    add     esp, 4 * 3
    test    eax, eax
    jnz     .GotGlade
 
    push    szErrNoGTK
    push    fmtst
    call    printf
    add     esp, 4 * 2
    jmp     .Exit

.GotGlade:  
    mov     esi, InfoLblTable               ; array of pointers to widget names
    mov     ebx, InfoLblTable_Len - 1       ; 
    mov     edi, InfoLblArray               ; array to hold label object
.GetLblObjects:    
    push    dword [esi + 4 * ebx]           ; const gchar *name
    push    ebp                             ; GtkBuilder *builder
    call    gtk_builder_get_object          ; GObject * gtk_builder_get_object (GtkBuilder *builder, const gchar *name);    
    add     esp, 4 * 2
    mov     dword [edi + 4 * ebx], eax      ; Save label object to array
    dec     ebx
    jns     .GetLblObjects

    push    szIDip
    push    ebp
    call    gtk_builder_get_object
    add     esp, 4 * 2
    mov     dword [oIP], eax                ; GtkEntry - IP 

    push    szIDFlag
    push    ebp
    call    gtk_builder_get_object
    add     esp, 4 * 2
    mov     [oFlag], eax                    ; GtkImage - Country Flag
 
    push    szIDInfoSearch
    push    ebp
    call    gtk_builder_get_object 
    add     esp, 4 * 2
    mov     [InfoBtnArray + SEARCH], eax    ; GtkButton - Search

    push    szIDInfoClear
    push    ebp
    call    gtk_builder_get_object 
    add     esp, 4 * 2
    mov     [InfoBtnArray + CLEAR], eax     ; GtkButton - Clear
          
    push    szIDMainWin
    push    ebp
    call    gtk_builder_get_object 
    add     esp, 4 * 2
    mov     [oMain], eax                    ; GtkWindow - Main

    push    NULL                            ; gpointer user_data
    push    ebp                             ; GtkBuilder *builder
    call    gtk_builder_connect_signals     ; void gtk_builder_connect_signals (GtkBuilder *builder, gpointer user_data);
    add     esp, 4 * 2
        
    push    ebp                             ; gpointer object
    call    g_object_unref                  ; void g_object_unref (gpointer object);
    add     esp, 4 * 1

    push    dword [oMain]                   ; GtkWidget *widget
    call    gtk_widget_show                 ; void  gtk_widget_show (GtkWidget *widget);
    add     esp, 4 * 1

    call    gtk_main                        ; void gtk_main (void);

.CleanUp:    
    push    dword [curl_handle]             ; CURL * handle
    call    curl_easy_cleanup               ; void curl_easy_cleanup(CURL * handle);
    add     esp, 4 * 1
    
    jmp     .Exit
    
.NoInit:
    push    szErrNoCURL
    push    fmtst
    call    printf
    add     esp, 4 * 2
    
.Exit:
    call    exit

;  #########################################
;  Name       : ClearFields
;  Arguments  : [esp + 4] = TRUE to clear edit control, FALSE to skip
;  Description: Clears all label, edit and image controls
;  Returns    : Nothing
;
ClearFields:
    push    ebp
    mov     ebp, esp
    push    esi
    push    ebx
    
    mov     esi, InfoLblArray
    mov     ebx, InfoLblTable_Len - 1
   
.ClearObjects:
    push    NULL                            ; const gchar *str
    push    dword [esi + 4 * ebx]           ; GtkLabel *label
    call    gtk_label_set_text              ; void gtk_label_set_text (GtkLabel *label, const gchar *str); 
    add     esp, 4 * 2
    dec     ebx
    jns     .ClearObjects
                                   
    mov     eax, [ebp + 8]         
    test    eax, eax
    jz      .ClearImage
                 
    push    -1                              ; gint end_pos
    push    0                               ; gint start_pos
    push    dword [oIP]                     ; GtkEditable *editable
    call    gtk_editable_delete_text        ; void gtk_editable_delete_text (GtkEditable *editable, gint start_pos, gint end_pos);
    add     esp, 4 * 3

.ClearImage:    
    push    dword [oFlag]                   ; GtkImage *image
    call    gtk_image_clear                 ; void gtk_image_clear (GtkImage *image);
    add     esp, 4 * 1
    
    pop     ebx
    pop     esi
    leave
    ret


;  #########################################
;  Name       : GetIPInoAPIKey
;  Arguments  : none
;  Description: reads in IPInfo API key from settings.ini file
;  Returns    : TRUE on success, FALSE on no key, -1 on file open error
; 
GetIPInoAPIKey:        
    mov     byte [lpszIPInfoKey], 0

    push    NULL                            ; GError **error
    push    G_KEY_FILE_NONE                 ; GKeyFileFlags flags
    push    szOptionsFile                   ; const gchar *file
    push    GKeyFile                        ; GKeyFile *key_file
    call    g_key_file_load_from_file       ; gboolean g_key_file_load_from_file (GKeyFile *key_file, const gchar *file, GKeyFileFlags flags, GError **error); 
    add     esp, 4 * 4 
    test    eax, eax
    jnz     .FileOpened

.Error:
    push    GKeyFile                        ; GKeyFile *key_file
    call    g_key_file_free                 ; void g_key_file_free (GKeyFile *key_file);
    add     esp, 4
    mov     eax, -1  
    ret

.FileOpened:    
    push    NULL                            ; GError **error
    push    szIniKey_IPInfo                 ; const gchar *key
    push    szGroup_Keys                    ; const gchar *group_name
    push    GKeyFile                        ; GKeyFile *key_file
    call    g_key_file_get_string           ; gchar* g_key_file_get_string (GKeyFile *key_file, const gchar *group_name, const gchar *key, GError **error);
    add     esp, 4 * 4
    test    eax, eax
    jnz     .Continue

    push    GKeyFile                        ; GKeyFile *key_file
    call    g_key_file_free                 ; void g_key_file_free (GKeyFile *key_file);
    add     esp, 4
    xor     eax, eax 
    ret
    
.Continue:   
    push    eax                             ; gchar* - for g_free
   
    push    IPINFOAPILIMIT                  ; gsize dest_size
    push    eax                             ; const gchar *src
    push    lpszIPInfoKey                   ; gchar *dest
    call    g_strlcpy                       ; gsize g_strlcpy (gchar *dest, const gchar *src, gsize dest_size); 
    add     esp, 4 * 3   

    call    g_free                          ; void g_free (gpointer mem); 
    add     esp, 4
    
.Done:
    push    GKeyFile 
    call    g_key_file_free
    add     esp, 4 

    mov     eax, TRUE
    ret
    
;  #########################################
;  Name       : PreQuery
;  Arguments  : none
;  Description: Checks to see if we have a valid IP address and an IPInfo API key
;  Returns    : nothing
; 
PreQuery:
    push    FALSE
    call    SetButtonState
    
    push    dword [oIP]                     ; GtkEntry *entry
    call    gtk_entry_get_text_length       ; guint16 gtk_entry_get_text_length (GtkEntry *entry);
    add     esp, 4 * 1                      
    test    eax, eax
    jnz     .IsValidIP
    
    push    szErrNoIP
    push    szErrNoSearchInfo
    call    DisplayError
    add     esp, 4 * 2
    jmp     .done

.IsValidIP:
    push    dword [oIP]                     ; GtkEntry *entry   
    call    gtk_entry_get_text              ; const gchar* gtk_entry_get_text (GtkEntry *entry);
    add     esp, 4 * 1                      

    push    eax                             ; const char *src
    push    lpszIP                          ; gchar *dest
    call    g_stpcpy                        ; gchar* g_stpcpy (gchar *dest, const char *src);   
    add     esp, 4 * 2

    push    in_addr                         ; void *dst
    push    lpszIP                          ; const char *src
    push    AF_INET                         ; int af
    call    inet_pton                       ; int inet_pton(int af, const char *src, void *dst);
    add     esp, 4 * 3                       
    test    eax, eax                        ; is it valid?
    jnz     .LoadAPIKey  

    push    szErrInvalidIP
    push    lpszIP
    call    DisplayError
    add     esp, 4 * 2
    jmp     .done
    
.LoadAPIKey:
    call    GetIPInoAPIKey
    test    eax, eax
    js      .NoFile
    jz      .NoKey
    jmp     .GotKey

.NoFile:
    push    NULL
    push    szErrFile 
    call    DisplayError
    add     esp, 4 * 2
    jmp     .done   

.NoKey:
    push    szErrGetKey
    push    szErrKey 
    call    DisplayError
    add     esp, 4 * 2
    jmp     .done       
      
.GotKey:
    push    FALSE
    call    ClearFields
    add     esp, 4 * 1
    
    call    CreateIPInfoURL
    
    push    lpszIPInfoURL                         ; query url
    push    CURLOPT_URL                     ; 
    push    dword[curl_handle]              ; 
    call    curl_easy_setopt                ; 
    add     esp, 4 * 3                      ; 
 
    push    write_data_IPInfo                      ; function cURL will call when data is received
    push    CURLOPT_WRITEFUNCTION           ; 
    push    dword [curl_handle]             ; 
    call    curl_easy_setopt                ; 
    add     esp, 4 * 3                      ;

    push    dword [curl_handle]             ; send our query to SFS
    call    curl_easy_perform               ; 
    add     esp, 4 * 1                      ; 
.done:
    push    TRUE
    call    SetButtonState
    
    ret
   
;  #########################################
;  Name       : DisplayError
;  Arguments  : [esp + 4] = Text
;               [esp + 8] = secondary text (optonal)
;  Description: Displays a GtkMessageDialog
;  Returns    : Nothing
; 
DisplayError:
    push    ebp
    mov     ebp, esp
    sub     esp, 4

    push    dword [ebp + 8]                 ; ...
    push    fmtst                           ; const gchar *message_format
    push    GTK_BUTTONS_CLOSE               ; GtkButtonsType buttons
    push    GTK_MESSAGE_ERROR               ; GtkMessageType type
    push    GTK_DIALOG_DESTROY_WITH_PARENT  ; GtkDialogFlags flags
    push    dword [oMain]                   ; GtkWindow *parent
    call    gtk_message_dialog_new          ; GtkWidget* gtk_message_dialog_new (GtkWindow *parent, GtkDialogFlags flags, GtkMessageType type, GtkButtonsType buttons, const gchar *message_format, ...);   
    add     esp, 4 * 6
    mov     [ebp - 4], eax                  ; GtkWidget*
    
    mov     eax, [ebp + 12]                 ; secondary text
    test    eax, eax                        ; do we have it?
    jz      .ShowIt                         ; no, display MessageDialog

    push    eax                             ; ...
    push    fmtst                           ; const gchar *message_format
    push    dword [ebp - 4]                 ; GtkMessageDialog *message_dialog
    call    gtk_message_dialog_format_secondary_text    ; void gtk_message_dialog_format_secondary_text (GtkMessageDialog *message_dialog, const gchar *message_format, ...);   
    add     esp, 4 * 3

.ShowIt:
    push    dword [ebp - 4]                 ; GtkDialog *dialog
    call    gtk_dialog_run                  ; gint gtk_dialog_run (GtkDialog *dialog);  
    add     esp, 4 * 1
    
    push    dword [ebp - 4]                 ; GtkWidget *widget)
    call    gtk_widget_destroy              ; void gtk_widget_destroy (GtkWidget *widget);
    add     esp, 4 * 1

    push    dword [oIP]                     ; GtkWidget *widget
    call    gtk_widget_grab_focus           ; void gtk_widget_grab_focus (GtkWidget *widget); 
    add     esp, 4 * 1  
        
    leave
    ret 

;  #########################################
;  Name       : CreateIPInfoURL
;  Arguments  : none
;  Description: Creates IPInof URL 
;  Returns    : Nothing
; 
CreateIPInfoURL:    
    push    NULL
    push    szAPIFieldFmt
    push    lpszIP
    push    szAPIFieldIP
    push    lpszIPInfoKey
    push    szIPInfoDBURL
    call    g_strconcat
    add     esp, 4 * 6
    mov     esi, eax

    push    eax
    
    push    eax
    push    lpszIPInfoURL
    call    g_stpcpy
    add     esp, 4 * 2

    call    g_free
    add     esp, 4 * 1
    ret

;~ size_t function( char *ptr, 
                    ;~ size_t size, 
                    ;~ size_t nmemb, 
                    ;~ void *userdata);;
;  #####################################################################
;  Name       : write_data_IPInfo
;  Arguments  : esp + 4 = pointer received data (non NULL terminated)
;               esp + 8 = size
;               esp + 12 = nmemb
;               esp + 16 = pointer to userdata - not used
;  Description: Callback for CURLOPT_WRITEFUNCTION
;  Returns    : returns number of bytes processed
;
write_data_IPInfo:
    push    ebp
    mov     ebp, esp
    push    esi
    push    edi
    push    ebx
    
    mov     ebx, dword[ebp + 8]
    
    movzx   eax, word [ebx]
    cmp     eax, "OK" 
    jne     .Er
    
    push    11
    push    szDelim
    push    ebx
    call    g_strsplit
    add     esp, 4 * 3
    mov     esi, eax

    mov     edi, InfoLblArray
    mov     ebx, 0 
    mov     ecx, 4
.SetLabelText:
    push    ecx
    push    dword[esi + ecx * 4]            ; const gchar *str    
    push    dword [edi + 4 * ebx]           ; GtkLabel *label
    call    gtk_label_set_text              ; void gtk_label_set_text (GtkLabel *label, const gchar *str); 
    add     esp, 4 * 2
    pop     ecx
    inc     ecx
    inc     ebx
    cmp     ebx, InfoLblTable_Len - 1
    jng     .SetLabelText

    push    dword [esi + 3 * 4]
    call    DisplayFlag
    add     esp, 4 * 1
    
    push    esi
    call    g_strfreev
    add     esp, 4 * 1
        
    push    dword [oIP]                     ; GtkWidget *widget
    call    gtk_widget_grab_focus           ; void gtk_widget_grab_focus (GtkWidget *widget); 
    add     esp, 4 * 1      
    

    
    jmp     .done
    
.Er:
    push    11
    push    szDelim
    push    ebx
    call    g_strsplit
    add     esp, 4 * 3
    mov     esi, eax
    
    push    dword [esi +1 * 4]
    push    szErrIPInfoAPI
    call    DisplayError
    add     esp, 4 * 2

    push    esi
    call    g_strfreev
    add     esp, 4 * 1    
.done:
    mov     eax, dword [ebp + 16]
    
    pop     ebx
    pop     edi
    pop     esi
    leave
    ret  

DisplayFlag:
    push    ebp
    mov     ebp, esp
    sub     esp, 4
    ;~ 
    push    NULL
    push    szFlagExt
    push    dword [ebp + 8]
    push    szFlagDir
    call    g_strconcat
    add     esp, 4 * 4
    mov     [ebp - 4], eax
    
    push    eax  
    call    ToLower
    
    push    dword [ebp - 4]  
    push    dword [oFlag]
    call    gtk_image_set_from_file  
    add     esp, 4 * 2

    push    dword [ebp - 4]
    call    g_free
    add     esp, 4 * 1
        
    leave
    ret

;~ #########################################  
;~ ToLower
;~ Purpose:    Converts string to lowercase
;~ Input:      [esp + 4] = pointer to null terminated string to convert
;~ Returns:    nothing
;~ #########################################  
ToLower:
    mov     eax, [esp + 4]
    dec     eax

.start:
    add     eax,  1
    cmp     byte  [eax], 0
    je      .end
    cmp     byte  [eax], "A"
    jb      .start
    cmp     byte  [eax], "Z"
    ja      .start
    add     byte  [eax], 32
    jmp     .start
    
.end:
    ret     4 

SetButtonState:
    push    ebp
    mov     ebp, esp
    
    push    dword [ebp + 8]                           ; disable search button
    push    dword [InfoBtnArray]            ;
    call    gtk_widget_set_sensitive        ;
    add     esp, 4 * 2                      ; 

    push    dword [ebp + 8]                            ; disable clear button
    push    dword [InfoBtnArray + 4]        ;
    call    gtk_widget_set_sensitive        ;
    add     esp, 4 * 2     
    
    leave
    ret     4 * 1                 ;

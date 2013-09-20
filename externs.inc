; GTK
extern gtk_init, gtk_main, printf, exit

extern gtk_builder_new, gtk_builder_add_from_file, gtk_image_set_from_file, gtk_image_clear
extern gtk_builder_get_object, gtk_builder_connect_signals

extern gtk_widget_show, gtk_widget_set_can_default, gtk_widget_destroy

extern gtk_entry_set_text, gtk_entry_set_icon_from_stock, gtk_entry_get_text
extern gtk_entry_get_text_length

extern gtk_editable_delete_text, gtk_editable_get_chars

extern gtk_text_buffer_delete, gtk_text_buffer_set_text,  gtk_widget_show_all, gtk_spinner_start

extern gtk_clipboard_get

extern gtk_label_set_text

extern gtk_image_clear

extern gtk_dialog_run
extern gtk_widget_set_parent, gtk_widget_hide , gtk_widget_show_now,  gtk_main_iteration,gtk_main_iteration_do
extern gtk_widget_set_sensitive
extern g_thread_yield, g_threads_init, gdk_threads_init

; GLib
extern g_object_unref, g_uri_escape_string, g_strescape, g_print, g_thread_init
extern g_markup_parse_context_new, g_markup_parse_context_parse, g_markup_parse_context_get_element 
extern g_strcmp0, g_markup_parse_context_free, g_strstr_len, g_strsplit, g_strfreev, g_strchug, g_stpcpy, g_strrstr
extern g_key_file_get_string, g_key_file_load_from_file, g_key_file_free, g_free,g_strlcpy

; LibcURL
extern curl_easy_init, curl_global_init, curl_easy_cleanup   
extern curl_easy_perform, curl_easy_setopt, curl_easy_escape, curl_easy_getinfo

; System
extern inet_pton, gdk_threads_enter, gdk_threads_leave
extern gethostbyname, gethostname
extern gdk_flush, gtk_spinner_start, g_thread_new,g_thread_exit, g_thread_unref, g_idle_add

extern _GKeyFile,  gdk_window_set_cursor, g_idle_add, g_thread_join
extern gtk_message_dialog_new, gtk_message_dialog_format_secondary_text, gtk_widget_grab_focus , g_strconcat  

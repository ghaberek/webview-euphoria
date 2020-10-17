
include webview.e

procedure main()
	
	atom w = webview_create()
	webview_set_title( w, "Webview Example" )
	webview_set_size( w, 480, 320 )
	webview_navigate( w, "https://en.m.wikipedia.org/wiki/Main_Page" )
	webview_run( w )
	webview_destroy( w )
	
end procedure

main()

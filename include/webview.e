--
-- Euphoria bindings for the webview library.
-- https://github.com/ghaberek/webview-euphoria/
--
-- Webview is a tiny cross-platform library for C/C++/Golang to build modern cross-platform GUIs.
-- https://github.com/webview/webview/
--

namespace webview

include std/dll.e
include std/machine.e
include std/error.e
include std/pretty.e
include std/text.e
include std/types.e

ifdef WINDOWS then
constant webview_name = "webview.dll"

elsifdef LINUX then
constant webview_name = "libwebview.so"

elsifdef OSX then
constant webview_name = "libwebview.dylib"

elsedef
error:crash( "Platform not supported" )

end ifdef

constant webview_dll = open_dll( webview_name )

if webview_dll = NULL then
	error:crash( "webview library '%s' not found", {webview_name} )
end if

constant C_CALL_BACK = C_POINTER
constant C_STRING    = C_POINTER
constant C_WEBVIEW_T = C_POINTER

constant
	_webview_create     = define_c_func( webview_dll, "+webview_create", {C_INT,C_POINTER}, C_POINTER ),
	_webview_destroy    = define_c_proc( webview_dll, "+webview_destroy", {C_WEBVIEW_T} ),
	_webview_run        = define_c_proc( webview_dll, "+webview_run", {C_WEBVIEW_T} ),
	_webview_terminate  = define_c_proc( webview_dll, "+webview_terminate", {C_WEBVIEW_T} ),
	_webview_dispatch   = define_c_proc( webview_dll, "+webview_dispatch", {C_WEBVIEW_T,C_POINTER,C_POINTER} ),
	_webview_get_window = define_c_func( webview_dll, "+webview_get_window", {C_WEBVIEW_T}, C_POINTER ),
	_webview_set_title  = define_c_proc( webview_dll, "+webview_set_title", {C_WEBVIEW_T,C_STRING} ),
	_webview_set_size   = define_c_proc( webview_dll, "+webview_set_size", {C_WEBVIEW_T,C_INT,C_INT,C_INT} ),
	_webview_navigate   = define_c_proc( webview_dll, "+webview_navigate", {C_WEBVIEW_T,C_STRING} ),
	_webview_init       = define_c_proc( webview_dll, "+webview_init", {C_WEBVIEW_T,C_STRING} ),
	_webview_eval       = define_c_proc( webview_dll, "+webview_eval", {C_WEBVIEW_T,C_STRING} ),
	_webview_bind       = define_c_proc( webview_dll, "+webview_bind", {C_WEBVIEW_T,C_STRING,C_CALL_BACK,C_POINTER} ),
	_webview_return     = define_c_proc( webview_dll, "+webview_return", {C_WEBVIEW_T,C_STRING,C_INT,C_STRING} ),
$

sequence binding = {}

function webview_dispatch_callback( atom webview, atom arg )
	return call_func( arg, {webview} )
end function

constant webview_dispatch_callback_id = routine_id( "webview_dispatch_callback" )
constant webview_dispatch_callback_cb = call_back( '+' & webview_dispatch_callback_id )

function unescape( sequence s, sequence what = "\r\n\t\"\'\0\\" )
	integer i = 1
	sequence r = ""

	if length( s ) = 0 then
		return s
	end if

	while i <= length( s ) do

		if s[i] = '\\' then
			i += 1

			if i <= length( s ) then
				switch s[i] do
					case 'n' then s[i] = '\n'
					case 'r' then s[i] = '\r'
					case 't' then s[i] = '\t'
					case '0' then s[i] = '\0'
				end switch
			end if

		end if

		r &= s[i]
		i += 1

	end while

	return r
end function

function webview_binding_callback( atom seq, atom req, atom arg )
	
	atom webview = binding[arg][1]
	integer func = binding[arg][2]
	
	sequence params = peek_string( req )
	params =  text:keyvalues( params[2..$-1], ',', ':', `"'`, " \n\r\t", FALSE )
	
	for i = 1 to length( params ) do
		params[i] = unescape( params[i] )
	end for
	
	integer status = 0
	object result = call_func( func, {webview} & params )
	
	if length( result ) = 2 then
		status = result[1]
		result = result[2]
	end if
	
	if atom( result ) then
		result = sprint( result )
		
	elsif string( result ) then
		result = pretty_sprint( result, {2} )
		
	end if
	
	webview_return( webview, seq, status, result )
	
	return 0
end function

constant webview_binding_callback_id = routine_id( "webview_binding_callback" )
constant webview_binding_callback_cb = call_back( '+' & webview_binding_callback_id )

--
-- Creates a new webview instance. If debug is non-zero - developer tools will
-- be enabled (if the platform supports them). Window parameter can be a
-- pointer to the native window handle. If it's non-null - then child WebView
-- is embedded into the given parent window. Otherwise a new window is created.
-- Depending on the platform, a GtkWindow, NSWindow or HWND pointer can be
-- passed here.
--
public function webview_create( integer debug = FALSE, atom window = NULL )
	return c_func( _webview_create, {debug,window} )
end function

--
-- Destroys a webview and closes the native window.
--
public procedure webview_destroy( atom webview )
	c_proc( _webview_destroy, {webview} )
end procedure

--
-- Runs the main loop until it's terminated. After this function exits - you
-- must destroy the webview.
--
public procedure webview_run( atom webview )
	c_proc( _webview_run, {webview} )
end procedure

--
-- Stops the main loop. It is safe to call this function from another other
-- background thread.
--
public procedure webview_terminate( atom webview )
	c_proc( _webview_terminate, {webview} )
end procedure

--
-- Posts a function to be executed on the main thread. You normally do not need
-- to call this function, unless you want to tweak the native window.
--
-- Your dispatch function should accept two parameters:
-- - atom webview - the handle of the webview
-- - atom arg     - the provided user argument
--
public procedure webview_dispatch( atom webview, sequence func_name, integer func_id=routine_id(func_name) )
	c_proc( _webview_dispatch, {webview,webview_dispatch_callback_cb,func_id} )
end procedure

--
-- Returns a native window handle pointer. When using GTK backend the pointer
-- is GtkWindow pointer, when using Cocoa backend the pointer is NSWindow
-- pointer, when using Win32 backend the pointer is HWND pointer.
--
public function webview_get_window( atom webview )
	return c_func( _webview_get_window, {webview} )
end function

--
-- Updates the title of the native window. Must be called from the UI thread.
--
public procedure webview_set_title( atom webview, sequence title )
	c_proc( _webview_set_title, {webview,allocate_string(title,TRUE)} )
end procedure

--
-- Window size hints
--
public constant
	WEBVIEW_HINT_NONE  = 0, -- Width and height are default size
	WEBVIEW_HINT_MIN   = 1, -- Width and height are minimum bounds
	WEBVIEW_HINT_MAX   = 2, -- Width and height are maximum bounds
	WEBVIEW_HINT_FIXED = 3, -- Window size can not be changed by a user
$

--
-- Updates native window size. See WEBVIEW_HINT constants.
--
public procedure webview_set_size( atom webview, integer width, integer height,
		integer hints = WEBVIEW_HINT_NONE )
	c_proc( _webview_set_size, {webview,width,height,hints} )
end procedure

--
-- Navigates webview to the given URL. URL may be a data URI, i.e.
-- "data:text/text,<html>...</html>". It is often ok not to url-encode it
-- properly, webview will re-encode it for you.
--
public procedure webview_navigate( atom webview, sequence url )
	c_proc( _webview_navigate, {webview,allocate_string(url,TRUE)} )
end procedure

--
-- Injects JavaScript code at the initialization of the new page. Every time
-- the webview will open a the new page - this initialization code will be
-- executed. It is guaranteed that code is executed before window.onload.
--
public procedure webview_init( atom webview, sequence js )
	c_proc( _webview_init, {webview,allocate_string(js,TRUE)} )
end procedure

--
-- Evaluates arbitrary JavaScript code. Evaluation happens asynchronously, also
-- the result of the expression is ignored. Use RPC bindings if you want to
-- receive notifications about the results of the evaluation.
--
public procedure webview_eval( atom webview, sequence js )
	c_proc( _webview_eval, {webview,allocate_string(js,TRUE)} )
end procedure

--
-- Binds a native C callback so that it will appear under the given name as a
-- global JavaScript function. Internally it uses webview_init(). Callback
-- receives a request string and a user-provided argument pointer. Request
-- string is a JSON array of all the arguments passed to the JavaScript
-- function.
--
-- Your bind function should accept three parameter:
-- - atom seq - pointer to string: RPC sequence
-- - atom req - pointer to string: request parameters
-- - atom arg - the provided user argument
--
public procedure webview_bind( atom webview, sequence func_name, integer func_id=routine_id(func_name) )
	binding = append( binding, {webview,func_id} )
	c_proc( _webview_bind, {webview,allocate_string(func_name,TRUE),webview_binding_callback_cb,length(binding)} )
end procedure

--
-- Allows to return a value from the native binding. Original request pointer
-- must be provided to help internal RPC engine match requests with responses.
-- If status is zero - result is expected to be a valid JSON result value.
-- If status is not zero - result is an error JSON object.
--
public procedure webview_return( atom webview, atom seq, integer status, sequence result )
	c_proc( _webview_return, {webview,seq,status,allocate_string(result,TRUE)} )
end procedure


include std/dll.e
include std/machine.e
include std/search.e
include std/types.e

atom comdlg32 = open_dll( "comdlg32.dll" )
atom kernel32 = open_dll( "kernel32.dll" )
atom user32   = open_dll( "user32.dll" )

constant
	xCommDlgExtendedError = define_c_func( comdlg32, "CommDlgExtendedError", {}, C_DWORD ),
	xGetActiveWindow      = define_c_func( user32, "GetActiveWindow", {}, C_HWND ),
	xGetConsoleWindow     = define_c_func( kernel32, "GetConsoleWindow", {}, C_HWND ),
	xGetOpenFileNameA     = define_c_func( comdlg32, "GetOpenFileNameA", {C_POINTER}, C_BOOL ),
	xGetSaveFileNameA     = define_c_func( comdlg32, "GetSaveFileNameA", {C_POINTER}, C_BOOL ),
$

ifdef BITS64 then

constant
	OPENFILENAMEA__lStructSize          =   0, -- DWORD
	OPENFILENAMEA__hwndOwner            =   8, -- HWND
	OPENFILENAMEA__hInstance            =  16, -- HINSTANCE
	OPENFILENAMEA__lpstrFilter          =  24, -- LPCSTR
	OPENFILENAMEA__lpstrCustomFilter    =  32, -- LPSTR
	OPENFILENAMEA__nMaxCustFilter       =  40, -- DWORD
	OPENFILENAMEA__nFilterIndex         =  44, -- DWORD
	OPENFILENAMEA__lpstrFile            =  48, -- LPSTR
	OPENFILENAMEA__nMaxFile             =  56, -- DWORD
	OPENFILENAMEA__lpstrFileTitle       =  64, -- LPSTR
	OPENFILENAMEA__nMaxFileTitle        =  72, -- DWORD
	OPENFILENAMEA__lpstrInitialDir      =  80, -- LPCSTR
	OPENFILENAMEA__lpstrTitle           =  88, -- LPCSTR
	OPENFILENAMEA__Flags                =  96, -- DWORD
	OPENFILENAMEA__nFileOffset          = 100, -- WORD
	OPENFILENAMEA__nFileExtension       = 102, -- WORD
	OPENFILENAMEA__lpstrDefExt          = 104, -- LPCSTR
	OPENFILENAMEA__lCustData            = 112, -- LPARAM
	OPENFILENAMEA__lpfnHook             = 120, -- LPOFNHOOKPROC
	OPENFILENAMEA__lpTemplateName       = 128, -- LPCSTR
	OPENFILENAMEA__pvReserved           = 136, -- void*
	OPENFILENAMEA__dwReserved           = 144, -- DWORD
	OPENFILENAMEA__FlagsEx              = 148, -- DWORD
	SIZEOF_OPENFILENAMEA                = 152,
$

elsedef

constant
	OPENFILENAMEA__lStructSize          =  0, -- DWORD
	OPENFILENAMEA__hwndOwner            =  4, -- HWND
	OPENFILENAMEA__hInstance            =  8, -- HINSTANCE
	OPENFILENAMEA__lpstrFilter          = 12, -- LPCSTR
	OPENFILENAMEA__lpstrCustomFilter    = 16, -- LPSTR
	OPENFILENAMEA__nMaxCustFilter       = 20, -- DWORD
	OPENFILENAMEA__nFilterIndex         = 24, -- DWORD
	OPENFILENAMEA__lpstrFile            = 28, -- LPSTR
	OPENFILENAMEA__nMaxFile             = 32, -- DWORD
	OPENFILENAMEA__lpstrFileTitle       = 36, -- LPSTR
	OPENFILENAMEA__nMaxFileTitle        = 40, -- DWORD
	OPENFILENAMEA__lpstrInitialDir      = 44, -- LPCSTR
	OPENFILENAMEA__lpstrTitle           = 48, -- LPCSTR
	OPENFILENAMEA__Flags                = 52, -- DWORD
	OPENFILENAMEA__nFileOffset          = 56, -- WORD
	OPENFILENAMEA__nFileExtension       = 58, -- WORD
	OPENFILENAMEA__lpstrDefExt          = 60, -- LPCSTR
	OPENFILENAMEA__lCustData            = 64, -- LPARAM
	OPENFILENAMEA__lpfnHook             = 68, -- LPOFNHOOKPROC
	OPENFILENAMEA__lpTemplateName       = 72, -- LPCSTR
	OPENFILENAMEA__pvReserved           = 76, -- void*
	OPENFILENAMEA__dwReserved           = 80, -- DWORD
	OPENFILENAMEA__FlagsEx              = 84, -- DWORD
	SIZEOF_OPENFILENAMEA                = 88,
$

end ifdef

public constant
	OFN_READONLY                = 0x00000001,
	OFN_OVERWRITEPROMPT         = 0x00000002,
	OFN_HIDEREADONLY            = 0x00000004,
	OFN_NOCHANGEDIR             = 0x00000008,
	OFN_SHOWHELP                = 0x00000010,
	OFN_ENABLEHOOK              = 0x00000020,
	OFN_ENABLETEMPLATE          = 0x00000040,
	OFN_ENABLETEMPLATEHANDLE    = 0x00000080,
	OFN_NOVALIDATE              = 0x00000100,
	OFN_ALLOWMULTISELECT        = 0x00000200,
	OFN_EXTENSIONDIFFERENT      = 0x00000400,
	OFN_PATHMUSTEXIST           = 0x00000800,
	OFN_FILEMUSTEXIST           = 0x00001000,
	OFN_CREATEPROMPT            = 0x00002000,
	OFN_SHAREAWARE              = 0x00004000,
	OFN_NOREADONLYRETURN        = 0x00008000,
	OFN_NOTESTFILECREATE        = 0x00010000,
	OFN_NONETWORKBUTTON         = 0x00020000,
	OFN_NOLONGNAMES             = 0x00040000,
	OFN_EXPLORER                = 0x00080000,
	OFN_NODEREFERENCELINKS      = 0x00100000,
	OFN_LONGNAMES               = 0x00200000,
	OFN_ENABLEINCLUDENOTIFY     = 0x00400000,
	OFN_ENABLESIZING            = 0x00800000,
	OFN_DONTADDTORECENT         = 0x02000000,
	OFN_FORCESHOWHIDDEN         = 0x10000000,
	OFN_EX_NOPLACESBAR          = 0x00000001,
$

public constant
	CDERR_STRUCTSIZE        = 0x0001,
	CDERR_INITIALIZATION    = 0x0002,
	CDERR_NOTEMPLATE        = 0x0003,
	CDERR_NOHINSTANCE       = 0x0004,
	CDERR_LOADSTRFAILURE    = 0x0005,
	CDERR_FINDRESFAILURE    = 0x0006,
	CDERR_LOADRESFAILURE    = 0x0007,
	CDERR_LOCKRESFAILURE    = 0x0008,
	CDERR_MEMALLOCFAILURE   = 0x0009,
	CDERR_MEMLOCKFAILURE    = 0x000A,
	CDERR_NOHOOK            = 0x000B,
	CDERR_REGISTERMSGFAIL   = 0x000C,
	CDERR_DIALOGFAILURE     = 0xFFFF,
	FNERR_BUFFERTOOSMALL    = 0x3003,
	FNERR_INVALIDFILENAME   = 0x3002,
	FNERR_SUBCLASSFAILURE   = 0x3001,
$

constant NO_VALUE = -1
constant MAX_LEN = 4096

public function GetOpenFileName( atom hwndOwner = NO_VALUE, sequence strFile = "", sequence strFilter = "All Files|*.*", integer nFilterIndex = 1, atom Flags = OFN_FILEMUSTEXIST, atom FlagsEx = 0 )
	
	if hwndOwner = NO_VALUE then
		
		hwndOwner = c_func( xGetActiveWindow, {} )
		
		if hwndOwner = NULL then
			hwndOwner = c_func( xGetConsoleWindow, {} )
		end if
		
	end if
	
	strFilter = find_replace( '|', strFilter, '\0' )
	if not search:ends( '\0', strFilter ) then
		strFilter &= '\0'
	end if
	
	atom lpstrFilter = allocate_string( strFilter, TRUE )
	
	atom lpstrFile = allocate_data( MAX_LEN, TRUE )
	atom nMaxFile = MAX_LEN
	mem_set( lpstrFile, NULL, MAX_LEN )
	
	if length( strFile ) then
		poke( lpstrFile, strFile & '\0' )
	end if
	
	atom ofn = allocate_data( SIZEOF_OPENFILENAMEA, TRUE )
	mem_set( ofn, NULL, SIZEOF_OPENFILENAMEA )
	
	poke_pointer( ofn + OPENFILENAMEA__lStructSize,  SIZEOF_OPENFILENAMEA )
	poke_pointer( ofn + OPENFILENAMEA__hwndOwner,    hwndOwner )
	poke_pointer( ofn + OPENFILENAMEA__lpstrFilter,  lpstrFilter )
	       poke4( ofn + OPENFILENAMEA__nFilterIndex, nFilterIndex )
	poke_pointer( ofn + OPENFILENAMEA__lpstrFile,    lpstrFile )
	       poke4( ofn + OPENFILENAMEA__nMaxFile,     nMaxFile )
	       poke4( ofn + OPENFILENAMEA__Flags,        Flags )
	       poke4( ofn + OPENFILENAMEA__FlagsEx,      FlagsEx )
	
	if c_func( xGetOpenFileNameA, {ofn} ) = FALSE then
		return c_func( xCommDlgExtendedError, {} )
	end if
	
	return peek_string( lpstrFile )
end function

public function GetSaveFileName( atom hwndOwner = NO_VALUE, sequence strFile = "", sequence strFilter = "All Files|*.*", integer nFilterIndex = 1, atom Flags = OFN_OVERWRITEPROMPT, atom FlagsEx = 0 )
	
	if hwndOwner = NO_VALUE then
		
		hwndOwner = c_func( xGetActiveWindow, {} )
		
		if hwndOwner = NULL then
			hwndOwner = c_func( xGetConsoleWindow, {} )
		end if
		
	end if
	
	strFilter = find_replace( '|', strFilter, '\0' )
	if not search:ends( '\0', strFilter ) then
		strFilter &= '\0'
	end if
	
	atom lpstrFilter = allocate_string( strFilter, TRUE )
	
	atom lpstrFile = allocate_data( MAX_LEN, TRUE )
	atom nMaxFile = MAX_LEN
	mem_set( lpstrFile, NULL, MAX_LEN )
	
	if length( strFile ) then
		poke( lpstrFile, strFile & '\0' )
	end if
	
	atom ofn = allocate_data( SIZEOF_OPENFILENAMEA, TRUE )
	mem_set( ofn, NULL, SIZEOF_OPENFILENAMEA )
	
	poke_pointer( ofn + OPENFILENAMEA__lStructSize,  SIZEOF_OPENFILENAMEA )
	poke_pointer( ofn + OPENFILENAMEA__hwndOwner,    hwndOwner )
	poke_pointer( ofn + OPENFILENAMEA__lpstrFilter,  lpstrFilter )
	       poke4( ofn + OPENFILENAMEA__nFilterIndex, nFilterIndex )
	poke_pointer( ofn + OPENFILENAMEA__lpstrFile,    lpstrFile )
	       poke4( ofn + OPENFILENAMEA__nMaxFile,     nMaxFile )
	       poke4( ofn + OPENFILENAMEA__Flags,        Flags )
	       poke4( ofn + OPENFILENAMEA__FlagsEx,      FlagsEx )
	
	if c_func( xGetSaveFileNameA, {ofn} ) = FALSE then
		return c_func( xCommDlgExtendedError, {} )
	end if
	
	return peek_string( lpstrFile )
end function




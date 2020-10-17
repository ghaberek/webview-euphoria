
include std/io.e
include std/filesys.e
include std/search.e

include commdlg.e
include webview.e

function getOpenFileName( atom webview )
	
	object result = GetOpenFileName()
	
	if atom( result ) then
		return {-1,result}
	end if
	
	return result
end function

function getSaveFileName( atom webview )
	
	object result = GetSaveFileName()
	
	if atom( result ) then
		return {-1,result}
	end if
	
	return result
end function

function readFile( atom webview, sequence fileName )
	
	if file_exists( fileName ) then
		return read_file( fileName )
	end if
	
	return {-1,0}
end function

function writeFile( atom webview, sequence fileName, sequence textValue )
	
	textValue = match_replace( "\n", textValue, "\r\n" )
	
	if write_file( fileName, textValue ) = 0 then
		return 0
	end if
	
	return {-1,0}
end function

procedure main()
	
	atom w = webview_create()
	webview_set_title( w, "Text Editor" )
	webview_set_size( w, 720, 480 )
	webview_bind( w, "getOpenFileName" )
	webview_bind( w, "getSaveFileName" )
	webview_bind( w, "readFile" )
	webview_bind( w, "writeFile" )
	webview_navigate( w, `data:text/html,
	<!DOCTYPE html>
	<html>
		<body>

			<div>
				<h1>Text Editor</h2>
				<p>This example uses native functions to read and write text files.</p>
			</div>

			<div>
				<p>
					<input type="text" id="txtFile" value="" size="64" readonly>
					<input type="button" id="btnOpen" value="Open">
					<input type="button" id="btnSave" value="Save">
				</p>
			</div>

			<div>
				<textarea id="editText" cols="80" rows="20"></textarea>
			</div>

		</body>
		<script>
		window.onload = function() {

			document.getElementById('btnOpen').onclick = function() {
				getOpenFileName().then(function(fileName) {
					if ( typeof(fileName) == 'string' ) {
						readFile(fileName).then(function(textValue) {
							if ( typeof(textValue) == 'string' ) {
								document.getElementById('txtFile').value = fileName;
								document.getElementById('editText').value = textValue;
							}
						});
					}
				});
			};

			document.getElementById('btnSave').onclick = function() {
				getSaveFileName().then(function(fileName) {
					if ( typeof(fileName) == 'string' ) {
						var textValue = document.getElementById('editText').value;
						writeFile(fileName, textValue);
					}
				});
			};

		};
		</script>
	</html>
	` )
	webview_run( w )
	webview_destroy( w )
	
end procedure

main()

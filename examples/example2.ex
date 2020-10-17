
include std/convert.e
include webview.e

function noop( atom webview )
	printf( 1, "hello\n" )
	return "hello"
end function

function add( atom webview, object a, object b )
	return to_integer( a ) + to_integer( b )
end function

function quit( atom webview )
	webview_terminate( webview )
	return 0
end function

procedure main()
	
	atom w = webview_create()
	webview_set_title( w, "Hello" )
	webview_bind( w, "noop" )
	webview_bind( w, "add" )
	webview_bind( w, "quit" )
	webview_navigate( w, `data:text/html,
		<!doctype html>
		<html>
			<body>hello</body>
			<script>
				window.onload = function() {
					document.body.innerText = ` & "`hello, ${navigator.userAgent}`" & `;
					noop().then(function(res) {
						console.log('noop res', res);
						add(1, 2).then(function(res) {
							console.log('add res', res);
							quit();
						});
					});
				};
			</script>
		</html>
	)`)
	webview_run( w )
	webview_destroy( w )
	
end procedure

main()

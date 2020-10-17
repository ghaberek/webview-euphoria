# webview

Euphoria bindings for the [webview] library.

## Installation

### Windows

You will need to have [Microsoft Edge Insider] installed to use the Chromium-based **WebView2**. Webview *should* fall back to the original **EdgeHTML** engine if WebView2 is not found.

    copy include\webview.e C:\Euphoria\include
    copy libs\webview.dll C:\Euphoria\bin
    copy libs\WebView2Loader.dll C:\Euphoria\bin

### Linux

On Debian/Ubuntu, you will need to have [libgtk-3-0] and [libwebkit2gtk-4.0-37] installed. Unsure what the correct libs on other distros are but they should be similar (basically **GTK3** and **webview2gtk4**).

    sudo cp include/webview.e /usr/local/euphoria-4.1.0-Linux-x64/
    sudo cp libs/webview.so /usr/local/euphoria-4.1.0-Linux-x64/

## Usage

### Example

    include webview.e

    atom w = webview_create()
    webview_set_title( w, "Webview Example" )
    webview_set_size( w, 480, 320 )
    webview_navigate( w, "https://en.m.wikipedia.org/wiki/Main_Page" )
    webview_run( w )
    webview_destroy( w )

[webview]: https://github.com/webview/webview
[Microsoft Edge Insider]: https://www.microsoftedgeinsider.com/en-us/download
[libgtk-3-0]: https://launchpad.net/ubuntu/+source/gtk+3.0
[libwebkit2gtk-4.0-37]: https://launchpad.net/ubuntu/+source/webkit2gtk

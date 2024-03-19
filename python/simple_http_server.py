import http.server
import os
import sys

class MyHttpRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=self.directory, **kwargs)

def run(server_class=http.server.HTTPServer, handler_class=MyHttpRequestHandler, port=8000):
    if len(sys.argv) < 2:
        print("Usage: python simple_http_server.py <directory>")
        sys.exit(1)
    directory_path = sys.argv[1]
    if not os.path.isdir(directory_path):
        print(f"Error: {directory_path} is not a directory or does not exist.")
        sys.exit(1)

    handler_class.directory = directory_path
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print(f"Serving HTTP on port {port} from directory {directory_path}...")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped.")
        httpd.server_close()

if __name__ == '__main__':
    run()


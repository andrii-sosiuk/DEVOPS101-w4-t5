
import os
import sys
import http.server
from urllib.parse import unquote

import ascii_converter

class MyHttpRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=self.directory, **kwargs)

    def do_GET(self):
        # Log client details
        print(f"Received a GET request from {self.client_address[0]}:{self.client_address[1]}")
        print(f"Request line: {self.requestline}")
        
        # Print Headers
        print("Headers:")
        for header in self.headers:
            print(f"  {header}: {self.headers[header]}")

        # Process the requested path
        requested_path = unquote(self.path)
        
        # Prevent directory traversal vulnerability
        requested_path = requested_path.replace("../", "")
        
        # Map to index.html if the path is a directory
        if requested_path.endswith('/'):
            requested_path += 'index.html'
        
        # Construct the full path and check if the file exists
        full_path = os.path.join(self.directory, requested_path.strip('/'))

        if "curl" in self.headers['User-Agent']:
            print("Got request for curl agent !")

            # full_path = os.path.join(self.directory, requested_path.strip('/'))
            with open(full_path, "r") as html_file :
                html = html_file.readlines()
                for line in html:
                    find_index = line.find("play(frame =")
                    if find_index != -1:
                        frame_index_start = line[find_index:].find("=")
                        frame_index_end = line[find_index:].find(",")
                        frame_num = str(int(line[find_index+frame_index_start+1:find_index+frame_index_end]))
                        # frame_num = str(int(line[find_index:find_index+frame_index_end]))

            #------------------------------------------------
            self.send_response(200)
            # self.send_header('Content-type', 'text/html')
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            file_data = ascii_converter.convert_file(f"html/frame{frame_num}.svg")
            # print(file_data)
            self.wfile.write(file_data.encode("utf-8"))

        else:
        #     self.send_error(404, "File nooooot found")
        
            # # Process the requested path
            # requested_path = unquote(self.path)
            
            # # Prevent directory traversal vulnerability
            # requested_path = requested_path.replace("../", "")
            
            # # Map to index.html if the path is a directory
            # if requested_path.endswith('/'):
            #     requested_path += 'index.html'
            
            # # Construct the full path and check if the file exists
            # full_path = os.path.join(self.directory, requested_path.strip('/'))
            
            if os.path.exists(full_path) and not os.path.isdir(full_path):
                self.send_response(200)
                # You can add more content types based on the files you serve
                if full_path.endswith('.html'):
                    self.send_header('Content-type', 'text/html')
                elif full_path.endswith('.css'):
                    self.send_header('Content-type', 'text/css')
                elif full_path.endswith('.js'):
                    self.send_header('Content-type', 'application/javascript')
                elif full_path.endswith('.png'):
                    self.send_header('Content-type', 'image/png')
                elif full_path.endswith('.jpg') or full_path.endswith('.jpeg'):
                    self.send_header('Content-type', 'image/jpeg')
                else:
                    self.send_header('Content-type', 'text/plain')
                
                self.end_headers()
                
                with open(full_path, 'rb') as file:
                    self.wfile.write(file.read())
            else:
                self.send_error(404, "File not found")


def run(server_class=http.server.HTTPServer, handler_class=MyHttpRequestHandler, port=8080):
    if len(sys.argv) < 2:
        print("Usage: python simple_http_server.py <directory>")
        sys.exit(1)
    directory_path = sys.argv[1]
    if not os.path.isdir(directory_path):
        print(os.path.abspath(os.path.curdir))
        print(f"Error: {directory_path} is not a directory or does not exist.")
        sys.exit(1)

    if len(sys.argv) == 3:
        port = int(sys.argv[2])
    # directory_path="html"

    handler_class.directory = directory_path
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print(f"Serving HTTP on port {port} from directory {directory_path}...")
    print(f"Serving HTTP on port {port} from directory {directory_path}...", file=sys.stderr)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped.")
        httpd.server_close()

if __name__ == '__main__':
    run()

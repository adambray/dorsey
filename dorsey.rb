require 'pry'

require 'socket'
require_relative 'constants'

$routes = {
  "/" => ->() { "hello world!" },
  "/boop" => ->() { "I boop you!" }
}

def get(path, &block)
  $routes[path] = block.to_proc
end

get("/cheese") do
  "i love cheese!"
end

get("/news") do
  "newwwwwss!"
end
# This helper function parses the extension of the
# requested file and then looks up its content type.

def route_exists?(path)
  $routes.keys.include?(path)
end

def header(content, status=200, type=:file)
  status_code = STATUS_CODES[status]
  content_type = type == :file ? content_type(content) : "text/plain"
  content_size = type == :file ? content.size : content.bytesize

  "HTTP/1.1 #{status_code}\r\n" +
  "Content-Type: #{content_type}\r\n" +
  "Content-Length: #{content_size}\r\n" +
  "Connection: close\r\n"
end

def content_type(path)
  ext = File.extname(path).split(".").last
  CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
end

# This helper function parses the Request-Line and
# generates a path to a file on the server.

def get_request(request_line)
  path  = request_line.split(" ")[1]

  file_path = File.join(WEB_ROOT, path)
  if File.exist?(file_path) && !File.directory?(file_path)
    return {type: :file, path: file_path, status: 200}
  elsif route_exists?(path)
    return {type: :route, path: path, status: 200, proc: $routes[path]}
  else
    return {type: :not_found, path: path, status: 404}
  end

end

server = TCPServer.new('localhost', 2345)

loop do
  socket       = server.accept
  request_line = socket.gets

  puts request_line
  request = get_request(request_line)

  case request[:type]
  when :file
    File.open(request[:path], "rb") do |file|
      socket.print header(file, request[:status])
      socket.print "\r\n"
      IO.copy_stream(file, socket)
    end
  when :route
    message = request[:proc].call
    socket.print header(message, request[:status], :text)
    socket.print "\r\n"
    socket.print message
  when :not_found
    message = "File not found\n"

    # respond with a 404 error code to indicate the file does not exist
    socket.print header(message, request[:status], :text)
    socket.print "\r\n"
    socket.print message
  end

  socket.close
end

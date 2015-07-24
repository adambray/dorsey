require 'pry'
require 'socket'

server = TCPServer.new('localhost', 2345)
socket = server.accept

binding.pry

puts "fix pry bug"
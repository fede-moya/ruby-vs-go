# http_server.rb
require 'socket'
require 'base64'

def fib(n)
  return n if n < 2
  fib(n-1) + fib(n-2)
end

print "Ruby server running on localhost:3000"
server = TCPServer.new 3000

while conn = server.accept
  Thread.new(conn) do |c|
    request = c.gets
    puts request

    c.print "HTTP/1.1 200\r\n" # 1
    c.print "Content-Type: text/html\r\n" # 2
    c.print "\r\n" # 3
    c.print Base64.encode64("Hello world! The time is #{Time.now}") #4
    fib(23)
    c.close
  end
end


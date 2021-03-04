require "gruff"
require "json"

c_values = [8, 16, 32, 64]
c_values.each do |n|
  system("siege -t 5s -c #{n} --json-output  http://localhost:3000 >> ruby-stats-c#{n}.json")
end

c_values.each do |n|
  system("siege -t 5s -c #{n} --json-output  http://localhost:3001 >> go-stats-c#{n}.json")
end


g = Gruff::Line.new
g.title = "Ruby vs Go: Response time"

labels = {}
(0..7).each do |i|
  labels[i] = c_values[i]
end
g.labels = labels

ruby_stats = []
c_values.each do |n|
  s = File.open("ruby-stats-c#{n}.json")
  s = JSON.parse(s.read)
  ruby_stats << s["response_time"]
end

go_stats = []
c_values.each do |n|
  s = File.open("go-stats-c#{n}.json")
  s = JSON.parse(s.read)
  go_stats << s["response_time"]
end

g.data :ruby, ruby_stats
g.data :go, go_stats

g.write('response-time.png')

g = Gruff::Line.new
g.title = "Ruby vs Go: Concurrency"

labels = {}
(0..7).each do |i|
  labels[i] = c_values[i]
end
g.labels = labels

ruby_stats = []
c_values.each do |n|
  s = File.open("ruby-stats-c#{n}.json")
  s = JSON.parse(s.read)
  ruby_stats << s["concurrency"]
end

go_stats = []
c_values.each do |n|
  s = File.open("go-stats-c#{n}.json")
  s = JSON.parse(s.read)
  go_stats << s["concurrency"]
end

g.data :ruby, ruby_stats
g.data :go, go_stats

g.write('concurrency.png')
system("rm ruby-stats-c* go-stats-c*")

require "sinatra"
require 'mkmf'
require_relative 'image_process'

unless find_executable 'adb'
	puts "ADB not found in yout $PATH!"
	exit
end

SCHREEN_SHOT = "screenshot.png"

set :port, 8899

get '/' do
	unless params["step"]
		puts "Init screenshots"
		`adb shell screencap -p  > public/#{SCHREEN_SHOT}`
	end
	erb :index
end

get '/find_chess' do
	begin
		@chess_point = find_chess
	rescue
		return {}.to_json
	end
	return {x: @chess_point[0], y: @chess_point[1]}.to_json
end
	

get '/main.js' do
  coffee :main
end

post "/jump" do
	time = params["time"]

	time = (time.to_f.round(3)*1000).to_i
	p time

	x = (rand*300).floor
	y = (rand*500).floor
	p "adb shell input touchscreen swipe #{x} #{y} #{x} #{y} #{time}"
	`adb shell input touchscreen swipe #{x} #{y} #{x} #{y} #{time}`
	sleep 0.5+time/1000.0
	`adb shell screencap -p  > public/#{SCHREEN_SHOT}`
	return {status: 200}.to_json
end

require "mini_magick"
require "pry"

def search(pix, row, col, value, radius)
	for dr in -radius..radius
		for rc in -radius..radius
			nrow = row+dr
			ncol = col+rc
			next if nrow<0 || ncol<0
			begin
				tp = pix[nrow][ncol][0]
			rescue
				tp = nil
			end
			return true if tp== value
		end
	end
	return false
end


def find_chess
	image = MiniMagick::Image.open("public/screenshot.png")
	# image = MiniMagick::Image.open("testcase/screenshot3.png")

	image.combine_options do |o|
		o.resize "50%"
		o.fuzz "7%"
		o.fill "white"
		o.opaque.+ "rgb(50,50,90)"
		o.canny "0x1+10%+20%"
		o.colorspace "Gray"
	end


	pixels = image.get_pixels
	res_points = []
	for col in 0...540
		for row in 400..700
			pix = pixels[row][col][0]
			# print pix if pix==255
			if pix==255
				s = []
				s << search(pixels, row, col+1, 255, 2)
				s << search(pixels, row, col-1, 255, 2)
				s << search(pixels, row+105, col, 255, 2)
				s << search(pixels, row+30, col, 255, 2)
				s << search(pixels, row+15, col-15, 255, 2)
				# s << search(pixels, row+15, col+15, 255, 2)
				if s.all? { |e| e==true }
					res_points << [col, row]
					image.combine_options do |c|
					  c.fill "red"
					  c.draw "point #{col},#{row}"
					end
					# exit
				end
			end
		end
	end

	begin
		point = res_points.
			reduce{ |sum, n| sum[0]+=n[0]; sum[1]+=n[1]; sum }
		point = point.collect{ |c| c/res_points.size}


		point[1] += 98

		x, y = point.collect{ |c| c*0.75 }

		p res_points, point, x, y

		image.combine_options do |c|
		  c.fill "green"
		  c.draw "point #{point[0]},#{point[1]}"
		end
	rescue
		x, y = 0, 0
	end
	image.write "tmp/detect_outpu.png"
	return [x,y]
end
module StoriesHelper
	def next_realid(lastid)
		number = remove_text(lastid).to_i
		text = remove_numbers(lastid)
		number += 1
		if(number >= 10 && number < 100)
			id = "#{text}0#{number}"
		else
			if(number < 10)
				id = "#{text}00#{number}"
			else
				id = "#{text}#{number}"
			end
		end
		return id
	end
end

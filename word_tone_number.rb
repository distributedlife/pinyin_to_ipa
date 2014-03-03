def tone_numbers words
	first_tone = ['ā', 'ē', 'ī', 'ō', 'ū']
	second_tone = ['á', 'é', 'í', 'ó', 'ú']
	third_tone = ['ǎ', 'ě', 'ǐ', 'ǒ', 'ǔ', 'ǚ']
	fourth_tone = ['à', 'è', 'ì', 'ò', 'ù']
	neutral_tone = ['a', 'e', 'i', 'o', 'u']
	all_tones = first_tone + second_tone + third_tone + fourth_tone

	words.map do |w|
		tone_for_word = w.split('').select {|l| all_tones.include? l}.map do |tone|
			if first_tone.include? tone
				"55" 
			elsif second_tone.include? tone
				"35" 
			elsif third_tone.include? tone
				"214" 
			elsif fourth_tone.include? tone
				"51"
			else
				"0"
			end
		end

		if tone_for_word.empty?
			tone_for_word = "0"
		end

		tone_for_word
	end.flatten
end
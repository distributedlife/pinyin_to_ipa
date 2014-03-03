require "./ipa-lookup.rb"

def as_ipa words, tones
	a = ['ā', 'á', 'ǎ', 'à', 'a']
	e = ['ē', 'é', 'ě', 'è', 'e']
	i = ['ī', 'í', 'ǐ', 'ì', 'i']
	o = ['ō', 'ó', 'ǒ', 'ò', 'o']
	u = ['ū', 'ú', 'ǔ', 'ù', 'u', 'ǚ']

	#remove tone information from word
	without_tones = words.map do |word|
		word.split('').map do |letter|
			if a.include? letter
				"a"
			elsif e.include? letter
				"e"
			elsif i.include? letter
				"i"
			elsif o.include? letter
				"o"
			elsif u.include? letter
				"u"			
			else
				letter
			end
		end.join
	end

	#Special rules
	without_tones.each_with_index do |word, index|		
		if word == "yi" and tones[index] == "55" && tones[index + 1].nil?
			# if yi55 derp51 then it35 derp51
			if tones[index + 1] == "51" 
				tones[index] = "35"
			end
			# if yi55 [55, 35, 214] then yi51 [55, 35, 214]
			if (tones[index + 1] == "55" || tones[index + 1] == "35" || tones[index + 1] == "214")
				tones[index] = "51"
			end
		end
		# if bu51 derp51 then bu35 derp51
		if word == "bu" and tones[index] == "51" && tones[index + 1] == "51" 
			tones[index] = "35"
		end
		# [1 | 2] [2] [*] ⇒ [1 | 2] [1] [*]
		if tones[index] == "35" and !tones[index - 1].nil? and !tones[index + 1].nil? and (tones[index - 1] == "55" || tones[index - 1] == "35")
			tones[index] = "55"
		end

		#if 214 214 then turn into 35 214
		#if 214 214 214 then turn into 214 35 214
		#if 214 214 214 214 then turn into 35 214 35 214
		if tones[index] == "214" && !tones[index + 1].nil?
			in_a_row = 1
			while(!tones[index + in_a_row].nil?) do
				if tones[index + in_a_row] == "214"
					in_a_row = in_a_row + 1
				else
					break
				end
			end

			if (in_a_row % 2) == 0
				#even
				(00..(in_a_row - 1)).each do |i|
					if ((i + 1) % 2) == 1
						tones[index + i] = "35"
					end
				end
			else
				#odd
				(00..(in_a_row - 1)).each do |i|
					if ((i + 1) % 2) == 0
						tones[index + i] = "35"
					end
				end
			end

			#if 214 !214 then turn into 21 !214
			if in_a_row == 1 and tones[index + 1] != "214"
				tones[index] = "21"
			end
		end
	end

	result = []
	#convert to IPA; try to convert with tone first
	without_tones.each_with_index do |word, index|
		if ipa_lookup["#{word}#{tones[index]}"].nil?
			result << ipa_lookup[word]
		else
			result << ipa_lookup["#{word}#{tones[index]}"]
		end
	end

	#stitch on tones
	result.each_with_index do |ipa, index| 
		result[index] = "#{ipa}#{tones[index]}"
	end
end
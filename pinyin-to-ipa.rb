#!/usr/bin/env ruby
require "rubygems"
require "./as_ipa.rb"
require "./word_tone_number.rb"

def print_ipa_from_pinyin pinyin
	words = pinyin.split(" ")

	ipa_with_numbers = as_ipa(words, tone_numbers(words)).join(" ")

	ipa_with_numbers.gsub!("1", "˩")
	ipa_with_numbers.gsub!("2", "˨")
	ipa_with_numbers.gsub!("3", "˧")
	ipa_with_numbers.gsub!("4", "˦")
	ipa_with_numbers.gsub!("5", "˥")
	#TODO: Change the 0 to the neutral tone as per this page: http://en.wikipedia.org/wiki/Standard_Chinese_phonology#Neutral_tone
	ipa_with_numbers.gsub!("0", "")
	#TODO: Other rules associated with with stressed syllables change the pronunciation: http://en.wikipedia.org/wiki/Standard_Chinese_phonology#Syllable_reduction
	#TODO: Remaining rules to do with yi and bu: http://en.wikipedia.org/wiki/Standard_Chinese_phonology#Tone_sandhi

	begin
		$stdout.puts ipa_with_numbers
	rescue Errno::EPIPE
    	exit(74)
  	end
end

STDIN.each do |pinyin|
	print_ipa_from_pinyin pinyin
end

print_ipa_from_pinyin(ARGV[0]) unless ARGV[0].nil?
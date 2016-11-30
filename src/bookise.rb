#!/usr/bin/ruby

text1 = File.open('aiai.out_sm0_seed-date').readlines.sort.map { |k| k.split(' ')[1..-1].join(' ') }
text2 = File.open('aiai.out_sm1_bs1').readlines.sort.map { |k| k.split(' ')[1..-1].join(' ') }

unks = ['unknown', 'nameless', 'strange', 'obscure', 'mysterious', 'indiscernible', 'esoteric']
conj = ['and', 'but', 'or', 'yet']

lines = []
old_line = ""

text1.each_index do |i|
	line = text2[i]
	if line.match(/UNK/) or line[0..5] == old_line[0..5] then
		line = text1[i]
	end
	while line.match(/UNK/) do
		line.sub!(/UNK/, unks.sample)
	end
	lines << line
	old_line = line 
end

sentences = []

while not lines.empty? do
	if lines.size >= 2 and rand(2) == 0 then
		sentences << "#{lines.shift}, #{conj.sample} #{lines.shift}.".capitalize
	elsif lines.size >= 2 and rand(3) == 0 then
		sentences << "#{lines.shift}; #{lines.shift}.".capitalize
	else
		sentences << "#{lines.shift}.".capitalize
	end
end

paragraphs = []

while not sentences.empty? do
	length = 3 + rand(3)
	length = sentences.size if sentences.size < length
	if sentences.size >= length then
		paragraphs << sentences[0, length].join(' ')
		sentences = sentences[length..-1]
	else
		next
	end
end

chapters = []
chapter_titles = []

while not paragraphs.empty? do
	length = 2000 + rand(4000)
	chapter = paragraphs.shift
	while chapter.split(/ /).size < length and not paragraphs.empty? do
		chapter = "#{chapter}\\par\n#{paragraphs.shift}"
	end
	chapters << chapter
	chapter_titles << chapter.split(' ').inject(Hash.new(0)) { |hash, word|
		word_fix = word.downcase.gsub(/[\.,;]/, '')
		hash[word_fix] += 1 if word_fix.size > 5 and not chapter_titles.include?(word_fix)
		hash
	}.to_a.max_by { |pair| pair[1] }.first
end

#chapter_titles.each_with_index do |title, i|
#	puts "Chapter #{i + 1}: #{title.capitalize}"
#end

print File.open('aiai.tex_start').read

chapters.each_with_index do |chapter, i|
	puts "\\chapter{#{chapter_titles[i].capitalize}}"
	puts chapter
end


print File.open('aiai.tex_end').read

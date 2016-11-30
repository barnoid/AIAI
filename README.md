# AIAI
NaNoGenMo 2016 novel from neural net captioned stills from the movie A.I.

# Method

* I ripped the DVD of "A.I. Artificial Intelligence".
* Then extracted 5036 stills from the file (frame rate of 0.6 per second) with Avconv.
* Using https://github.com/karpathy/neuraltalk2 I ran two passes over the images, first with sample_max set to 1, which produces more accurate captions (and more repitition), then with sample_max set to 0, which is less accurate but more "imaginative".
* The neural network has a tendency to fail and produce the string "UNK" as part of the caption, more so with sample_max 1.
* So I loop over each line in the accurate text, if it has an "UNK" or the first five characters are the same as the previous line then replace it with the sample_max 0 text.
* Any remaining UNKs I replace from a list of synonyms of "unknown".
* Then I build sentences from those lines, possibly combining two with a conjunction or a semicolon.
* Then I make paragraphs from multiple sentences.
* Then chapters from a bunch of paragraphs.
* The chapter titles are the most common five letter or more word in the chapter that's not previously been a chapter title.
* I put the output into a LaTeX template from here: https://www.overleaf.com/latex/templates/fiction-novel/pjdthvgdtsfy
* Then run pdflatex to produce the PDF.

# Result

https://github.com/barnoid/AIAI/blob/master/aiai.pdf

I'm afraid it's not very easy to extract any sense of the original film from the text. It does mention teddy bears and children sometimes, they seem to be in the film (I've not actually watched it). Mostly it reveals the neural net's training set's (MS COCO) strong emphasis on cell phones, kitchens, bathrooms and people in suits. The start and end are quite a bit more fanciful than the rest because the opening and closing credits (including several completely black frames) flummox the sample_max 1 run, resulting in a lot of UNKs.

Possibly a more accutate auto-novelisation would be possible with more selective choice of images. And I wonder about better chapter splitting based on some kind moving window that captures the broad topic across a chunk of text. It does seem to have sections about teeth cleaning, taking selfies, eating, etc. They probably correspond to scenes in the film. Perhaps next year.

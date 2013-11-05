all: tex

tex: mdoering_writeup.pdf
	evince $<

%.pdf: %.tex
	pdflatex $<
	

.PHONY: tex

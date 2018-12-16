
TARFILE = ../layoutengine-deposit-$(shell date +'%Y-%m-%d').tar.gz
# For building on my office desktop
# Rscript = ~/R/r-devel/BUILD/bin/Rscript
Rscript = Rscript

%.xml: %.cml %.bib
	# Protect HTML special chars in R code chunks
	$(Rscript) -e 't <- readLines("$*.cml"); writeLines(gsub("str>", "strong>", gsub("<rcode([^>]*)>", "<rcode\\1><![CDATA[", gsub("</rcode>", "]]></rcode>", t))), "$*.xml")'
	$(Rscript) toc.R $*.xml
	$(Rscript) bib.R $*.xml

%.Rhtml : %.xml
	# Transform to .Rhtml
	xsltproc knitr.xsl $*.xml > $*.Rhtml

%.html : %.Rhtml
	# Use knitr to produce HTML
	$(Rscript) knit.R $*.Rhtml

docker:
	# Special ./make-report shell script to bring up Xvfb
	sudo docker run -v $(shell pwd):/home/work/ -w /home/work --rm pmur002/layoutengine ./make-report

web:
	make docker
	cp -r ../layoutengine-report/* ~/Web/Reports/layoutengine/intro/

zip:
	make docker
	tar zcvf $(TARFILE) ./*

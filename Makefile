default: gitbook

figures:
	cd figs; latexmk statespacemodels.tex
	pdfcrop figs/statespacemodels.pdf figs/statespacemodels.pdf
	pdftoppm figs/statespacemodels.pdf figs/statespacemodels -png -rx 300 -ry 300
	cd figs; latexmk pegelstable.tex
	pdfcrop figs/pegelstable.pdf figs/pegelstable.pdf
	pdftoppm figs/pegelstable.pdf figs/pegelstable -png -rx 300 -ry 300
	
gitbook:
	Rscript -e 'capture.output(library(fpp3), type="message", file="startuphtml.txt")'
	sed -i -f htmlstartup.sed startuphtml.txt
	Rscript -e 'bookdown::render_book("index.Rmd", "bookdown::gitbook", quiet=FALSE)'
	sed -i -f htmlreplace.sed public/*.html

deploy:
	cp .htaccess public
	cp 404.html public
	cp -r extrafiles public/
	rsync -zrvce 'ssh -p 18765' public/ u192-zw4zvui1lqsb@m80.siteground.biz:www/otexts.com/public_html/fppsp

clean:
	rm -rf public
	rm -rf _bookdown_files

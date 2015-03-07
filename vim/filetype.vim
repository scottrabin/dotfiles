" my filetype file
if exists("did_load_filetypes")
	finish
endif

augroup filetypedetect
	" add recognition for cljx as clojure files
	autocmd BufNewFile,BufRead *.cljx setfiletype clojure

	" ECMAScript 6 as Javascript
	autocmd BufNewFile,BufRead *.es6 setfiletype javascript
augroup END

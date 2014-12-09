" my filetype file
if exists("did_load_filetypes")
	finish
endif

augroup filetypedetect
	" add recognition for cljx as clojure files
	autocmd BufNewFile,BufRead *.cljx setfiletype clojure
augroup END

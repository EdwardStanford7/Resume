website:
	ls
	TYPST_FONT_PATHS=./fonts typst compile resume.typ
	ls
	mv resume.pdf docs/index.pdf
	ls
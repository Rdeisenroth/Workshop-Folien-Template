all: clean compile clean

define compile_latex
	@latexmk --shell-escape -synctex=1 -interaction=nonstopmode -file-line-error -lualatex *.tex
endef

define add_name_suffix
	@for file in *$(1); do \
		mv "$$file" "$${file%$(1)}$(2)$(1)"; \
	done
endef

compileRegular:
	@rm -f options.cfg
	@echo "Compiling Regular documend..."
	$(call compile_latex)
	@mkdir -p build
	@mv *.pdf build

compileDarkMode:
	@echo "\PassOptionsToPackage{dark_mode}{algo-common}" > options.cfg
	@echo "Compiling Dark Mode..."
	$(call compile_latex)
	$(call add_name_suffix,.pdf,-darkmode)
	@mkdir -p build
	@mv *.pdf build

compile: compileRegular compileDarkMode

clean:
	@echo "Cleaning..."
	@latexmk -C
	@rm -f options.cfg
	@rm -f *.pdf

cleanBuild:
	@echo "Cleaning build..."
	@rm -rf build

cleanAll: clean cleanBuild

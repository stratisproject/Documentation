# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SPHINXPROJ    = StratisAcademy
SOURCEDIR     = source
BUILDDIR      = ../build
PIP           = pip
GIT           = git

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	rm -rf temp/
	rm -rf source/Developer\ Resources/Pystratis\ Reference/source/
	mkdir -p temp/
	mkdir -p source/Developer\ Resources/Pystratis\ Reference/source/
	@$(GIT) clone https://github.com/stratisproject/pyStratis.git temp/pyStratis/
	@$(PIP) install -r temp/pyStratis/requirements.txt
	cp -R temp/pyStratis/doc_build/source/ source/Developer\ Resources/Pystratis\ Reference/source/
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
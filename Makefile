# Certain things ripped off from jessfraz/dotfiles
.PHONY: all setup bin dotfiles test shellcheck

OS := $(shell uname -s)

all: bin dotfiles

setup:
	if test -f $(OS)/setup.sh ; then \
		echo == Setup $(OS); \
		./$(OS)/setup.sh; \
	fi;

bin:
	mkdir -p $(HOME)/bin && \
	for file in $(shell find $(CURDIR)/bin -type f -not -name '.*'); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/bin/$$f; \
	done; \
	for file in $(shell find $(CURDIR)/$(OS)/bin -type f -not -name '.*'); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/bin/$$f; \
	done;

dotfiles:
	# link global and OS specific dotfiles
	for file in $(shell find $(CURDIR) -depth 1 -name ".*" -not -name ".git" -not -name ".keep" -not -name ".travis.yml"); do \
		f=$$(basename $$file); \
	  ln -sfn $$file $(HOME)/$$f; \
	done; \
  for file in $(shell find $(CURDIR)/$(OS) -name ".*"); do \
		f=$$(basename $$file); \
	  ln -sfn $$file $(HOME)/$$f; \
	done;


# if this session isn't interactive, then we don't want to allocate a
# TTY, which would fail, but if it is interactive, we do want to attach
# so that the user can send e.g. ^C through.
INTERACTIVE := $(shell [ -t 0 ] && echo 1 || echo 0)
ifeq ($(INTERACTIVE), 1)
	DOCKER_FLAGS += -t
endif

test: shellcheck

shellcheck:
	docker run --rm -i $(DOCKER_FLAGS) \
		--name df-shellcheck \
		-v $(CURDIR):/usr/src:ro \
		--workdir /usr/src \
		r.j3ss.co/shellcheck ./test.sh

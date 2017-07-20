# Certain things ripped off from jessfraz/dotfiles
.PHONY: all bin dotfiles etc test shellcheck

OS := $(shell uname -s)

all: bin etc dotfiles

linux-only:
ifneq ($(OS), Linux)
	$(error only supported on linux)
endif

dotfiles:
	# just link all. OSX gets extra files it doesnt care about but whatever
	find $(CURDIR) -name ".*" -not -name ".git" -not -name ".travis.yml" | \
	while read -r file; do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done;

bin: linux-only
	mkdir -p $(HOME)/bin && \
	find $(CURDIR)/bin -type f -not -name ".*" | \
	while read -r file; do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/bin/$$f; \
	done;

etc: linux-only
	find $(CURDIR)/etc -type f | \
	while read -r file; do \
		f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
		sudo cp $$file $$f; \
		sudo chown root:root $$f; \
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

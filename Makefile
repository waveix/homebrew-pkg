.PHONY: help init lint tools \
	gen-agents gen-cc clear-cc \

.SILENT: help init lint \
	gen-agents gen-cc clear-cc \

all: help

IGNORE_DIRS := -name "vendor" \
            -o -name "node_modules" \
            -o -name ".git" \
            -o -name "dist" \
            -o -name "build" \
            -o -name "out" \
            -o -name "bin" \
            -o -name "pkg" \
            -o -name ".cache"

define AGENTS_TEMPLATE
# AGENTS.md

All conventions for this folder live in **[`README.md`](./README.md)** — the single
source of truth for people and agents alike.

**Before adding or editing anything here, read [`README.md`](./README.md) — and if it has a
[For Agents](./README.md#for-agents) section, follow that too.**

Don't duplicate the README here — extend the README instead.
endef
export AGENTS_TEMPLATE

# ======================================
## List commands:
# ======================================
help:
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

# ======================================
## ***** -> System *****
# ======================================
init: ## Init git-hooks and autoupdate checks lint, fmt, etc.
	pre-commit install
	pre-commit autoupdate

	git submodule update --init --recursive

lint: ## Check all files
	pre-commit install
	pre-commit run --all-files

tools: ## Check tools
	pre-commit --version

	docker -v
	docker buildx version
	hadolint -v

# ======================================
## ***** -> LLM *****
# ======================================
gen-agents: SHELL := /bin/bash
gen-agents: ## Create AGENTS.md next to every README.md (skips existing)
	@find . -type d \( $(IGNORE_DIRS) \) -prune -o -name "README.md" -print0 | { \
		created=0; \
		while IFS= read -r -d '' r; do \
			f="$$(dirname "$$r")/AGENTS.md"; \
			if [ ! -e "$$f" ]; then \
				printf '%s\n' "$$AGENTS_TEMPLATE" > "$$f"; \
				echo "📝 Created: $$f"; \
				created=$$((created + 1)); \
			fi; \
		done; \
		if [ "$$created" -eq 0 ]; then echo "📭 Every README.md already has an AGENTS.md."; \
		else echo "✅ Created $$created AGENTS.md file(s)."; fi; \
	}

gen-cc: SHELL := /bin/bash
gen-cc: gen-agents ## Init files for Claude Code
	@find . -type d \( $(IGNORE_DIRS) \) -prune -o -name "AGENTS.md" -print0 | { \
		while IFS= read -r -d '' a; do \
			l="$$(dirname "$$a")/CLAUDE.md"; \
			ln -sf AGENTS.md "$$l"; \
			echo "🔗 Linked: $$l"; \
		done; \
	}
	@echo "✅ All links for Claude Code generated successfully."

clear-cc: SHELL := /bin/bash
clear-cc: ## Remove generated AGENTS.md and CLAUDE.md links
	@cleaned=0; \
	while IFS= read -r -d '' l; do \
		rm -f "$$l"; echo "🧹 Removed link: $$l"; cleaned=$$((cleaned + 1)); \
	done < <(find . -type d \( $(IGNORE_DIRS) \) -prune -o -name "CLAUDE.md" -type l -print0); \
	while IFS= read -r -d '' a; do \
		if [ "$$(cat "$$a")" = "$$AGENTS_TEMPLATE" ]; then \
			rm -f "$$a"; echo "🧹 Removed: $$a"; cleaned=$$((cleaned + 1)); \
		else \
			echo "⏭️  Kept (custom): $$a"; \
		fi; \
	done < <(find . -type d \( $(IGNORE_DIRS) \) -prune -o -name "AGENTS.md" -print0); \
	if [ "$$cleaned" -eq 0 ]; then echo "📭 Nothing to clean."; \
	else echo "🧹 Cleaned $$cleaned file(s)."; fi


# 3. In [`waveix/pkg`](https://github.com/waveix/homebrew-pkg), run `make bump-ver FORMULA=Formula/ffagent.rb` and push

#3. Compute the tarball sha:
#   ```sh
#   curl -fsSL https://gitlab.com/waveix/pkg-ffagent/-/archive/v0.1.1/pkg-ffagent-v0.1.1.tar.gz | shasum -a 256
#   ```

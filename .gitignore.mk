##
## EPITECH PROJECT, 2024
## Paradigm Pool day 12
## File description:
## .gitignore Makefile
##

define \n


endef
define $(IGNORE_FILE)_CONTENT
##
## EPITECH PROJECT, $(shell date +%Y)
## $($(NAME)_DISPLAY)
## File description:
## $(IGNORE_FILE)
##

# Ignore folder
.idea

# Ignore object files
$($(NAME)_MAIN_OBJ)
$($(NAME)_OBJS:%=%${\n})
$($($(NAME)_TESTS)_OBJS:%=%${\n})

# Ignore dependency files
$($(NAME)_MAIN_DEP)
$($(NAME)_DEPS:%=%${\n})
$($($(NAME)_TESTS)_DEPS:%=%${\n})

# Ignore binary files
$(NAME)
$($(NAME)_TARGET)
$($(NAME)_TESTS)
a.out

# Ignore logs and reports
*.gc*
vgcore.*

# Ignore coding-style logs
$(CODING_STYLE_LOG)

# Ignore temporary files
*tmp*
*~
\#*#
.#*
*.swp

# Miscellanous
$(IGNORED_FILES:%=%${\n})
endef

$(IGNORE_FILE):
ifneq ($(wildcard $(IGNORE_FILE)),)
	@-echo 'Updating $@ file...'
else
	@-echo 'Generating $@ file...'
endif
	@echo -e "$(subst ${\n},\n,$($@_CONTENT))" > $@
	@sed -i -E 's/^ //g' $@

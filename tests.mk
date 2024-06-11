##
## EPITECH PROJECT, 2024
## Paradigm Pool day 12
## File description:
## Tests Makefile
##

ifdef $(NAME)_LINK
$($(NAME)_TESTS)_REQUIREMENTS	:=	$($(NAME)_OBJS)
else
$($(NAME)_TESTS)_REQUIREMENTS	:=	$($(NAME)_TARGET)
$($(NAME)_TESTS):			LIBS += $(NAME)
endif
$($(NAME)_TESTS):			LIBS += criterion
$($(NAME)_TESTS):			CXXFLAGS += --coverage
$($(NAME)_TESTS):			$($($(NAME)_TESTS)_OBJS) $(IGNORE_FILE)	\
							$($($(NAME)_TESTS)_REQUIREMENTS)
	@-echo -e '\nLinking $@ binary...'
	@$(CXX) $(CXXFLAGS) -o $@ $($($(NAME)_TESTS)_OBJS) $($(NAME)_TESTS_SRCS)	\
	$(LDLIBS) $(LDFLAGS)

$($($(NAME)_TESTS)_OBJS):	CXXFLAGS := $(filter-out --coverage,$(CXXFLAGS))

$($(NAME)_TESTS)_SUITES		:=	$(TEST_SUITES:%=--filter '%/*')
$($(NAME)_TESTS)_COMMAND	=	./$($(NAME)_TESTS) --verbose			\
								$(TESTFLAGS) $($($(NAME)_TESTS)_SUITES)	\
								&& find . -type f -name '*.gc*'			\
								-exec mv -f -- {} tests/coverage/ \;

test:						$($(NAME)_TESTS)
	@$($($(NAME)_TESTS)_COMMAND)

tests_run:					TESTFLAGS += --always-succeed
tests_run:					rm_gcno $($(NAME)_TESTS)
	@-echo 'Running tests...'
	@echo 'Command: $($($(NAME)_TESTS)_COMMAND)'
	@$($($(NAME)_TESTS)_COMMAND)

tests_debug:				TESTFLAGS += --always-succeed
tests_debug:				CXXFLAGS += -g
tests_debug:				$($(NAME)_TESTS)
	@-valgrind --trace-children=yes $($($(NAME)_TESTS)_COMMAND)

coverage:					rm_gcno tests_run
	@gcovr --exclude $(TESTS_DIR)
	@gcovr --exclude $(TESTS_DIR) --branches

rm_gcno:
	@find \( -name '*~' -o -name 'vgcore.*' -o -name '*.gc*' \) -delete
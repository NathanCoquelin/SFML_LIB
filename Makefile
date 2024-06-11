##
## EPITECH PROJECT, 2024
## arcade
## File description:
## Makefile
##

.SECONDEXPANSION:
NAME					:=	arcade
$(NAME)_LINK			:=	1
ifdef $(NAME)_LINK
$(NAME)_TARGET			:=	$(NAME)
else
$(NAME)_TARGET			:=	$(NAME:%=lib%.a)
endif
$(NAME)_DISPLAY			:=	Spice BootStrap
$(NAME)_TESTS			:=	$(NAME)_tests

NCURSES_EXEC			:=	lib/arcade_ncurses.so

SDL_EXEC				:=	lib/arcade_sdl2.so

TESTS_DIR				:=	tests/
BUILD_DIR				:=	build

LIB 					:= $(NAME)_LIB

SRCS				:=	$(addprefix src/, $(addsuffix .cpp,			\
							Main									\
							$(addprefix helper/,					\
								Utility								\
							)										\
							$(addprefix GameObject/,				\
								GameObject							\
								Texture								\
							)										\
							$(addprefix Core/,						\
								DLLoader							\
								Core								\
							)										\
							$(addprefix lib/,						\
								$(addprefix Graphic/,				\
									$(addprefix NCurses/,			\
										entryPoint					\
										NCursesGraphic				\
										Event						\
										MainMenu					\
									)								\
									$(addprefix SDL/,				\
										SDL							\
									)								\
								)									\
								$(addprefix Game/,					\
									$(addprefix Snake/,				\
									)								\
								)									\
							)										\
						))

$(SRCS)_OBJS			:=	$(patsubst %.cpp,$(BUILD_DIR)/%.o,$(SRCS))

$(NAME)_SRCS			:=	$(filter-out src/lib/%, $(SRCS))

$(NAME)_OBJS			:=	$(patsubst %.cpp,$(BUILD_DIR)/%.o,$($(NAME)_SRCS))

NCURSES					:=	$(LIB)_NCURSES

$(NCURSES)_SRCS			:=	$(filter src/lib/Graphic/NCurses/%, $(SRCS))

$(NCURSES)_OBJS			:=	$(patsubst %.cpp,$(BUILD_DIR)/%.o,$($(NCURSES)_SRCS))

SDL						:=	$(LIB)_SDL

$(SDL)_SRCS				:=	$(filter src/lib/Graphic/SDL/%, $(SRCS))

$(SDL)_OBJS				:=	$(patsubst %.cpp,$(BUILD_DIR)/%.o,$($(SDL)_SRCS))

$(NAME)_TESTS_SRCS		:=	$(filter-out src/Main.cpp, $($(NAME)_SRCS))
$(NAME)_TESTS_SRCS		+=	$(shell find tests/ -type f -name '*.cpp')

IGNORE_FILE				:=	.gitignore
IGNORED_FILES			:=	compile_commands.json .cache build/
ifndef $(NAME)_LINK
IGNORED_FILES			+=  $($(NAME)_MAIN_SRC)
endif
CODING_STYLE_LOG		:=	coding-style-reports.log

$(NAME)_MAIN_OBJ        :=  $(patsubst %.cpp,$(BUILD_DIR)/%.o,$($(NAME)_MAIN_SRC))
$(NAME)_OBJS            :=  $(patsubst %.cpp,$(BUILD_DIR)/%.o,$($(NAME)_SRCS))
$($(NAME)_TESTS)_OBJS   :=  $(patsubst %.cpp,$(BUILD_DIR)/%.o,$($($(NAME)_TESTS)_SRCS))

$(NAME)_MAIN_DEP        :=  $(patsubst %.cpp,$(BUILD_DIR)/%.d,$($(NAME)_MAIN_SRC))
$(NAME)_DEPS            :=  $(patsubst %.cpp,$(BUILD_DIR)/%.d,$($(NAME)_SRCS))
$($(NAME)_TESTS)_DEPS   :=  $(patsubst %.cpp,$(BUILD_DIR)/%.d,$($($(NAME)_TESTS)_SRCS))

LIBS					:=	$(COMPILED_LIBS) ncurses
PROJECT_INCLUDE_DIRS	+=	./ include/
ifndef $(NAME)_LINK
LIB_DIRS				+=	$(dir $($(NAME)_TARGET))
endif
RM						:=	rm -f
AR						:=	ar
ARFLAGS					:=	rcs
CXX						:=	g++
CXXFLAGS				=	$(PROJECT_INCLUDE_DIRS:%=-iquote %)				\
							$(INCLUDE_DIRS:%=-I%)							\
							-std=c++20										\
							-W -Wall -Wextra -Werror

LDLIBS					=	$(shell echo $(LIBS:%=-l%) | tr '[:upper:]'		\
							'[:lower:]')

LDLIBS += -lsfml-graphics -lsfml-window -lsfml-system

LDFLAGS					=	$(LIB_DIRS:%=-L%)

all:						$(IGNORE_FILE) graphicals $($(NAME)_TARGET)
	@:

debug:						CXXFLAGS += -g
debug:						all

include $(IGNORE_FILE).mk

$($(NAME)_TARGET): $($(NAME)_OBJS)
	@-echo -e '\nLinking \t\t\t\t\t\t$@ binary'
	@$(CXX) $(CXXFLAGS) -o $@ $^ $(LDLIBS) $(LDFLAGS) -ldl


COUNT = 0
CPP_FILES := $(filter %.cpp,$(SRCS))
MAX_FILES := $(words $(CPP_FILES))

LIB_CXXFLAGS := -fPIC

$(BUILD_DIR)/%.o: %.cpp | create_dirs
	@-echo -e '\nCompiling \t\t\t\t\t\t$<                        '
	@$(CXX) -c $(CXXFLAGS) $(if $(findstring /lib/,$<),$(LIB_CXXFLAGS),) $< -o $@
	@$(eval COUNT=$(shell echo $$(($(COUNT) + 1))))
ifneq (,$(findstring j, $(MAKEFLAGS)))
	@echo "$c =====> $@"
else
	@python3 bar.py --stepno=$(COUNT) --nsteps=$(MAX_FILES)
endif

DIRS := $(sort $(dir $(addprefix $(BUILD_DIR)/,$(basename $(SRCS)))))

create_dirs:
	$(shell mkdir -p $(DIRS))

-include $($(NAME)_MAIN_DEP) $($(NAME)_DEPS) $($($(NAME)_TESTS)_DEPS)

include tests.mk


$(NCURSES): $($(NCURSES)_OBJS)
	@$(CXX) -Wall -shared $($(NCURSES)_OBJS) -o $(NCURSES_EXEC)

$(SDL): $($(SDL)_OBJS)
	@$(CXX) -Wall -shared $($(SDL)_OBJS) -o $(SDL_EXEC) `sdl2-config --cflags --libs` -lSDL2 -lSDL2_mixer -lSDL2_image -lSDL2_ttf

graphicals: $(NCURSES) $(SDL)

coding-style:				fclean
	@-echo 'Checking coding style...'
	@coding-style.sh -o $(CODING_STYLE_LOG)

clean:
	@$(RM) $($(NAME)_MAIN_OBJ) $($(NAME)_OBJS) $($($(NAME)_TESTS)_OBJS)	\
	$($(NAME)_MAIN_DEP) $($(NAME)_DEPS) $($($(NAME)_TESTS)_DEPS) \
	$($(NCURSES)_OBJS) $(NCURSES_EXEC)
	@-echo -e 'Cleaned-up objects and dependency files.'
	@find \( -name '*~' -o -name 'vgcore.*' -o -name '*.gc*'	\
	-o -name '$(CODING_STYLE_LOG)' \) -delete
	@-echo 'Cleaned-up unecessary files.'

fclean:						clean
	@$(RM) $($(NAME)_TARGET) $(NAME)
	@-echo 'Program deleted.'
	@$(RM) $($(NAME)_TESTS)
	@-echo 'Test program deleted.'

re:							fclean all

re_tests:					fclean tests_run

.PHONY:						all debug tests_run tests_debug		\
							clean fclean re re_tests libs		\
							coverage coding-style $(IGNORE_FILE)

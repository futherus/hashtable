CXX      := gcc
CXXFLAGS := -g -std=c++17 -Wall -Wextra -Weffc++ -Wc++0x-compat -Wc++11-compat -Wc++14-compat -Waggressive-loop-optimizations -Walloc-zero -Walloca -Walloca-larger-than=8192 -Warray-bounds -Wcast-align -Wcast-qual -Wchar-subscripts -Wconditionally-supported -Wconversion -Wctor-dtor-privacy -Wdangling-else -Wduplicated-branches -Wempty-body -Wfloat-equal -Wformat-nonliteral -Wformat-security -Wformat-signedness -Wformat=2 -Wformat-overflow=2 -Wformat-truncation=2 -Winline -Wlarger-than=8192 -Wvla-larger-than=8192 -Wlogical-op -Wmissing-declarations -Wnon-virtual-dtor -Wopenmp-simd -Woverloaded-virtual -Wpacked -Wpointer-arith -Wredundant-decls -Wrestrict -Wshadow -Wsign-promo -Wstack-usage=8192 -Wstrict-null-sentinel -Wstrict-overflow=2 -Wstringop-overflow=4 -Wsuggest-attribute=noreturn -Wsuggest-final-types -Wsuggest-override -Wswitch-default -Wswitch-enum -Wsync-nand -Wundef -Wunreachable-code -Wunused -Wvariadic-macros -Wno-literal-suffix -Wno-missing-field-initializers -Wnarrowing -Wno-old-style-cast -Wvarargs -Waligned-new -Walloc-size-larger-than=1073741824 -Walloc-zero -Walloca -Walloca-larger-than=8192 -Wcast-align=strict -Wdangling-else -Wduplicated-branches -Wformat-overflow=2 -Wformat-truncation=2 -Wmissing-attributes -Wmultistatement-macros -Wrestrict -Wshadow=global -Wsuggest-attribute=malloc -fcheck-new -fsized-deallocation -fstack-check -fstrict-overflow -flto-odr-type-merging -fno-omit-frame-pointer

# not overwrite OBJDIR if recursive
export OBJDIR ?= $(CURDIR)/obj/

# for recursive compiling
all: list hashtable

#------------------------------------------------------------------------------
hashtable: | $(OBJDIR)
	@ cd src && $(MAKE)

list: | $(OBJDIR)
	@ cd include/List && $(MAKE)

$(OBJDIR):
	mkdir $(OBJDIR)
#------------------------------------------------------------------------------

BINDIR := $(CURDIR)/bin/
TARGET := $(BINDIR)test_ht
VPATH  := tests/ utils/ utils/logs

TEST        := main.cpp test1.cpp test2.cpp test3.cpp test4.cpp
TESTOBJ     := $(addprefix $(OBJDIR), $(TEST:.cpp=.o))
RUN_TEST    := utils/run_tests.py
TEST_OUTDIR := test_output/

SRC := hash.cpp logs.cpp stats.cpp text.cpp
OBJ := $(addprefix $(OBJDIR), $(SRC:.cpp=.o) List.o Hashtable.o)

test: build_test | $(TEST_OUTDIR)
	python $(RUN_TEST) $(TEST_OUTDIR) 	$(addprefix $(BINDIR), $(basename $(TEST)))

build_test: list hashtable $(OBJ) $(TESTOBJ) | $(BINDIR)
	$(foreach var, $(TESTOBJ), 		  									\
		$(CXX) $(OBJ) $(var) -o $(BINDIR)$(notdir $(basename $(var));) 	\
	)

$(OBJDIR)%.o : %.cpp | $(OBJDIR)
	@echo Compiling $@
	@$(CXX) -c $^ -o $@ $(CXXFLAGS)

$(BINDIR):
	mkdir $(BINDIR)

$(TEST_OUTDIR):
	mkdir $(TEST_OUTDIR)

clean:
	rm -rf $(OBJDIR) $(BINDIR) graphviz_* log.html
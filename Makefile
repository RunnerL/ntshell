TOP := .
NTSHELL_PATH := $(TOP)/src/lib

TARGET := ntshell

include toolchain.mk
 
INC := -I$(NTSHELL_PATH)/core \
-I$(NTSHELL_PATH)/util \

CCFLAGS += $(INC)

BUILD_DIR := $(TOP)/build/$(TARGET)
INSTALL_DIR := $(TOP)/install/$(TARGET)
OBJ_DIR := $(BUILD_DIR)/obj
LIB_DIR := $(BUILD_DIR)/lib



SRCS := $(NTSHELL_PATH)/core/ntlibc.c \
$(NTSHELL_PATH)/core/ntshell.c \
$(NTSHELL_PATH)/core/text_editor.c \
$(NTSHELL_PATH)/core/text_history.c \
$(NTSHELL_PATH)/core/vtrecv.c \
$(NTSHELL_PATH)/core/vtsend.c \
$(NTSHELL_PATH)/util/ntopt.c \
$(NTSHELL_PATH)/util/ntstdio.c \

OBJS := $(addprefix $(OBJ_DIR)/,$(SRCS:.c=.o))

all: $(TARGET) $(TARGET)_posix

$(TARGET): lib$(TARGET).a

lib$(TARGET).a: $(OBJS)
	mkdir -p $(LIB_DIR)
	$(AR) csr $(LIB_DIR)/$@ $^
	mkdir -p $(INSTALL_DIR)/lib
	cp $(LIB_DIR)/$@ $(INSTALL_DIR)/lib/$@
	mkdir -p $(INSTALL_DIR)/include/core
	cp $(NTSHELL_PATH)/core/*.h $(INSTALL_DIR)/include/core
	mkdir -p $(INSTALL_DIR)/include/util
	cp $(NTSHELL_PATH)/util/*.h $(INSTALL_DIR)/include/util

$(OBJ_DIR)/%.o: %.c
	mkdir -p $(@D)
	$(CC) -c $< $(CCFLAGS) -o $@

.PHONY: $(TARGET)_posix
$(TARGET)_posix:
	make -f posix.mk NTSHELL_LIB=$(INSTALL_DIR)

clean: clean_posix
	rm -rf $(BUILD_DIR) $(INSTALL_DIR)

clean_posix:
	make -f posix.mk clean


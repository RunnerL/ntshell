TOP := .
NTSHELL_POSIX_PATH := $(TOP)/src/sample/target/posix

TARGET := ntshell_posix

include toolchain.mk

LDFLAGS += -L$(NTSHELL_LIB)/lib/ -lntshell

INC += -I$(NTSHELL_POSIX_PATH) \
-I$(NTSHELL_LIB)/include/core \
-I$(NTSHELL_LIB)/include/util \

CCFLAGS += $(INC)

BUILD_DIR := $(TOP)/build/$(TARGET)
OBJ_DIR := $(BUILD_DIR)/obj
BIN_DIR := $(BUILD_DIR)/bin

SRCS := $(NTSHELL_POSIX_PATH)/main.c \
$(NTSHELL_POSIX_PATH)/uart.c \

OBJS := $(addprefix $(OBJ_DIR)/,$(SRCS:.c=.o))


all: $(TARGET)

$(TARGET): $(OBJS)
	mkdir -p $(BIN_DIR)
	$(CC) $^ -o $(BIN_DIR)/$@ $(LDFLAGS)

$(OBJ_DIR)/%.o: %.c
	mkdir -p $(@D)
	$(CC) -c $< $(CCFLAGS) -o $@

clean:
	rm -rf $(BUILD_DIR)

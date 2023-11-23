# OS specific setup
ID=$(shell . /etc/os-release ; echo $$ID)
ifeq "$(ID)" "debian"
OS=debian
else ifeq "$(ID)" "fedora"
OS=fedora
else
ID_LIKE=$(shell . /etc/os-release ; echo $$ID_LIKE)
ifeq "$(ID_LIKE)" "debian"
OS=debian
else ifeq "$(ID_LIKE)" "fedora"
OS=fedora
else
endif
endif
ifeq "$(OS)" "debian"
QT5_HEADERS=/usr/include/x86_64-linux-gnu/qt5
else ifeq "$(OS)" "fedora"
QT5_HEADERS=/usr/include/qt5
else ifndef OS
$(error OS not supported)
endif
### paths
# sources sub directories
MAIN=/main
# sources
SRC=./src
MAIN_SRC=$(SRC)$(MAIN)
# build
BUILD=./build
# build -> objs
OBJ=$(BUILD)/obj
MAIN_OBJ=$(OBJ)$(MAIN)
# build -> bins
BIN=$(BUILD)/bin
MAIN_BIN=$(BIN)$(MAIN)
# lists
HEADERS=$(MAIN_SRC)/ui_mainwindow.h $(MAIN_SRC)/mainwindow.h
OBJECTS=$(MAIN_OBJ)/moc_mainwindow.o $(MAIN_OBJ)/mainwindow.o $(MAIN_OBJ)/main.o
### commands
# compile arguments
SRC_DEBUG_LINKER=-Xlinker --verbose
SRC_COMPILE_ARGS=-I $(MAIN_SRC) -Wall -Wextra
SRC_COMPILE_ADD_ARGS=-pipe -fPIC -std=gnu++11 -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB -I$(QT5_HEADERS)/mkspecs/linux-g++ -isystem $(QT5_HEADERS) -isystem $(QT5_HEADERS)/QtWidgets -isystem $(QT5_HEADERS)/QtGui -isystem $(QT5_HEADERS)/QtCore
SRC_COMPILE_LINKER_ARGS=-lpthread -lQt5Widgets -lQt5Gui -lQt5Core -lGL
# compilation
COMPILE=g++
SRC_COMPILE=$(COMPILE) $(SRC_COMPILE_ARGS) $(SRC_COMPILE_ADD_ARGS)
# deletion
DELETE=rm -rf
# silent log using printf
LOG=@printf


all:	full-clean build

build:	$(MAIN_BIN)/Ex1

$(MAIN_OBJ)/moc_mainwindow.o:	$(MAIN_SRC)/moc_mainwindow.cpp $(HEADERS)
	$(LOG) '\n\033[42mcreation of the moc_mainwindow object\033[49m\n'
	$(SRC_COMPILE) \
	$(MAIN_SRC)/moc_mainwindow.cpp \
	-c \
	-o $(MAIN_OBJ)/moc_mainwindow.o

$(MAIN_OBJ)/mainwindow.o:	$(MAIN_SRC)/mainwindow.cpp $(HEADERS)
	$(LOG) '\n\033[42mcreation of the mainwindow object\033[49m\n'
	$(SRC_COMPILE) \
	$(MAIN_SRC)/mainwindow.cpp \
	-c \
	-o $(MAIN_OBJ)/mainwindow.o

$(MAIN_OBJ)/main.o:	$(MAIN_SRC)/main.cpp $(HEADERS)
	$(LOG) '\n\033[42mcreation of the main object\033[49m\n'
	$(SRC_COMPILE) \
	$(MAIN_SRC)/main.cpp \
	-c \
	-o $(MAIN_OBJ)/main.o

$(MAIN_BIN)/Ex1:	$(OBJECTS)
	$(LOG) '\n\033[42mcreation of the Ex1 executable\033[49m\n'
	$(SRC_COMPILE) \
	$(OBJECTS) \
	-o $(MAIN_BIN)/Ex1 \
	$(SRC_COMPILE_LINKER_ARGS)

setup:
	$(LOG) '\n\033[42msetup of the directories\033[49m\n'
	mkdir \
	-p \
	$(MAIN_OBJ) \
	$(MAIN_BIN)
	$(LOG) '\n\033[44mmake setup finished\033[49m\n\n'

clean:
	$(LOG) '\n\033[41mdeletion of the object directory\033[49m\n'
	$(DELETE) $(OBJ)/*
	make setup
	$(LOG) '\n\033[44mmake clean finished\033[49m\n\n'

full-clean:
	$(LOG) '\n\033[41mdeletion of ALL the build directories\033[49m\n'
	$(DELETE) $(BUILD)/*
	make setup
	$(LOG) '\n\033[44mmake full-clean finished\033[49m\n\n'

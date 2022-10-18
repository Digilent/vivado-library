COMPILER=
ARCHIVER=
CP=cp
COMPILER_FLAGS=
EXTRA_COMPILER_FLAGS=
LIB=libxil.a

CC_FLAGS = $(COMPILER_FLAGS)
ECC_FLAGS = $(EXTRA_COMPILER_FLAGS)

RELEASEDIR=../../../lib
INCLUDEDIR=../../../include
INCLUDES=-I./. -I${INCLUDEDIR}

LIBSOURCES=*.c *.cpp utility/*.c
INCLUDEFILES:=*.h

OBJECTS=$(addsuffix .o, $(basename $(wildcard *.c) $(wildcard *.cpp) $(wildcard utility/*.c)))

IPNAME=PmodSD

libs: banner ${IPNAME}_libs clean

%.o: %.c
	${COMPILER} $(CC_FLAGS) $(ECC_FLAGS) $(INCLUDES) -o $@ $<

%.o: %.cpp
	${COMPILER} $(CC_FLAGS) $(ECC_FLAGS) $(INCLUDES) -o $@ $<

utility/%.o: utility/%.c
	${COMPILER} $(CC_FLAGS) $(ECC_FLAGS) $(INCLUDES) -o $@ $<

banner:
	echo "Compiling ${IPNAME}..."

${IPNAME}_libs: ${OBJECTS}
	$(ARCHIVER) -r ${RELEASEDIR}/${LIB} ${OBJECTS}

.PHONY: include
include: ${IPNAME}_includes

${IPNAME}_includes:
	${CP} ${INCLUDEFILES} ${INCLUDEDIR}
	if not exist "$(INCLUDEDIR)/utility" md "$(INCLUDEDIR)/utility"
	${CP} utility/*.h $(INCLUDEDIR)/utility

clean:
	rm -rf ${OBJECTS}

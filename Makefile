
OCAML=ocamlc
OCAMLFLAGS= -I +sdl -I +lablgtk2
OCAMLLD= bigarray.cma sdl.cma sdlloader.cma
BIN_NAME=cartastrophe
SOURCES = imageProcessing.ml objMaker.ml interface.ml  main.ml
all: compile
compile:
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -o ${BIN_NAME} ${SOURCES}

clean:
	rm -f *~ *.o *.cm? .
 
# FIN

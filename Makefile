
OCAML=ocamlopt
OCAMLFLAGS= -I +sdl
OCAMLLD= bigarray.cmxa sdl.cmxa sdlloader.cmxa
BIN_NAME=cartastrophe
FILES=*.ml
 
compile: main.ml
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -o ${BIN_NAME} *.ml
 
clean:
	rm -f *~ *.o *.cm? proj
 
# FIN

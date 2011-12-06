
OCAML=ocamlc
OCAMLFLAGS= -I +sdl -I +lablgtk2
OCAMLLD= bigarray.cma lablgtk.cma gtkInit.cmo sdl.cma sdlloader.cma 
BIN_NAME=cartastrophe
SOURCES = imageProcessing.ml objMaker.ml interface.ml  main.ml
INTERFACES= ${SOURCES:.ml=.mli}
.SUFFIXES:.ml .cmi .cmx .mli
.ml.cmx: ${SOURCES}
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -c $<
.ml.mli: ${SOURCES}
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -i $< > ${<:.ml=.mli}
.mli.cmi: ${INTERFACES}
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -c $<

all: link
link:compile
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -o ${BIN_NAME}
compile:${INTERFACES} ${SOURCES}
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -c ${INTERFACES} ${SOURCES}
clean::
	rm -f *~ *.o *.cm? 
usage:
	echo "Usage: make compile|interface|clean|usage"
end:
# FIN

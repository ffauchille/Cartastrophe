
OCAML=ocamlopt
OCAMLFLAGS= -I +sdl -I +lablgtk2
OCAMLLD= bigarray.cmxa lablgtk.cmxa gtkInit.cmx sdl.cmxa sdlloader.cmxa 
BIN_NAME=cartastrophe
SOURCES = imageProcessing.ml objMaker.ml interface.ml  main.ml
INTERFACES= ${SOURCES:.ml=.mli}
CMX=${SOURCES:.ml=.cmx}
CMI=${SOURCES:.ml=.cmi}
.SUFFIXES:.ml .cmi .cmx .mli
.ml.cmx: ${SOURCES} ${CMI}
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -c $<
.ml.mli: ${SOURCES}
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -i $< > ${<:.ml=.mli}
.mli.cmi: ${INTERFACES}
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -c $<

all: link
link:${CMX}
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -o ${BIN_NAME} ${CMX}
compile:${SOURCES}
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -c  ${SOURCES}
clean::
	rm -f *~ *.o *.cm?
exec: link
	${BIN_NAME}
usage:
	echo "Usage: make compile|interface|clean|usage|exec"
end:
# FIN

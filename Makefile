
OCAML=ocamlopt
OCAMLFLAGS= -I +sdl -I +lablgtk2
OCAMLLD= bigarray.cmxa lablgtk.cmxa gtkInit.cmx sdl.cmxa sdlloader.cmxa 
EXEC=cartastrophe
SDIR=src
WDIR=wrk
BDIR=bin
SRC=imageProcessing.ml objMaker.ml interface.ml  main.ml
# Ne pas éditer
makeDir=${shell pwd}
DIR=${makeDir}/${SDIR}
BINDIR=${makeDir}/${BDIR}
WRKDIR=${makeDir}/${WDIR}
SOURCES=${DIR}/${SRC: = ${DIR}/}
INTERFACES=${SOURCES:.ml=.mli}
# CMI=${SRC:.ml=.cmi}
# CMX=${SRC:.ml=.cmx}
CMX=${WRKDIR}/${SRC:.ml=.cmx ${WRKDIR}/}
CMI=${WRKDIR}/${SRC:.ml=.cmi ${WRKDIR}/}

all: preliminaire ${EXEC}
preliminaire:
	mkdir -p ${BINDIR} 
	mkdir -p ${WRKDIR} 
${EXEC}:${CMX}
	cd ${BINDIR}
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -o ${BINDIR}/${EXEC} ${CMX}


.SUFFIXES:.ml .cmi .cmx .mli

.ml.cmx: ${SOURCES} ${CMI}
	cd ${WRKDIR}
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -c $<
.ml.mli: ${SOURCES}
	cd ${DIR}
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} $? -i $< > $*.mli
.mli.cmi: ${INTERFACES}
	cd ${WRKDIR}
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -c $<
clean::
	cd ${WRKDIR}
	rm -f *~ *.o *.cm?>/dev/null
exec: ${EXEC}
	${EXEC}
usage:
	echo "Usage: make compile|interface|clean|usage|exec"
end:
# FIN

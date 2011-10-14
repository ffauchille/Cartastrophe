# TP sdl
 
OCAML=ocamlopt
OCAMLFLAGS= -I +sdl
OCAMLLD= bigarray.cmxa sdl.cmxa sdlloader.cmxa
 
proj: proj.ml
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -o proj proj.ml
 
clean:
	rm -f *~ *.o *.cm? proj
 
# FIN

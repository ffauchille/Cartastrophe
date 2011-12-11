FILES=imageProcessing.ml objMaker.ml fridi.ml interface.ml main.ml
INTERFACES=${FILES:.ml=.mli}
# INTERFACES =
all:
	ocamlopt -I +sdl -I +lablgtk2 -I +lablGL bigarray.cmxa sdl.cmxa sdlloader.cmxa lablgtk.cmxa lablgl.cmxa lablglut.cmxa lablgtkgl.cmxa gtkInit.cmx -o cartastrophe ${INTERFACES} ${FILES} 
exec: all
	./cartastrophe
clean:
	rm -f *.cm? *.o ~* 

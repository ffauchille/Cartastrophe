(* Initialisation de SDL *)
let init () = 
	begin
		Sdl.init [`EVERYTHING];
		Sdlevent.enable_events Sdlevent.all_events_mask;
	end
let width = ref 1024
let height= ref 768
(* On crÅÈe la surface d'affichage en doublebuffering *)
let newDisplay () =(Sdlvideo.set_video_mode (!width) (!height) [`DOUBLEBUF])
let display = ref (newDisplay ())

let setSize w h = width:=w;height:=h;display :=newDisplay () 
(* Affiche une image ‡ l'Ècran *)
let showSurface img = 
	let d = Sdlvideo.display_format img in
		Sdlvideo.blit_surface d !display ();
		Sdlvideo.flip !display
		
let setCaption = Sdlwm.set_caption
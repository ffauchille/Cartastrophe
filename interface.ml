let width = ref 800
let height= ref 600
let namefile= ref "map-simple.png"
let namefiletreated= ref "map-simple-traite.bmp"
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
(*Ouverture de la fenetre*)
let window = GWindow.window
    ~title:"Cartastrophe"
    ~resizable:true
    ~height:!height
    ~width:!width ()
(*Cadre principal*)


(*Permettre l'ajout de widgets dans window*)
let vbox = GPack.vbox
    ~spacing:5
    ~border_width:5
    ~packing:window#add ()

let hbox = GPack.hbox
    ~spacing:5 (* Les enfants sont espacÈs de 5 pixels. *)
    ~border_width:5 (* La boÓte possËde une bordure de 5 pixels. *)
    ~packing:vbox#add ()
  

let frame = GBin.frame
    ~label: "Image treated"
    ~packing:vbox#add ()
let frame_image_treated = GBin.frame
    ~label:"Image not treated"
    ~packing:hbox#add ()
(*Insertiona du scrolling*)
let scroll = GBin.scrolled_window
    ~height:200
    ~hpolicy:`ALWAYS
    ~vpolicy:`ALWAYS
    ~packing:vbox#add ()
(*emplacement boutons*)
let bbox = GPack.button_box `HORIZONTAL
    ~layout:`SPREAD
    ~packing:(vbox#pack ~expand:false) ()

(*Creation d'une box pour l'image*)
let imgbox = GPack.box `VERTICAL
    ~spacing: 10
    ~border_width: 5
    ~packing: window#add ()
    
(*affichage de l'image d'un GMisc.image*)
let imageview = GMisc.image
    ~file:!namefile
    ~packing:frame#add ()
let imagetreatedview = GMisc.image
    ~file:!namefiletreated
    ~packing:frame_image_treated#add ()
    
let help_message () = print_endline "Cliquez sur \"Quitter\" pour quitter"
(*Bouton d'aide*)
let help =
    let button= GButton.button
	~stock:`HELP
	~packing:bbox#add () in
    button#connect#clicked ~callback:help_message;
    button
(*Bouton quitter*)
let quit =
    let button = GButton.button
	~stock:`QUIT
	~packing:bbox#add () in
    button#connect#clicked ~callback:GMain.quit;
    button
(* Initialisation SDL,GTK2 et ouverture de la fenetre *)
let init () = 
	begin
		Sdl.init [`EVERYTHING];
		Sdlevent.enable_events Sdlevent.all_events_mask;
		window#connect#destroy ~callback:GMain.quit;
		window#show ();
		GMain.main ()
	end





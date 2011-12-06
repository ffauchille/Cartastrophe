let width = ref 800
let height= ref 600
let namefile= ref "map-simple.png"
let namefiletreated= ref "map-simple.png-traite.bmp"
let interval = ref 10
(* On crée la surface d'affichage en doublebuffering *)
(* let newDisplay () =(Sdlvideo.set_video_mode (!width) (!height) [`DOUBLEBUF]
let display = ref (newDisplay ())
let setSize w h = width:=w;height:=h;display :=newDisplay () *)
let setSize w h = ()
(* Affiche une image à l'écran *)
(* let showSurface img = 
	let d = Sdlvideo.display_format img in
		Sdlvideo.blit_surface d !display ();
		Sdlvideo.flip !display
		 *)
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
(*emplacement boutons*)
let bbox = GPack.button_box `HORIZONTAL
    ~layout:`SPREAD
    ~packing:(vbox#pack ~expand:false) ()
let hbox = GPack.hbox
    ~spacing:5 (* Les enfants sont espacés de 5 pixels. *)
    ~border_width: 5 (* La boîte possède une bordure de 5 pixels. *)
    ~packing:vbox#add ()
let image_filter =GFile.filter
    ~name:"Image file"
    ~patterns:["*.bmp";"*.png";"*.jpg";"*.jpeg"]
let open_button = GFile.chooser_button
    ~title:"Map"
    ~action:`OPEN
    ~packing:bbox#add ()
(*Création des différents cadres*)
let frame = GBin.frame
    ~label: "Image not Processed"
    ~packing:vbox#add ()
let frame_image_treated = GBin.frame
    ~label:"Image Processed"
    ~packing:hbox#add ()
(*Bouton d'aide*)
let help =
    let button= GButton.button
	~label:"Help"
	~packing:bbox#add () in
    (*sw*) (button#connect#clicked ~callback:GMain.quit);
    button
(*Bouton quitter*)
let quit =
    let button = GButton.button
	~label:"Quit"
	~packing:bbox#add () in
    (button#connect#clicked ~callback:GMain.quit);
    button
(*Insertiona du scrolling*)
let scroll = GBin.scrolled_window
    ~hpolicy:`ALWAYS
    ~vpolicy:`ALWAYS
    ~packing:window#add ()

(*Creation d'une box pour l'image*)
let imgbox = GPack.box `VERTICAL
    ~spacing: 5
    ~border_width: 5
    ~packing: window#add () 
    
(*affichage de l'image d'un GMisc.image*)
let imageview = GMisc.image
    ~file:!namefile
    ~packing:frame#add ()
let imagetreatedview = GMisc.image
    ~file:!namefiletreated
    ~packing:frame_image_treated#add ()
let imagetreated =  GMisc.drawing_area
    ~height:5
    ~width:5
    ~packing:frame_image_treated#add ()
(* Suppress warnings *)
let sw foo = ()
(* Initialisation SDL,GTK2 et ouverture de la fenetre *)
let init () = 
	begin
		Sdl.init [`EVERYTHING];
		(*Sdlevent.enable_events Sdlevent.all_events_mask;*)
		GMain.init ();
		(*sw*) (window#connect#destroy ~callback:GMain.quit);
		window#show ();

		GMain.Main.main ()
	end

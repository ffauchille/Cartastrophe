let width = ref 800
let height= ref 600
let namefile= ref "map-simple.png"
let namefiletreated= ref "map-simple.png"
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
    ~border_width:1
    ~height:((!height)/3)	
    ~width:((!width)/3)
    ~packing:window#add ()
(*emplacement boutons*)
let hbox = GPack.hbox 
    ~border_width:2
    ~height:(2*(!height)/3) (* Les enfants sont espacés de 5 pixels. *)
    ~width:(2*(!width)/3)
    ~packing:vbox#add ()
let bbox = GPack.button_box `VERTICAL
    ~layout:`SPREAD
    ~packing:(hbox#pack ~expand:false) ()
(*Création des différents cadres*)
(*let frame_image_origin = GBin.frame 
    ~label:"Original Image"
    ~packing:vbox#add ()*)
let frame_image_treated = GBin.frame
    ~label: "Image traitée"
    ~width:((!width)/10)
    ~packing:vbox#add ()
let frame_visualisation = GBin.frame
    ~label:"Visualisation"
    ~packing:hbox#add ()
(*Bouton d'aide*)
let open_button = GFile.chooser_button
    ~title:"Choix de la carte"
    ~action:`OPEN
    ~packing:bbox#add ()
let image_filter =GFile.filter
    ~name:"Fichier image"
    ~patterns:["*.bmp";"*.png";"*.jpg";"*.jpeg"]
let help =
    let button= GButton.button
	~stock:`HELP
	~packing:bbox#add () in
	GMisc.image ~stock:`HELP ~packing: button#set_image ();
    (*sw*) (button#connect#clicked ~callback:GMain.quit);
    button
let about_button =
  let dlg = GWindow.about_dialog
    ~authors:["Quatrographes (<quatrographes@gmail.com>)"]
    ~copyright:"Copyright © 2011-2012 Cartastrophe Project"
    ~license:"EPITA 2015 "
    ~version:"42.42"
    ~website:"http://cartastro0.wordpress.com/"
    ~website_label:"Cartastrophe"
    ~position:`CENTER_ON_PARENT
    ~parent:window
    ~destroy_with_parent:true () in
  let btn = GButton.button 
    ~stock:`ABOUT 
    ~packing:bbox#add () in
  GMisc.image ~stock:`ABOUT ~packing:btn#set_image ();
  btn#connect#clicked (fun () -> ignore (dlg#run ()); dlg#misc#hide ());
  btn
(*Bouton quitter*)
let quit =
    let button = GButton.button
	~stock:`QUIT
	~packing:bbox#add () in
    GMisc.image ~stock:`QUIT ~packing:button#set_image ();
    (button#connect#clicked ~callback:GMain.quit);
    button
(*Creation d'une box pour l'image*)
(*let imgbox = GPack.box `VERTICAL
    ~spacing: 5
    ~border_width: 5
    ~packing: window#add () *)
    
(*affichage de l'image d'un GMisc.image*)
let imageview = GMisc.image
    ~file:!namefiletreated
    ~packing:frame_image_treated#add ()
let imagetreatedview = GMisc.image
    ~file:!namefile
    ~packing:frame_image_treated#add ()
let imagetreated =  GMisc.drawing_area
    ~packing:frame_visualisation#add ()
(* Suppress warnings *)
let sw foo = ()
(* Initialisation SDL,GTK2 et ouverture de la fenetre *)
let init () = 
	begin
		Sdl.init [`EVERYTHING];
		(*Sdlevent.enable_events Sdlevent.all_events_mask;*)
		(*GMain.init ();*)
		(*sw*) (window#connect#destroy ~callback:GMain.quit);
		window#show ();
		GMain.Main.main ()
	end

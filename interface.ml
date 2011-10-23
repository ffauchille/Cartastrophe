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
(*Ouverture de la fenetre*)
let window = GWindow.window
    ~title:"Cartastrophe"
    ~resizable:true
    ~height:!height
    ~width:!width ()
(*Cadre principal*)
(* Backing pixmap for drawing area *)
let backing = ref (GDraw.pixmap 
    ~width:200 
    ~height:200 ())

(* Create a new backing pixmap of the appropriate size *)
let configure window backing ev =
  let width = GdkEvent.Configure.width ev in
  let height = GdkEvent.Configure.height ev in
  let pixmap = GDraw.pixmap 
    ~width 
    ~height 
    ~window () in
  pixmap#set_foreground `WHITE;
  pixmap#rectangle 
    ~x:0 
    ~y:0 
    ~width 
    ~height 
    ~filled:true ();
  backing := pixmap;
  true
(* Draw a rectangle on the screen *)
let draw_brush (area:GMisc.drawing_area) (backing:GDraw.pixmap ref) x y =
  let x = x - 5 in
  let y = y - 5 in
  let width = 10 in
  let height = 10 in
  let update_rect = Gdk.Rectangle.create 
    ~x 
    ~y 
    ~width 
    ~height in
  !backing#set_foreground `BLACK;
  !backing#rectangle 
    ~x 
    ~y 
    ~width 
    ~height 
    ~filled:true ();
  area#misc#draw (Some update_rect)
(* Redraw the screen from the backing pixmap *)
let expose (drawing_area:GMisc.drawing_area) (backing:GDraw.pixmap ref) ev =
  let area = GdkEvent.Expose.area ev in
  let x = Gdk.Rectangle.x area in
  let y = Gdk.Rectangle.y area in
  let width = Gdk.Rectangle.width area in
  let height = Gdk.Rectangle.width area in
  let drawing =
    drawing_area#misc#realize ();
    new GDraw.drawable (drawing_area#misc#window)
  in
  drawing#put_pixmap ~x ~y ~xsrc:x ~ysrc:y ~width ~height !backing#pixmap;
  false
(*Permettre l'ajout de widgets dans window*)
let vbox = GPack.vbox
    ~spacing:10
    ~border_width:10
    ~packing:window#add ()
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

(*Appels des fonctions draw_brush*)
let drawing_area = GMisc.drawing_area
    ~width:400
    ~height:300
    ~packing:(window#add) ()


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





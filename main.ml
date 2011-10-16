(* Fonction Main et fonctions associÈ ‡ SDL *)

(* Initialisation basique de SDL *)
let sdl_init () =
	begin
		Sdl.init [`EVERYTHING];
		Sdlevent.enable_events Sdlevent.all_events_mask;
	end
	
(* ------- Alias ------- *)
let get_px = Sdlvideo.get_pixel_color
let load_picture = Sdlloader.load_image

(* ------- Utils ------- *)

(* Convertit un triplet de couleurs RGB en LAB *)
let rgb2lab (r,g,b) =
	let h = function 
		| q when q> 0.008856 -> q ** 0.33333
		| q ->  7.787*.q +. 0.137931 in
	let fr = ref ((float_of_int r) /. 255.) in
	let fg = ref ((float_of_int g) /. 255.) in
	let fb = ref ((float_of_int b) /. 255.) in
	if !fr > 0.04045 then
			fr:=( ( !fr  +. 0.055 ) /. 1.055 ) ** 2.4
	else 
			fr:= !fr/.12.92;
	if !fg > 0.04045 then
			fg:=( ( !fg  +. 0.055 ) /. 1.055 ) ** 2.4
	else 
			fg:= !fg/.12.92;
	if !fb > 0.04045 then
			fb:=( ( !fb  +. 0.055 ) /. 1.055 ) ** 2.4
	else 
			fb:= !fb/.12.92;
  let (a,b,c) = (0.950467,1.0,1.088969) in
	let (x,y,z) = ((0.412424 *. !fr +. 0.357579 *. !fg +. 0.180464 *. !fb),
								 (0.212656 *. !fr +. 0.715158 *. !fg +. 0.0721856 *. !fb),
								 (0.0193324 *. !fr +. 0.119193 *. !fg +. 0.950444 *. !fb)) in
	
	( (int_of_float (116.*.(h (y/.b))))-16,
	  (int_of_float (500.*.((h (x/.a))-.( h (y/.b))))),
		(int_of_float (200.*.((h (y/.b))-.( h (z/.c))))))
(* attendre une touche ... *)
let rec wait_key () =
  let e = Sdlevent.wait_event () in
    match e with
    Sdlevent.KEYDOWN _ -> ()
      | _ -> wait_key ()
 
let string_of_coord (x,y) = "("^(string_of_int x)^","^(string_of_int y)^")" 
let string_of_color (r,g,b) = "("^(string_of_int r)^","^(string_of_int g)^","^(string_of_int b)^")" 
(* Renvoie un couplet de dimensions *)
let get_dims img =
	((Sdlvideo.surface_info img).Sdlvideo.w,
		(Sdlvideo.surface_info img).Sdlvideo.h)
(* Affiche une image ‡ l'Ècran *)
let show img dst =
	let d = Sdlvideo.display_format img in
	Sdlvideo.blit_surface d dst ();
	Sdlvideo.flip dst
(* Chiffre entre O et 1 reprÅÈsentant la diffÅÈrence entre les couleurs    *)
(* afin                                                                    *)
let rgb_distance (r1, g1, b1) (r2, g2, b2) =
	(* float_of_int (abs(r1 - r2) + abs(g1 - g2) + abs(b1 - b2)) /. 765. *)
	(abs(r1 - r2) , abs(g1 - g2) , abs(b1 - b2))
let lab_distance rgb1 rgb2 =
	let (l1,a1,b1) = rgb2lab rgb1 in
	let (l2,a2,b2) = rgb2lab rgb2 in
	 ( (float_of_int (l1-l2))**2. +. (float_of_int (a1-a2))**2. +. (float_of_int (b1-b2))**2. ) ** 0.5
(* calcul du contrast *)
let calc_contrast (r1, g1, b1) (r2, g2, b2) = ()

(* detecte les couleurs appartenantes Å‡ la mÍme zone , utilisant une      *)
(* fonction de distinction de couleurs                                     *)
let is_same_area c1 c2 = 
	(* let dr,dg,db=(rgb_distance c1 c2) in
	(* *)
	dr <20 &&dg <20 && db<20 *)
	 (* let cd = lab_distance c1 c2 in
	  if cd <> 0. then
		 print_string ((string_of_color c1)^"-"^(string_of_color c2)^"="^(string_of_float cd)^"\n"); *) 
	(lab_distance c1 c2)<20.0

let detect_areas img = (* detecte les diffÅÈrentes zones *)
	let breaks = ref [] in
	let colors = ref [] in
	let lastColor = ref (0,0,0) in
	let curColor = ref (0,0,0) in
	let (w, h) = get_dims img in
	
	for x =0 to w-1 do
		for y =0 to h-1 do
			
			curColor := (get_px img x y);
			if not (is_same_area !lastColor !curColor) then
				begin
					colors := !curColor::!colors;
					lastColor := !curColor;
					breaks := (x, y)::!breaks;
				end
		done
	done;
	lastColor := (0,0,0);
	for y =0 to h-1 do
		for x =0 to w-1 do
			curColor := (get_px img x y);
			if not (is_same_area !lastColor !curColor) then
				begin
					colors := !curColor::!colors;
					lastColor := !curColor;
					breaks := (x, y)::!breaks;
				end
		done
	done;
	!breaks

(* colore deux pixels en noir en fonction de la liste rÈsultat de          *)
(* detect_areas                                                            *)
let rec print_borders img = function
	| [] -> ()
	| (x, y):: list -> (Sdlvideo.put_pixel_color img x y (0,0,0));
			print_borders img list
let print_borders_to_file filename list =
	let file = open_out_gen [Open_wronly; Open_creat; Open_trunc] 511 filename in
	let rec nested file = function
		| [] -> ()
		| coord:: l -> 
	output_string file (string_of_coord coord^"\n");
				nested file l
	in
	output_string file ("Debut\n");
	nested file list;
	output_string file ("Fin");
	close_out file
let test = 0

(* ------- Main ------- *)
let main () =
	begin
		(* Nous voulons 1 argument *)
		if Array.length (Sys.argv) < 2 then
			failwith "Il manque le nom du fichier!";
		(* Initialisation de SDL *)
		sdl_init ();
		(* Chargement d'une image *)
		let img = Sdlloader.load_image Sys.argv.(1) in
		(* On rÅÈcupÅËre les dimensions *)
		let (w, h) = get_dims img in
		(* On crÅÈe la surface d'affichage en doublebuffering *)
		let display = Sdlvideo.set_video_mode w h [`DOUBLEBUF] in
		(* on affiche l'image *)
		let breaks = (detect_areas img) in
		print_borders_to_file (Sys.argv.(1)^".txt") breaks;
		print_borders img breaks;
		show img display;
		wait_key ();
		(* on quitte *)
		exit 0
	end

let _ = main ()

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
let calc_colors_diff (r1, g1, b1) (r2, g2, b2) =
	(* float_of_int (abs(r1 - r2) + abs(g1 - g2) + abs(b1 - b2)) /. 765. *)
	(abs(r1 - r2) , abs(g1 - g2) , abs(b1 - b2))

(* calcul du contrast *)
let calc_contrast (r1, g1, b1) (r2, g2, b2) = ()

(* detecte les couleurs appartenantes Å‡ la mÍme zone , utilisant une      *)
(* fonction de distinction de couleurs                                     *)
let is_same_area c1 c2 = 
	let dr,dg,db=(calc_colors_diff c1 c2) in
	(* if cd <> 0. then
		 print_string ((string_of_color c1)^"-"^(string_of_color c2)^"="^(string_of_float cd)^"\n"); *)
	dr <20 &&dg <20 && db<20

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
	let file = open_out_gen [Open_wronly; Open_creat] 511 filename in
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

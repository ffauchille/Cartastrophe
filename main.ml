(* Fonction Main et fonctions associé à SDL *)

(* Initialisation basique de SDL *)

(* ------- Alias ------- *)

let load_picture = Sdlloader.load_image

(* ------- Utils ------- *)


(* attendre une touche ... *)
let rec wait_key () =
  let e = Sdlevent.wait_event () in
    match e with
    Sdlevent.KEYDOWN _ -> ()
      | _ -> wait_key ()
 
let string_of_coord (x,y) = "("^(string_of_int x)^","^(string_of_int y)^")" 
let string_of_color (r,g,b) = 
	"("^(string_of_int r)^","^(string_of_int g)^","^(string_of_int b)^")" 

(* Renvoie un couplet de dimensions *)
let get_dims img =
	((Sdlvideo.surface_info img).Sdlvideo.w,
		(Sdlvideo.surface_info img).Sdlvideo.h)



(* colore deux pixels en noir en fonction de la liste résultat de          *)
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
let getHeight (x,y) = 10
let pixel2coord (x,y) =
	((float_of_int x)/.100.0,
	 (float_of_int y)/.100.0,
	 (float_of_int (getHeight (x,y)))/.100.0) 
let rec createCoordList = function
	| [] -> []
	| c::l ->  (pixel2coord c)::(createCoordList l) 
let createObj filename list  =
		let file = 
			open_out_gen [Open_wronly; Open_creat; Open_trunc] 511 filename in
		let i = ref 0 in
		let vector = ref "" in
		let facet = ref "" in
		let rec nested = function
			| [] -> (!vector) ^ (!facet)
			| (x,y,z):: l -> 
				if !i mod 3 = 0 then
						facet := (!facet)^"\nf";
					
				vector :=!vector^"\nv "^(string_of_float x)^
															" "^(string_of_float y)^
															" "^(string_of_float z);
				facet := !facet ^" "^(string_of_int !i);
				i:=!i+1;
				(nested l)
		in
		output_string file ("# Debut du fichier"^filename^"\n"^
												(nested list)^
												"\n# Fin du fichier"^filename);
		close_out file

(* ------- Main ------- *)
let main () =
	begin
		(* Nous voulons 1 argument *)
		if Array.length (Sys.argv) < 2 then
			failwith "Il manque le nom du fichier!";
		(* Initialisation de l'interface *)
		Interface.init ();
		(* Chargement d'une image *)
		let img = load_picture Sys.argv.(1) in
		(* On récupère les dimensions *)
		let (w, h) = get_dims img in
		(* Resize la fenêtre *)
		Interface.setSize w h;
		(* Donne un nom et un icone à la fenêtre *)
		Interface.setCaption "Cartastrophe !" "icon.png";
		(* Affiche une surface (image non modifié) *) 
		Interface.showSurface img; 
		(* Traite l'image *)
		let breaks = (ImageProcessing.detect_areas img w h) in
		createObj (Sys.argv.(1)^".obj") (createCoordList breaks);
		(* Imprime les bordures sur l'image *)
		print_borders img breaks;
		(* Affiche l'image modifiée *)
		Interface.showSurface img;
		wait_key ();
		(* on quitte *)
		exit 0
	end

let _ = main ()

(* Fonction Main et fonctions associÈ ‡ SDL *)

(* Initialisation basique de SDL *)

(* ------- Alias ------- *)


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
(*
(*Chargement d'une image *)
let image_processing filename = 
    let img = load_picture filename in
(* On rÅÈcupÅËre les dimensions *)
    let (w, h) = ImageProcessing.get_dims img in
(* Traite l'image *)
    let breaks = (ImageProcessing.detect_areas img) in
    begin   
    ObjMaker.createObj (filename^".obj") (ObjMaker.calc_intersection (w,h)
    !Interface.interval); 
    	(* Imprime les bordures sur l'image *)
    ImageProcessing.print_borders img breaks;
    	(* Affiche l'image modifiÈe *)
    Sdlvideo.save_BMP img (filename^"-traite.bmp");
    Sdlvideo.save_BMP (ImageProcessing.crisscross img (w,h) (!Interface.interval))
    (filename^"-crisscross.bmp");
    end		


*)

(* ------- Main ------- *)
let main () =
	begin
		(* Initialisation de l'interface *)
		Interface.init ();
		(* on quitte *)
		exit 0
	end

let _ = main ()

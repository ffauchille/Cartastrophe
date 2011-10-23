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
		let (w, h) = ImageProcessing.get_dims img in
		(* Redimensionne la fenêtre *)
		Interface.setSize w h;
		(* Donne un nom et un icone à la fenêtre *)
		Interface.setCaption "Cartastrophe !" "icon.png";
		(* Affiche une surface (image non modifié) *) 
		Interface.showSurface img; 
		(* Traite l'image *)
		let breaks = (ImageProcessing.detect_areas img) in
		
		ObjMaker.createObj (Sys.argv.(1)^".obj") (ObjMaker.calc_intersection (w,h));
		(* Imprime les bordures sur l'image *)
		ImageProcessing.print_borders img breaks;
		(* Affiche l'image modifiée *)
		Interface.showSurface img;
		wait_key ();
		(* on quitte *)
		exit 0
	end

let _ = main ()

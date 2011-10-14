let sdl_init () = 
  begin
    Sdl.init [`EVERYTHING];
    Sdlevent.enable_events Sdlevent.all_events_mask;
  end

let show img dst = 
  let d = Sdlvideo.display_format img in
  Sdlvideo.blit_surface d dst ();
  Sdlvideo.flip dst



let load_picture filename = Sdlloader.load_image;; (* charge l'image *)

let calc_colors_diff (r1,g1,b1) (r2,g2,b2) =
  float_of_int(abs(r1-r2)+abs(g1-g2)+abs(b1-b2))/.255. (*Chiffre entre O et 1 
							    représentant
							 la
							 différence
							 entre les
							 couleurs
							 afin *)

let calc_contrast (r1,g1,b1) (r2,g2,b2) = ();; (* calcul du contrast *)
let is_same_area (r1,g1,b1) (r2,g2,b2) f = ();; (* detecte les couleurs
						 appartenantes à la
						   même zone ,
						   utilisant une
						   fonction de
						   distinction de couleurs  *)
let detect_areas img = ();; (* detecte les différentes zones *)
let parse_image img f = ();; (* analyse l'image de haut en bas avec
				la fonction f *)
let print_borders img l = ();; (* colore deux pixels en noir en
				     fonction de la liste résultante
				     de detect_areas  *)
let rec borders_to_file l filename = ();;(*match l with
    |[] -> ()
    |e::l -> print_boarders *)
	    
    

      (* ------------------------------------------------------------------ *)

let load_picture filename = Sdlloader.load_image Sys.argv.(1) in 
show filename display;


(* main toujours en fin *)
let main () =
  begin
    (* Nous voulons 1 argument *)
    if Array.length (Sys.argv) < 2 then
      failwith "Il manque le nom du fichier!";
    (* Initialisation de SDL *)
    sdl_init ();
    (* Chargement d'une image *)
    let img = Sdlloader.load_image Sys.argv.(1) in
    (* On récupère les dimensions *)
    let (w,h) = get_dims img in
    (* On crée la surface d'affichage en doublebuffering *)
     let display = Sdlvideo.set_video_mode w h [`DOUBLEBUF] in
      (* on affiche l'image *)
      show img display;
      (* on attend une touche *)
      wait_key ();
      (* on quitte *)
      exit 0
  end

let _ = main ()








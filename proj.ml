let sdl_init () = 
  begin
    Sdl.init [`EVERYTHING];
    Sdlevent.enable_events Sdlevent.all_events_mask;
  end

let get_dims img = ((Sdlvideo.surface_info img).Sdlvideo.w,(Sdlvideo.surface_info img).Sdlvideo.h)
let get_px = Sdlvideo.get_pixel_color 
let show img dst = 
  let d = Sdlvideo.display_format img in
  Sdlvideo.blit_surface d dst ();
  Sdlvideo.flip dst



let load_picture filename = ();; (* charge l'image *)
let calc_colors_diff (r1,g1,b1) (r2,g2,b2) =
  float_of_int (abs(r1-r2)+abs(g1-g2)+abs(b1-b2))/.255.
  (*Chiffre entre O et 1 reprÅÈsentant
							 la
							 diffÅÈrence
							 entre les
							 couleurs
							 afin *)


let calc_contrast (r1,g1,b1) (r2,g2,b2) = ();; (* calcul du contrast *)
let is_same_area c1 c2 f = (f c1 c2)<0.2;; (* detecte les couleurs
						 appartenantes Å‡ la
						   mÅÍme zone ,
						   utilisant une
						   fonction de
						   distinction de couleurs  *)
let detect_areas img = (* detecte les diffÅÈrentes zones *)
	let breaks = ref [] in
	let lastColor = ref (0,0,0) in
	let curColor = ref (0,0,0) in
	let w,h = get_dims img in
	begin
	for x=0 to w do
		for y=0 to h do
			lastColor := !curColor;
			curColor := (get_px img x y);
			if is_same_area !lastColor !curColor calc_colors_diff then
				breaks := (x,y)::!breaks
			
		done
	done
	!breaks;
	end
	
(* let parse_image img f = ();; (* analyse l'image de haut en bas avec
				la fonction f *) *)
let print_borders img list = ();; (* colore deux pixels en noir en
				     fonction de la liste rÅÈsultante
				     de detect_areas  *)
let rec_borders_to_file list filename = ();;

      (* ------------------------------------------------------------------ *)


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
    (* On rÅÈcupÅËre les dimensions *)
    let (w,h) = get_dims img in
    (* On crÅÈe la surface d'affichage en doublebuffering *)
     let display = Sdlvideo.set_video_mode w h [`DOUBLEBUF] in
      (* on affiche l'image *)
      show img display;
      (* on attend une touche *)
      wait_key ();
      (* on quitte *)
      exit 0
  end
 
let _ = main ()






 





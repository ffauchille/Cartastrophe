(* Fonction Main et fonctions associé à SDL *)

(*  ------- *)
(*   Alias  *)
(*  ------- *)
let get_px = Sdlvideo.get_pixel_color
let load_picture = Sdlloader.load_image

(*  ------- *)
(*   Utils  *)
(*  ------- *)

(* Initialisation basique de SDL *)
let sdl_init () = 
  begin
    Sdl.init [`EVERYTHING];
    Sdlevent.enable_events Sdlevent.all_events_mask;
  end
(* Renvoie un couplet de dimensions *)
let get_dims img = ((Sdlvideo.surface_info img).Sdlvideo.w,(Sdlvideo.surface_info img).Sdlvideo.h)
(* Affiche une image à l'écran *)
let show img dst = 
  let d = Sdlvideo.display_format img in
  Sdlvideo.blit_surface d dst ();
  Sdlvideo.flip dst
	
(*  ------- *)
(*   Main   *)
(*  ------- *)
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

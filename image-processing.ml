 (*Chiffre entre O et 1 représentant
							 la
							 différence
							 entre les
							 couleurs
							 afin *)
let calc_colors_diff (r1,g1,b1) (r2,g2,b2) =
  float_of_int (abs(r1-r2)+abs(g1-g2)+abs(b1-b2))/.255.


(* calcul du contrast *)
let calc_contrast (r1,g1,b1) (r2,g2,b2) = ()


let is_same_area c1 c2 = (calc_colors_diff c1 c2)<0.2 (* detecte les couleurs
						 appartenantes à la
						   même zone ,
						   utilisant une
						   fonction de
						   distinction de couleurs  *)

let detect_areas img = (* detecte les différentes zones *)
	let breaks = ref [] in
	let lastColor = ref 0,0,0 in
	let curColor = ref 0,0,0 in
	let (w,h) = get_dims img in
	begin
	for x=0 to w do
		for y=0 to h do
			lastColor := !curColor;
			curColor := (get_px img x y);
			if (is_same_area !lastColor !curColor) then
				breaks := (x,y)::!breaks
			
		done
	done
	end
	!breaks
	
(* colore deux pixels en noir en fonction de la liste 
résultat de detect_areas  *)
let rec print_borders img = function 
   | [] -> ()
   |(x,y)::list -> Sdlvideo.put_pixel_color img x y (0,0,0); print_borders img list; 
             
						
					
let rec borders_to_file l filename = ();;
(*match l with
    |[] -> ()
    |e::l -> print_boarders *)


	    









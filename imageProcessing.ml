(* ------- Utils ------- *)
let rgblabHt: (int*int*int,int*int*int) Hashtbl.t = Hashtbl.create 10 
let isaHt : ( (int*int*int)*(int*int*int),bool) Hashtbl.t = Hashtbl.create 50
let heightHT : (int*int,float) Hashtbl.t = Hashtbl.create 300000
(* Convertit un triplet de couleurs RGB en LAB *)
let rgb2lab (r,g,b) =
	try
		let lab= Hashtbl.find rgblabHt (r,g,b) in
		lab;
	with | Not_found ->
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
  let (alpha,beta,gamma) = (0.950467,1.0,1.088969) in
	let (x,y,z) = ((0.412424 *. !fr +. 0.357579 *. !fg +. 0.180464 *. !fb),
								 (0.212656 *. !fr +. 0.715158 *. !fg +. 0.0721856 *. !fb),
								 (0.0193324 *. !fr +. 0.119193 *. !fg +. 0.950444 *. !fb)) in
	let lab= 
	( (int_of_float (116.*.(h (y/.beta))))-16,
	  (int_of_float (500.*.((h (x/.alpha))-.( h (y/.beta))))),
		(int_of_float (200.*.((h (y/.beta))-.( h (z/.gamma)))))) in
		Hashtbl.add rgblabHt (r,g,b) lab;
		lab
let f_i = float_of_int
		(* Chiffre entre O et 1 représentant la différence entre les couleurs    *)
let rgb_distance (r1, g1, b1) (r2, g2, b2) =
	 ((f_i r1 -. f_i r2)**2. 
			+. (f_i g1 -. f_i g2)**2. 
			+. (f_i b1 -. f_i b2)**2.)**0.5  
	(* (abs(r1 - r2) , abs(g1 - g2) , abs(b1 - b2)) *)

let lab_distance rgb1 rgb2 =
	let (l1,a1,b1) = rgb2lab rgb1 in
	let (l2,a2,b2) = rgb2lab rgb2 in
	 ( (float_of_int (l1-l2))**2. 
			+. (float_of_int (a1-a2))**2. 
			+. (float_of_int (b1-b2))**2. ) ** 0.5
(* calcul du contrast *)
let calc_contrast (r1, g1, b1) (r2, g2, b2) = ()

let crisscross img (w,h) interval = 
		for x =0 to w-1 do
			for y =0 to h-1 do
				if x mod interval = 0 then
					Sdlvideo.put_pixel_color img x y (0,0,0);
				if y mod interval = 0 then
					Sdlvideo.put_pixel_color img x y (0,0,0)
			done
	done;
	img
(* detecte les couleurs appartenantes à la même zone , utilisant une      *)
(* fonction de distinction de couleurs                                     *)
let is_same_color c1 c2 =
	try
		let isa= Hashtbl.find isaHt (c1,c2) in
		 isa
	with Not_found ->  
		let isa = (lab_distance c1 c2)<10.0 in
		Hashtbl.add isaHt (c1,c2) isa;
		isa
	
let colorIndex c1 list =
	let rec nested i=   
		function 
		| [] -> i
		| c2::cList -> if (is_same_color c1 c2)  then i else (nested (i+1) cList) 
	in
		nested 0 list
(* colore deux pixels en noir en fonction de la liste résultat de          *)
(* detect_areas                                                            *)
let rec print_borders img = function
	| [] -> ()
	| (x, y,_):: list -> (Sdlvideo.put_pixel_color img x y (0,0,0));
			print_borders img list
(* Renvoie un couplet de dimensions *)
let get_dims img =
	((Sdlvideo.surface_info img).Sdlvideo.w,
		(Sdlvideo.surface_info img).Sdlvideo.h)


let detect_areas img= (* detecte les différentes zones *)
	let breaks = ref [] in
	
	let curColor = ref (0,0,0) in
	let firstColor = (Sdlvideo.get_pixel_color img 0 0) in
	let lastColor = ref firstColor in
	let curColorIndex = ref 0 in 
	let lastColorIndex = ref 0 in 
	let colorsLength = ref 1 in
	let colors = ref [firstColor] in
		(* On récupère les dimensions *)
	let (w, h) = get_dims img in 
	let z = ref 0. in 
	let nested x y= 
		curColor := (Sdlvideo.get_pixel_color img x y);
		Hashtbl.add heightHT (x,y) !z; 
			if not (is_same_color !curColor !lastColor) then
				begin 
					lastColorIndex := !curColorIndex;
					curColorIndex := colorIndex !curColor !colors;
					if !curColorIndex>(!colorsLength) then 
						begin
							colorsLength := !curColorIndex;
							colors := !curColor::!colors;
						end;
					z := f_i !curColorIndex; 
					breaks := (x, y, !z)::!breaks;
					lastColor := !curColor;
				end
			in 
	for x =0 to w-1 do
		for y =0 to h-1 do
			nested x y
		done
	done;
	z:=0.;
	lastColor := firstColor;
	for y =0 to h-1 do
		for x =0 to w-1 do
			nested x y
		done
	done;
	!breaks


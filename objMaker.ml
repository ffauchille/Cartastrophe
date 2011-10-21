
let getHeight (x,y) = (x-y)*(x-y)
let pixel2coord (x,y,z) =
	((float_of_int x)/.100.0,
	 (float_of_int y)/.100.0,
	 (float_of_int z)/.100.0) 
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

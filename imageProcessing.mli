val rgblabHt : (int * int * int, int * int * int) Hashtbl.t
val isaHt : (Sdlvideo.color * Sdlvideo.color, bool) Hashtbl.t
val heightHT : (int * int, float) Hashtbl.t
val colorHT  : (int * int, int*int*int) Hashtbl.t
val rgb2lab : int * int * int -> int * int * int
val f_i : int -> float
val rgb_distance : int * int * int -> int * int * int -> float
val lab_distance : int * int * int -> int * int * int -> float
val calc_contrast : 'a * 'b * 'c -> 'd * 'e * 'f -> unit
val crisscross : Sdlvideo.surface -> int * int -> int -> Sdlvideo.surface
val is_same_color : Sdlvideo.color -> Sdlvideo.color -> bool
val colorIndex : Sdlvideo.color -> Sdlvideo.color list -> int
val print_borders : Sdlvideo.surface -> (int * int * 'a) list -> unit
val get_dims : Sdlvideo.surface -> int * int
val detect_areas : Sdlvideo.surface -> (int * int * float) list

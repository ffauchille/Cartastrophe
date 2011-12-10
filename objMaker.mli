val f_i : int -> float
val s_i : int -> string
val s_f : float -> string
val lastHeight : float ref
val pgcd : int -> int -> int
val getHeight : float * float -> int -> float
val pp : int ref -> unit
val calc_intersection :
  int * int -> int -> (float * float * float) list * (int * int * int) list
val pixel2coord : int * int * int -> float * float * float
val createCoordList : (int * int * int) list -> (float * float * float) list
val createObj :
  string -> (float * float * float) list * (int * int * int) list -> unit

val f_i : int -> float
val s_i : int -> string
val s_f : float -> string
val pgcd : int -> int -> int
val getHeight : float * float * float -> float
val getColor : float * float -> int -> float * float * float
val gH : float * float * float -> float
val gC : float * float -> int -> float * float * float
val pp : int ref -> unit
module VertexMap :
  sig
    type key = int
    type +'a t
    val empty : 'a t
    val is_empty : 'a t -> bool
    val add : key -> 'a -> 'a t -> 'a t
    val find : key -> 'a t -> 'a
    val remove : key -> 'a t -> 'a t
    val mem : key -> 'a t -> bool
    val iter : (key -> 'a -> unit) -> 'a t -> unit
    val map : ('a -> 'b) -> 'a t -> 'b t
    val mapi : (key -> 'a -> 'b) -> 'a t -> 'b t
    val fold : (key -> 'a -> 'b -> 'b) -> 'a t -> 'b -> 'b
    val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
    val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
  end
val calc_intersection :
  int * int ->
  int ->
  ((float * float * float) * (float * float * float)) VertexMap.t *
  (VertexMap.key * VertexMap.key * VertexMap.key) list
val pixel2coord : int * int * int -> float * float * float
val createCoordList : (int * int * int) list -> (float * float * float) list
val createObj :
  string ->
  ('a * (float * float * float)) VertexMap.t * (int * int * int) list -> unit

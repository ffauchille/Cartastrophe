val rtri : float ref
val resizeGLScene : width:int -> height:int -> unit
val initGL : unit -> unit
module VertexMap :
  sig
    type key = Int32.t
    type 'a t = 'a Map.Make(Int32).t
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
val drawMap :
  < swap_buffers : unit -> 'a; .. > ->
  (Gl.rgb * Gl.point3) VertexMap.t -> VertexMap.key list -> 'a
val killGLWindow : unit -> unit
val display :
  < connect : < display : callback:'a -> 'b;
                realize : callback:(unit -> unit) -> 'c;
                reshape : callback:(width:int -> height:int -> unit) -> 'd;
                .. >;
    swap_buffers : unit -> 'a; .. > ->
  int -> int -> (Gl.rgb * Gl.point3) VertexMap.t -> VertexMap.key list -> 'c

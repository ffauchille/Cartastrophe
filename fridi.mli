module Vm :
  sig
    type key = int
    type 'a t = 'a ObjMaker.VertexMap.t
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
val rtri : float ref
val zoom : float ref
val vmap : (Gl.rgb * Gl.point3) Vm.t ref
val flist :
  (ObjMaker.VertexMap.key * ObjMaker.VertexMap.key * ObjMaker.VertexMap.key)
  list ref
val resizeGLScene : width:int -> height:int -> unit
val memoize : (unit -> 'a) -> unit -> unit
val test :
  unit ->
  ((float * float * float) * (float * float * float)) Vm.t *
  (int * int * int) list
val initGL : unit -> unit
val drawMap : unit -> unit
val drawScene : < swap_buffers : unit -> 'a; .. > -> unit -> 'a
val killGLWindow : unit -> unit
val sw : 'a -> unit
val display :
  < connect : < display : callback:(unit -> 'a) -> 'b;
                realize : callback:(unit -> unit) -> 'c;
                reshape : callback:(width:int -> height:int -> unit) -> 'd;
                .. >;
    swap_buffers : unit -> 'a; .. > ->
  int ->
  int ->
  (Gl.rgb * Gl.point3) Vm.t ->
  (ObjMaker.VertexMap.key * ObjMaker.VertexMap.key * ObjMaker.VertexMap.key)
  list -> 'c

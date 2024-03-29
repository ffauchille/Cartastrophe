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
val zoom : float ref
val map : GlList.t option ref
val w : float ref
val h : float ref
val initGL : unit -> unit
val resizeGLScene : width:int -> height:int -> unit
val drawMap :
  (Gl.rgb * Gl.point3) ObjMaker.VertexMap.t ->
  (ObjMaker.VertexMap.key * ObjMaker.VertexMap.key * ObjMaker.VertexMap.key)
  list -> unit -> unit
val deleteMap : unit -> unit
val callCompileMap :
  (Gl.rgb * Gl.point3) ObjMaker.VertexMap.t ->
  (ObjMaker.VertexMap.key * ObjMaker.VertexMap.key * ObjMaker.VertexMap.key)
  list -> unit
val rx : float ref
val ry : float ref
val rz : float ref
val tx : float ref
val ty : float ref
val tz : float ref
val ap : bool ref
val wf : bool ref
val c : float ref -> float -> int -> unit
val translateX : int -> unit
val translateY : int -> unit
val translateZ : int -> unit
val rotateX : int -> unit
val rotateY : int -> unit
val rotateZ : int -> unit
val doZoom : int -> unit
val autoplay : unit -> unit
val toggle_autoplay : unit -> unit
val resetCamera : unit -> unit
val toggleWireframe : unit -> unit
val drawScene :
  < make_current : unit -> 'a; swap_buffers : unit -> 'b; .. > ->
  (Gl.rgb * Gl.point3) ObjMaker.VertexMap.t ->
  (ObjMaker.VertexMap.key * ObjMaker.VertexMap.key * ObjMaker.VertexMap.key)
  list -> unit -> 'b
val killGLWindow : unit -> unit
val sw : 'a -> unit
val lastTo : GMain.Timeout.id ref
val display :
  < connect : < display : callback:(unit -> 'a) -> 'b;
                realize : callback:(unit -> unit) -> 'c;
                reshape : callback:(width:int -> height:int -> unit) -> 'd;
                .. >;
    make_current : unit -> 'e; swap_buffers : unit -> 'a; .. > ->
  int ->
  int ->
  (Gl.rgb * Gl.point3) ObjMaker.VertexMap.t ->
  (ObjMaker.VertexMap.key * ObjMaker.VertexMap.key * ObjMaker.VertexMap.key)
  list -> unit

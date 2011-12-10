val rtri : float ref
val resizeGLScene : width:int -> height:int -> unit
val initGL : unit -> unit
val drawMap : < swap_buffers : unit -> 'a; .. > -> 'b -> 'c -> unit -> 'a
val _drawMap :
  < swap_buffers : unit -> 'a; .. > ->
  (Gl.rgb * Gl.point3) ObjMaker.VertexMap.t ->
  (ObjMaker.VertexMap.key * ObjMaker.VertexMap.key * ObjMaker.VertexMap.key)
  list -> unit -> 'a
val killGLWindow : unit -> unit
val display :
  < connect : < display : callback:(unit -> 'a) -> 'b;
                realize : callback:(unit -> unit) -> 'c;
                reshape : callback:(width:int -> height:int -> unit) -> 'd;
                .. >;
    swap_buffers : unit -> 'a; .. > ->
  int -> int -> 'e -> 'f -> 'c

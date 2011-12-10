val rtri : float ref
val rquad : float ref
val resizeGLScene : width:int -> height:int -> unit
val initGL : unit -> unit
val drawGLScene : < swap_buffers : unit -> 'a; .. > -> unit -> 'a
val killGLWindow : unit -> unit
val createGLWindow : string -> int -> int -> int -> 'a -> GWindow.window

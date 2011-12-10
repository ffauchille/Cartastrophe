let rtri = ref 0.0

let resizeGLScene ~width ~height =
  let ok_height =
    if height = 0 then 1 else height in

  GlDraw.viewport 0 0 width ok_height;

  GlMat.mode `projection;
  GlMat.load_identity ();
  
  GluMat.perspective ~fovy:45.0
    ~aspect:((float_of_int width)/.(float_of_int ok_height)) ~z:(0.1, 100.0);
    
  GlMat.mode `modelview;
  GlMat.load_identity ()


let initGL () =
  GlDraw.shade_model `smooth;
  
  GlClear.color ~alpha:0.0 (0.0, 0.0, 0.0);

  GlClear.depth 1.0;
  Gl.enable `depth_test;
  GlFunc.depth_func `lequal;

  GlMisc.hint `perspective_correction `nicest
(* module VertexMap = Map.Make(Int32) *)
let drawMap area vmap flist ()=
    let f i=
        let (c,vx) =
        try
            ObjMaker.VertexMap.find i vmap
        with Not_found -> ((0.,0.,0.),(0.,0.,0.))
        in
        GlDraw.color c;
        GlDraw.vertex3 vx; ()
    in
    let g (i,j,k) = (f i);(f j);(f k) in
  GlClear.clear [`color; `depth];
  GlMat.load_identity ();
  GlMat.translate ~x:(-1.5) ~y:0.0 ~z:(-6.0) ();
  
  GlMat.rotate ~angle:!rtri ~x:0.0 ~y:1.0 ~z:0.0 ();
  
  GlDraw.begins `triangles;

  List.iter g flist;

  GlDraw.ends ();

  rtri := !rtri +. 0.2;

  area#swap_buffers  
  


let killGLWindow () =
  () (* do nothing *)

let display area width height vmap flist=
  GMain.Timeout.add ~ms:20 ~callback:
  begin fun () ->
       drawMap area vmap flist (); true
  end;
  area#connect#display ~callback:(drawMap area vmap flist ());
  area#connect#reshape ~callback:resizeGLScene;

  area#connect#realize ~callback:
    begin fun () ->
      initGL ();
      resizeGLScene ~width ~height
    end;
    ()



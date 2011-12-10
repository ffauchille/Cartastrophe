let rtri = ref 0.0
let rquad = ref 0.0

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
module VertexMap = Map.Make(Int32)
let drawMap area vmap vlist =
    let f i= 
        let (c,vx) = 
        try
            VertexMap.find i vmap
        with Not_found -> ((0.,0.,0.),(0.,0.,0.))
        in
        GlDraw.color c;
        GlDraw.vertex3 vx
    in
    
  GlClear.clear [`color; `depth];
  GlMat.load_identity ();
  GlMat.translate ~x:(-1.5) ~y:0.0 ~z:(-6.0) ();
  
  GlMat.rotate ~angle:!rtri ~x:0.0 ~y:1.0 ~z:0.0 ();
  
  GlDraw.begins `triangles;

  List.iter f vlist;

  GlDraw.ends ();

  rtri := !rtri +. 0.2;

  area#swap_buffers ()

let drawGLScene area () =
  GlClear.clear [`color; `depth];
  GlMat.load_identity ();
  GlMat.translate ~x:(-1.5) ~y:0.0 ~z:(-6.0) ();
  
  GlMat.rotate ~angle:!rtri ~x:0.0 ~y:1.0 ~z:0.0 ();
  
  GlDraw.begins `triangles;

  GlDraw.color (1.0, 0.0, 0.0);
  GlDraw.vertex3 (0.0, 1.0, 0.0);
  GlDraw.color (0.0, 1.0, 0.0);
  GlDraw.vertex3 (-1.0, -1.0, 1.0);
  GlDraw.color (0.0, 0.0, 1.0);
  GlDraw.vertex3 (1.0, -1.0, 1.0);

  GlDraw.color (1.0, 0.0, 0.0);
  GlDraw.vertex3 (0.0, 1.0, 0.0);
  GlDraw.color (0.0, 0.0, 1.0);
  GlDraw.vertex3 (1.0, -1.0, 1.0);
  GlDraw.color (0.0, 1.0, 0.0);
  GlDraw.vertex3 (1.0, -1.0, -1.0);

  GlDraw.color (1.0, 0.0, 0.0);
  GlDraw.vertex3 (0.0, 1.0, 0.0);
  GlDraw.color (0.0, 1.0, 0.0);
  GlDraw.vertex3 (1.0, -1.0, -1.0);
  GlDraw.color (0.0, 0.0, 1.0);
  GlDraw.vertex3 (-1.0, -1.0, -1.0);

  GlDraw.color (1.0, 0.0, 0.0);
  GlDraw.vertex3 (0.0, 1.0, 0.0);
  GlDraw.color (0.0, 0.0, 1.0);
  GlDraw.vertex3 (-1.0, -1.0, -1.0);
  GlDraw.color (0.0, 1.0, 0.0);
  GlDraw.vertex3 (-1.0, -1.0, 1.0);

  GlDraw.ends ();

  GlMat.load_identity ();
  GlMat.translate ~x:1.5 ~y:0.0 ~z:(-7.0) ();
  GlMat.rotate ~angle:!rquad ~x:1.0 ~y:1.0 ~z:1.0 ();
  
  GlDraw.begins `quads;

  GlDraw.color (0.0, 1.0, 0.0);
  GlDraw.vertex3 (1.0, -1.0, -1.0);
  GlDraw.vertex3 (-1.0, 1.0, -1.0);
  GlDraw.vertex3 (-1.0, 1.0, 1.0);
  GlDraw.vertex3 (1.0, 1.0, 1.0);

  GlDraw.color (1.0, 0.5, 0.0);
  GlDraw.vertex3 (1.0, -1.0, 1.0);
  GlDraw.vertex3 (-1.0, -1.0, 1.0);
  GlDraw.vertex3 (-1.0, -1.0, -1.0);
  GlDraw.vertex3 (1.0, -1.0, -1.0);

  GlDraw.color (1.0, 0.0, 0.0);
  GlDraw.vertex3 (1.0, 1.0, 1.0);
  GlDraw.vertex3 (-1.0, 1.0, 1.0);
  GlDraw.vertex3 (-1.0, -1.0, 1.0);
  GlDraw.vertex3 (1.0, -1.0, 1.0);

  GlDraw.color (1.0, 1.0, 0.0);
  GlDraw.vertex3 (1.0, -1.0, -1.0);
  GlDraw.vertex3 (-1.0, -1.0, -1.0);
  GlDraw.vertex3 (-1.0, 1.0, -1.0);
  GlDraw.vertex3 (1.0, 1.0, -1.0);

  GlDraw.color (0.0, 0.0, 1.0);
  GlDraw.vertex3 (-1.0, 1.0, 1.0);
  GlDraw.vertex3 (-1.0, 1.0, -1.0);
  GlDraw.vertex3 (-1.0, -1.0, -1.0);
  GlDraw.vertex3 (-1.0, -1.0, 1.0);

  GlDraw.color (1.0, 0.0, 1.0);
  GlDraw.vertex3 (1.0, 1.0, -1.0);
  GlDraw.vertex3 (1.0, 1.0, 1.0);
  GlDraw.vertex3 (1.0, -1.0, 1.0);
  GlDraw.vertex3 (1.0, -1.0, -1.0);

  GlDraw.ends ();

  rtri := !rtri +. 0.2;
  rquad := !rquad -. 0.15;

  area#swap_buffers ()

let killGLWindow () =
  () (* do nothing *)

let createGLWindow title width height bits fullscreen =
  let w = GWindow.window ~title:title () in
  w#connect#destroy ~callback:(fun () -> GMain.Main.quit (); exit 0);
  w#set_resize_mode `IMMEDIATE;
  let area = GlGtk.area [`DOUBLEBUFFER;`RGBA;`DEPTH_SIZE 16;`BUFFER_SIZE bits]
      ~width:width ~height:height~packing:w#add () in
  area#event#add [`KEY_PRESS];

  w#event#connect#key_press ~callback:
    begin fun ev ->
      let key = GdkEvent.Key.keyval ev in
      if key = GdkKeysyms._Escape then w#destroy ();
      true
    end;

  GMain.Timeout.add ~ms:20 ~callback:
    begin fun () ->
      drawGLScene area (); true
    end;

  area#connect#display ~callback:(drawGLScene area);
  area#connect#reshape ~callback:resizeGLScene;

  area#connect#realize ~callback:
    begin fun () ->
      initGL ();
      resizeGLScene ~width ~height
    end;
  w#show ();

  w
let _ =
      let w = createGLWindow "Tutorial 5" 640 480 16 false in
        GMain.Main.main ()


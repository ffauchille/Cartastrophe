module Vm = ObjMaker.VertexMap
let zoom = ref 70.0
let map = ref None
let w = ref 0. and h = ref 0.
let resizeGLScene ~width ~height =
  let ok_height =
    if height = 0 then 1 else height in

  w:=float_of_int width;
  h:=float_of_int ok_height;
  GlDraw.viewport 0 0 width ok_height;

  GlMat.mode `projection;
  GlMat.load_identity ();
  
  GluMat.perspective ~fovy:!zoom ~aspect:((!w)/.(!h)) ~z:(0.001, 10000.0);
    
  GlMat.mode `modelview;
  GlMat.load_identity ()


let initGL () =
  GlDraw.shade_model `smooth;
  GlClear.color ~alpha:1.0 (1.0, 0.0, 1.0);

  GlClear.depth 1.0;
  Gl.enable `depth_test;
  GlFunc.depth_func `lequal;

  GlMisc.hint `perspective_correction `nicest

let drawMap vmap flist () =
    let f i=
        let (c,vx) =
        try
            ObjMaker.VertexMap.find i vmap
        with Not_found -> ((0.,0.,0.),(0.,0.,0.)) 
        in
        GlDraw.color c;
        GlDraw.vertex3 vx; 
    in
    let g (i,j,k) = (f i);(f j);(f k) in
  GlDraw.begins `triangles;
  List.iter g flist;
  GlDraw.ends ()

(* let drawMap vmap flist=memoize (drawMap vmap flist) *)
let deleteMap () = match !map with |Some list -> GlList.delete list;map:=None |None -> ()
let callCompileMap vmap flist =
    match !map with 
    | None -> 
            begin 
            map :=Some (GlList.create `compile);
            drawMap vmap flist ();
            GlList.ends ()
            end
    | Some list -> GlList.call list
let rx=ref 0. and ry = ref 90. and rz = ref 180.
let tx=ref (-30.) and ty = ref (0.) and tz = ref (-70.)
let ap=ref true and wf = ref false
let c r p s= 
    if s = 1 then
        r:=!r+.p
    else
        r:=!r-.p;
     ()
let translateX s= c tx 1. s
let translateY s= c ty 1. s
let translateZ s= c tz 1. s

let rotateX s= c rx 1.5 s
let rotateY s= c ry 1.5 s
let rotateZ s= c rz 1.5 s
let doZoom s = c zoom 5. s
let autoplay ()= if !ap then rotateY 1
let toggle_autoplay () = ap := not (!ap); ()
let resetCamera ()=
    rx:=0.; ry:=90.; rz:=180.; tx:=(-30.); ty:=0.; tz := (-70.);()
(* let toggleWireframe () = 
    Gl.polygonMode `front_and_back `line *)

let drawScene area vmap flist ()=
  area#make_current ();
  GlMat.mode `projection;
  GlMat.load_identity ();
  (* Zoom *)
  GluMat.perspective ~fovy:!zoom ~aspect:((!w)/.(!h)) ~z:(0.001, 10000.0);
  
  GlMat.mode `modelview;
  GlClear.clear [`color; `depth];
  GlMat.load_identity ();

  (* Translations *)
  GlMat.translate ~x:!tx ~y:!ty ~z:!tz ();
  (* Rotations selons les 3 axes *)
  GlMat.rotate ~angle:!rx ~x:1.0 ~y:0.0 ~z:0.0 ();
  GlMat.rotate ~angle:!ry ~x:0.0 ~y:1.0 ~z:0.0 ();
  GlMat.rotate ~angle:!rz ~x:0.0 ~y:0.0 ~z:1.0 ();
  callCompileMap vmap flist; 
  autoplay ();
  area#swap_buffers ()

let killGLWindow () =
  () (* do nothing *)
let sw foo = ()
let lastTo = ref (Glib.Timeout.add ~ms:999 ~callback:(fun () -> true))
let display area width height vmap flist=
    (* let (_vmap,_flist) = test () in 
    let display_keys key value= print_int key in
    Vm.iter display_keys _vmap;
    if Vm.is_empty _vmap then
        print_string "VMAP EST VIDE !!!";*)
  initGL ();
  deleteMap (); 
  w:=float_of_int width;
  h:=float_of_int height;
  GMain.Timeout.remove !lastTo;
  lastTo := (GMain.Timeout.add ~ms:20 ~callback:
  begin fun () ->
     drawScene area vmap flist ();
     true
  end;); 
  area#connect#display ~callback:(drawScene area vmap flist);
  area#connect#reshape ~callback:resizeGLScene;
  area#connect#realize ~callback:
    begin fun () ->
      initGL ();
      resizeGLScene ~width ~height
    end




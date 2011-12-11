module Vm = ObjMaker.VertexMap
let rtri = ref 0.0
let zoom = ref 70.0
let vmap   = ref Vm.empty
let flist  = ref []
let w = ref 0. and h = ref 0.
let resizeGLScene ~width ~height =
  let ok_height =
    if height = 0 then 1 else height in

  w:=float_of_int width;
  h:=float_of_int ok_height;
  GlDraw.viewport 0 0 width ok_height;

  GlMat.mode `projection;
  GlMat.load_identity ();
  
  GluMat.perspective ~fovy:!zoom ~aspect:((!w)/.(!h)) ~z:(0.1, 100.0);
    
  GlMat.mode `modelview;
  GlMat.load_identity ()
let memoize f =
    let display_list = ref None in
    fun () -> match !display_list with
    | Some list -> GlList.call list
    | None ->
        display_list := Some (GlList.create `compile);
        f();
        GlList.ends () 
let test () = 
    let vmap=ref Vm.empty and
    flist=ref [] in
    vmap:=Vm.add 1 ((1.,0.,0.),(0.,1.,0.)) !vmap;
    vmap:=Vm.add 2 ((0.,1.,0.),(-1.,-1.,1.)) !vmap;
    vmap:=Vm.add 3 ((0.,0.,1.),(1.,-1.,1.)) !vmap;
    flist := (1,2,3)::!flist;

    vmap:=Vm.add 4 ((1.,0.,0.),(0.,1.,0.)) !vmap;
    vmap:=Vm.add 5 ((0.,0.,1.),(1.,-1.,1.)) !vmap;
    vmap:=Vm.add 6 ((0.,1.,0.),(1.,-1.,-1.)) !vmap;
    flist := (4,5,6)::!flist;
    
    vmap:=Vm.add 7 ((1.,0.,0.),(0.,1.,0.)) !vmap;
    vmap:=Vm.add 8 ((0.,1.,0.),(1.,-1.,-1.)) !vmap;
    vmap:=Vm.add 9 ((0.,0.,1.),(-1.,-1.,-1.)) !vmap;
    flist := (7,9,9)::!flist;

    vmap:=Vm.add 10 ((1.,0.,0.),(0.,1.,0.)) !vmap;
    vmap:=Vm.add 11 ((0.,0.,1.),(-1.,-1.,-1.)) !vmap;
    vmap:=Vm.add 12 ((0.,1.,0.),(-1.,-1.,1.)) !vmap;
    flist := (10,11,12)::!flist;

    (!vmap,!flist)
    
let initGL () =
  GlDraw.shade_model `smooth;
    print_string "PATATE"; 
  GlClear.color ~alpha:1.0 (1.0, 1.0, 0.0);

  GlClear.depth 1.0;
  Gl.enable `depth_test;
  GlFunc.depth_func `lequal;

  GlMisc.hint `perspective_correction `nicest
(* module VertexMap = Map.Make(Int32) *)
let drawMap () =
    let f i=
        let (c,vx) =
        try
            ObjMaker.VertexMap.find i !vmap
        with Not_found -> ((0.,0.,0.),(0.,0.,0.)) 
        in
        GlDraw.color c;
        GlDraw.vertex3 vx; 
    in
    let g (i,j,k) = (f i);(f j);(f k) in
  GlDraw.begins `triangles;

  List.iter g !flist;

  GlDraw.ends (); ()
let drawMap = memoize drawMap
let rx=ref 0. and ry = ref 90. and rz = ref 180.
let tx=ref (-30.) and ty = ref (0.) and tz = ref (-70.)
let ap=ref true
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

let drawScene area ()=
  area#make_current ();
  GlClear.clear [`color; `depth];
  GlMat.load_identity ();

  GlMat.translate ~x:!tx ~y:!ty ~z:!tz ();

  GlMat.rotate ~angle:!rx ~x:1.0 ~y:0.0 ~z:0.0 ();
  GlMat.rotate ~angle:!ry ~x:0.0 ~y:1.0 ~z:0.0 ();
  GlMat.rotate ~angle:!rz ~x:0.0 ~y:0.0 ~z:1.0 ();
  
(*  GluMat.perspective ~fovy:!zoom ~aspect:((!w)/.(!h)) ~z:(0.1, 100.0);*)
    
  drawMap ();
  autoplay ();
  area#swap_buffers ()

let killGLWindow () =
  () (* do nothing *)
let sw foo = ()
let display area width height _vmap _flist=
    (* let (_vmap,_flist) = test () in 
    let display_keys key value= print_int key in
    Vm.iter display_keys _vmap;
    if Vm.is_empty _vmap then
        print_string "VMAP EST VIDE !!!";*)
  vmap:=_vmap;
  flist:=_flist;
  w:=float_of_int width;h:=float_of_int height;
  sw (GMain.Timeout.add ~ms:20 ~callback:
  begin fun () ->
     drawScene area ();
     true
  end;);

  area#connect#display ~callback:(drawScene area);
  area#connect#reshape ~callback:resizeGLScene;
  area#connect#realize ~callback:
    begin fun () ->
      initGL ();
      resizeGLScene ~width ~height
    end




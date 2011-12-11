let rtri = ref 0.0
let zoom = ref 0.
let resizeGLScene ~width ~height =
  let ok_height =
    if height = 0 then 1 else height in

  GlDraw.viewport 0 0 width ok_height;

  GlMat.mode `projection;
  GlMat.load_identity ();
  
  GluMat.perspective ~fovy:70.0
    ~aspect:((float_of_int width)/.(float_of_int ok_height)) ~z:(0.1, 100.0);
    
  GlMat.mode `modelview;
  GlMat.load_identity ()
module Vm = ObjMaker.VertexMap 
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
        GlDraw.vertex3 vx; 
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

  area#swap_buffers ()
  


let killGLWindow () =
  () (* do nothing *)
let sw foo = ()
let display area width height vmap flist=
(*    let (vmap,flist) = test () in
    let display_keys key value= print_int key in
    Vm.iter display_keys vmap;
    if Vm.is_empty vmap then
        print_string "VMAP EST VIDE !!!";*)
  sw (GMain.Timeout.add ~ms:100 ~callback:
  begin fun () ->
     drawMap area vmap flist ();
     true
  end;);

  area#connect#display ~callback:(drawMap area vmap flist);
  area#connect#reshape ~callback:resizeGLScene;
  area#connect#realize ~callback:
    begin fun () ->
      initGL ();
      resizeGLScene ~width ~height
    end




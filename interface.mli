val width : int ref
val height : int ref
val backgroundimage : string ref
val interval : int ref
val filenameimage : string ref
val load_picture : string -> Sdlvideo.surface
val image_processing : string -> unit
val setCaption : title:string -> icon:string -> unit
val window : GWindow.window
val vbox : GPack.box
val hbox : GPack.box
val bbox : GPack.button_box
val frame_image_treated : GBin.frame
val frame_visualisation : GBin.frame
exception IsNone
val s_of_s_o : 'a option -> 'a
val may_print : < filename : string option; .. > -> unit -> unit
val image_filter : GFile.filter
val map_button : GFile.chooser_button
val about_button : GButton.button
val quit : GButton.button
val sw : 'a -> unit
val init : unit -> unit

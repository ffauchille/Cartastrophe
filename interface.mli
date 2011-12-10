val width : int ref
val height : int ref
val namefile : string ref
val namefiletreated : string ref
val interval : int ref
val setSize : 'a -> 'b -> unit
val setCaption : title:string -> icon:string -> unit
val window : GWindow.window
val vbox : GPack.box
val hbox : GPack.box
val bbox : GPack.button_box
val frame_image_treated : GBin.frame
val frame_visualisation : GBin.frame
val open_button : GFile.chooser_button
val image_filter : ?mime_types:string list -> unit -> GFile.filter
val help : GButton.button
val about_button : GButton.button
val quit : GButton.button
val imageview : GMisc.image
val imagetreatedview : GMisc.image
val imagetreated : GMisc.drawing_area
val sw : 'a -> unit
val init : unit -> unit

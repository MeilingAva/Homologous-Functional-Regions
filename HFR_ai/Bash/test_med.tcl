set colscalebarflag 1
redraw;
setfile rgb "1.tiff";
rotate_brain_y 180
puts $rgb;
redraw;
save_tiff 1.tiff;
redraw;
exit

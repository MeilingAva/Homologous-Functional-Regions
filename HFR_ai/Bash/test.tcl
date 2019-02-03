redraw;
setfile rgb "1.tiff";
set colscalebarflag 1
puts $rgb;
redraw;
save_tiff 1.tiff;
redraw;
exit

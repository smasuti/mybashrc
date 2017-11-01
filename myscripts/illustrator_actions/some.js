#target illustrator

function log10(val) {
  return Math.log(val) / Math.LN10;
}


docRef=app.activeDocument;
for (var i = 1; i <= 11; i++) {
    var pointTextRef = docRef.textFrames.add();
    pointTextRef.contents = ""+i;
    pointTextRef.translate(10,400*log10(i));
};

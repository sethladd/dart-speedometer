import 'dart:html';
import 'dart:math' as Math;

class Speedometer {
  final CanvasElement canvas;
  final CanvasRenderingContext2D ctx;
  final int centerX;
  final int centerY;
  final int radius;
  final int outerRadius;
  int levelRadius;
  
  Speedometer(canvas, {this.centerX: 210, this.centerY: 210, this.radius: 140, this.outerRadius: 200}) :
      canvas = canvas,
      ctx = canvas.context2D {
    levelRadius = radius - 10;
  }
  
  void draw() {
    _drawOuterMetalicArc();
    _drawInnerMetalicArc();
    _drawBackground();
    _drawSmallTickMarks();
    _drawLargeTickMarks();
    _drawTextMarkers();
  }
  
  _drawOuterMetalicArc() {
    /* Draw the metallic border of the speedometer
     * Outer grey area
     */
    ctx.beginPath();
 
    // Nice shade of grey
    ctx.fillStyle = "rgb(127,127,127)";
 
    // Draw the outer circle
    ctx.arc(centerX,
        centerY,
        radius,
        0,
        Math.PI,
        true);
 
    // Fill the last object
    ctx.fill();
  }
  
  _drawInnerMetalicArc() {
    /* Draw the metallic border of the speedometer
     * Inner white area
     */
 
    ctx.beginPath();
 
    // White
    ctx.fillStyle = "rgb(255,255,255)";
 
    // Outer circle (subtle edge in white->grey)
    ctx.arc(centerX,
            centerY,
            (radius / 100) * 90,
            0,
            Math.PI,
            true);
 
    ctx.fill();
  }
  
  _drawBackground() {
    /* Black background with alphs transparency to
     * blend the edges of the metallic edge and
     * black background
     */
 
    ctx.globalAlpha = 0.2;
    ctx.fillStyle = "rgb(0,0,0)";
 
    // Draw semi-transparent circles
    for (var i = 170; i < 180 ; i++) {
      ctx.beginPath();

      ctx.arc(centerX,
          centerY,
          1 * i, 0,
          Math.PI,
          true);

      ctx.fill();
    }
  }
  
  _drawSmallTickMarks() {
    /* The small tick marks against the coloured
     * arc drawn every 5 mph from 10 degrees to
     * 170 degrees.
     */
    
    var tickvalue = levelRadius - 8;
    var iTick = 0;
    var iTickRad = 0;
    
    _applyDefaultContextSettings();
    
    // Tick every 20 degrees (small ticks)
    for (iTick = 10; iTick < 180; iTick += 20) {
        iTickRad = _degToRad(iTick);
    
        /* Calculate the X and Y of both ends of the
         * line I need to draw at angle represented at Tick.
         * The aim is to draw the a line starting on the
         * coloured arc and continueing towards the outer edge
         * in the direction from the center of the gauge.
         */
    
        var onArchX = radius - (Math.cos(iTickRad) * tickvalue);
        var onArchY = radius - (Math.sin(iTickRad) * tickvalue);
        var innerTickX = radius - (Math.cos(iTickRad) * radius);
        var innerTickY = radius - (Math.sin(iTickRad) * radius);
    
        var fromX = (centerX - radius) + onArchX;
        var fromY = (centerY - radius) + onArchY;
    
        var toX = (centerX - radius) + innerTickX;
        var toY = (centerY - radius) + innerTickY;
    
        // Draw the line
        _drawLine(alpha: 0.6,
                 lineWidth: 3,
                 fillStyle: "rgb(127,127,127)",
                 fromX: fromX,
                 fromY: fromY,
                 toX: toX,
                 toY: toY);
    
    }
  }

  _drawLargeTickMarks() {
      /* The large tick marks against the coloured
       * arc drawn every 10 mph from 10 degrees to
       * 170 degrees.
       */

      var tickvalue = levelRadius - 8,
          iTick = 0,
            iTickRad = 0,
            innerTickY,
            innerTickX,
            onArchX,
            onArchY,
            fromX,
            fromY,
            toX,
            toY;

      _applyDefaultContextSettings();

      tickvalue = levelRadius - 2;

      // 10 units (major ticks)
      for (iTick = 20; iTick < 180; iTick += 20) {

        iTickRad = _degToRad(iTick);

        /* Calculate the X and Y of both ends of the
         * line I need to draw at angle represented at Tick.
         * The aim is to draw the a line starting on the 
         * coloured arc and continueing towards the outer edge
         * in the direction from the center of the gauge. 
         */

        onArchX = radius - (Math.cos(iTickRad) * tickvalue);
        onArchY = radius - (Math.sin(iTickRad) * tickvalue);
        innerTickX = radius - (Math.cos(iTickRad) * radius);
        innerTickY = radius - (Math.sin(iTickRad) * radius);

        fromX = (centerX - radius) + onArchX;
        fromY = (centerY - radius) + onArchY;
        toX = (centerX - radius) + innerTickX;
        toY = (centerY - radius) + innerTickY;

        // Draw the line
        _drawLine(alpha: 0.6,
                 lineWidth: 3,
                 fillStyle: "rgb(127,127,127)",
                 fromX: fromX,
                 fromY: fromY,
                 toX: toX,
                 toY: toY);
      }
  }

  _applyDefaultContextSettings() {
    /* Helper function to revert to gauges
     * default settings
     */

    ctx.lineWidth = 2;
    ctx.globalAlpha = 0.5;
    ctx.strokeStyle = "rgb(255, 255, 255)";
    ctx.fillStyle = 'rgb(255,255,255)';
  }

  double _degToRad(angle) => ((angle * Math.PI) / 180);

  _drawLine({double alpha, int lineWidth, int fillStyle, int fromX, int fromY, int toX, int toY}) {
    // Draw a line using the line object passed in
    ctx.beginPath();

    // Set attributes of open
    ctx.globalAlpha = alpha;
    ctx.lineWidth = lineWidth;
    ctx.fillStyle = fillStyle;
    ctx.strokeStyle = fillStyle;
    ctx.moveTo(fromX, fromY);

    // Plot the line
    ctx.lineTo(toX, toY);

    ctx.stroke();
  }

  _drawTextMarkers() {
    /* The text labels marks above the coloured
     * arc drawn every 10 mph from 10 degrees to
     * 170 degrees.
     */
    var innerTickX = 0,
        innerTickY = 0,
          iTick = 0,
          iTickToPrint = 0;

    _applyDefaultContextSettings();

    // Font styling
    ctx.font = 'italic 10px sans-serif';
    ctx.textBaseline = 'top';

    ctx.beginPath();

    // Tick every 20 (small ticks)
    for (iTick = 10; iTick < 180; iTick += 20) {

      innerTickX = radius - (Math.cos(_degToRad(iTick)) * radius);
      innerTickY = radius - (Math.sin(_degToRad(iTick)) * radius);

      // Some cludging to center the values (TODO: Improve)
      if (iTick <= 10) {
        ctx.fillText(iTickToPrint.toString(), (centerX - radius - 12) + innerTickX,
            (centerY - radius - 12) + innerTickY + 5);
      } else if (iTick < 50) {
        ctx.fillText(iTickToPrint.toString(), (centerX - radius - 12) + innerTickX - 5,
            (centerY - radius - 12) + innerTickY + 5);
      } else if (iTick < 90) {
        ctx.fillText(iTickToPrint.toString(), (centerX - radius - 12) + innerTickX,
            (centerY - radius - 12) + innerTickY);
      } else if (iTick == 90) {
        ctx.fillText(iTickToPrint.toString(), (centerX - radius - 12) + innerTickX + 4,
            (centerY - radius - 12) + innerTickY);
      } else if (iTick < 145) {
        ctx.fillText(iTickToPrint.toString(), (centerX - radius - 12) + innerTickX + 10,
            (centerY - radius - 12) + innerTickY);
      } else {
        ctx.fillText(iTickToPrint.toString(), (centerX - radius - 12) + innerTickX + 15,
            (centerY - radius - 12) + innerTickY + 5);
      }

      // MPH increase by 10 every 20 degrees
      iTickToPrint += 10;
    }

      ctx.stroke();
  }
}
QB.start();
QB.setTypeMap({
  GXPOSITION: [
    { name: "x", type: "LONG" },
    { name: "y", type: "LONG" },
  ],
  GXDEVICEINPUT: [
    { name: "deviceId", type: "INTEGER" },
    { name: "deviceType", type: "INTEGER" },
    { name: "inputType", type: "INTEGER" },
    { name: "inputId", type: "INTEGER" },
    { name: "inputValue", type: "INTEGER" },
  ],
  FETCHRESPONSE: [
    { name: "ok", type: "INTEGER" },
    { name: "status", type: "INTEGER" },
    { name: "statusText", type: "STRING" },
    { name: "text", type: "STRING" },
  ],
  SHAPE: [
    { name: "name", type: "STRING" },
    { name: "x", type: "INTEGER" },
    { name: "y", type: "INTEGER" },
    { name: "w", type: "SINGLE" },
    { name: "h", type: "SINGLE" },
    { name: "shape", type: "INTEGER" },
    { name: "shape_p1", type: "SINGLE" },
    { name: "shape_p2", type: "SINGLE" },
    { name: "k_fill", type: "_UNSIGNED LONG" },
    { name: "k_stroke", type: "_UNSIGNED LONG" },
    { name: "stroke_w", type: "SINGLE" },
  ],
  LAYER: [
    { name: "name", type: "STRING" },
    { name: "img", type: "LONG" },
    { name: "z_index", type: "INTEGER" },
    { name: "x", type: "INTEGER" },
    { name: "y", type: "INTEGER" },
    { name: "opacity", type: "SINGLE" },
  ],
  ANIMATION: [
    { name: "name", type: "STRING" },
    { name: "frame_start", type: "INTEGER" },
    { name: "frame_end", type: "INTEGER" },
    { name: "frame_duration", type: "SINGLE" },
    { name: "anim_duration", type: "SINGLE" },
  ],
  FRAME: [
    { name: "img", type: "LONG" },
    { name: "duration", type: "SINGLE" },
  ],
  KEYFRAME: [
    { name: "x", type: "INTEGER" },
    { name: "y", type: "INTEGER" },
    { name: "w", type: "INTEGER" },
    { name: "h", type: "INTEGER" },
    { name: "ease_in", type: "INTEGER" },
    { name: "ease_out", type: "INTEGER" },
    { name: "scale_w", type: "SINGLE" },
    { name: "scale_h", type: "SINGLE" },
    { name: "opacity", type: "SINGLE" },
  ],
});
await GX.registerGameEvents(function (e) {});
QB.sub_Screen(0);

const W = 1400;
const H = 256;
var CANVAS = 0; /* LONG */
CANVAS = QB.func__NewImage(W, H, 32);
QB.sub_Screen(CANVAS);

var k_pumpkin_orange = 0;
/* _UNSIGNED LONG */ var k_pumpkin_black = 0;
/* _UNSIGNED LONG */ var k_pumpkin_candle = 0; /* _UNSIGNED LONG */
k_pumpkin_orange = QB.func__RGB32(
  QB.func_Val("&HFF"),
  QB.func_Val("&H99"),
  QB.func_Val("&H00")
);
k_pumpkin_black = QB.func__RGB32(
  QB.func_Val("&H39"),
  QB.func_Val("&H00"),
  QB.func_Val("&H71")
);
k_pumpkin_candle = QB.func__RGB32(
  QB.func_Val("&HFF"),
  QB.func_Val("&HFF"),
  QB.func_Val("&H82")
);
QB.end();

/// The visual and physical behavior mode of a liquid gooey element.
enum LiquidEffect {
  /// Pieces merge gooily, change shape like jelly, and adapt corners.
  morph,

  /// The surface trails a moving element with velocity stretch and trailing satellites.
  move,

  /// The surface deforms with velocity bows and cap expansion.
  bend,

  /// Two image-filled cards run molten and dissolve at contact seams.
  melt,
}

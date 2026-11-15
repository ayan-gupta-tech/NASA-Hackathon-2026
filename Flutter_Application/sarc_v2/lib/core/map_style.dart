/// Google Maps "night" style used when the app is in dark mode
/// (only applied to the Default and Terrain map types).
const String darkMapStyle = r'''
[
  {"elementType":"geometry","stylers":[{"color":"#1d2535"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#8ea0bf"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#1d2535"}]},
  {"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#3a4a68"}]},
  {"featureType":"landscape.natural","elementType":"geometry","stylers":[{"color":"#1a2231"}]},
  {"featureType":"poi","stylers":[{"visibility":"off"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#2c3850"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3b4b6b"}]},
  {"featureType":"transit","stylers":[{"visibility":"off"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#0b1424"}]}
]
''';

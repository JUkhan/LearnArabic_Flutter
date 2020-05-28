import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/util.dart';
import 'package:learn_arabic/widgets/CircleColor.dart';

class ColorThemeWidget extends StatefulWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChange;
  //final ValueChanged<ColorSwatch> onMainColorChange;
  //final List<ColorSwatch> colors;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  //final bool allowShades;
  //final bool onlyShadeSelection;
  final double circleSize;
  final double spacing;
  final IconData iconSelected;
  //final VoidCallback onBack;
  final double elevation;

  const ColorThemeWidget({
    Key key,
    this.selectedColor,
    this.onColorChange,
    //this.onMainColorChange,
    //this.colors,
    this.shrinkWrap = false,
    this.physics,
    //this.allowShades = true,
    //this.onlyShadeSelection = false,
    this.iconSelected = Icons.check,
    this.circleSize = 45.0,
    this.spacing = 9.0,
    //this.onBack,
    this.elevation,
  }) : super(key: key);

  @override
  _ColorThemeWidgetState createState() => _ColorThemeWidgetState();
}

class _ColorThemeWidgetState extends State<ColorThemeWidget> {
  //final _defaultValue = materialColors[0];

  List<Color> _colors = materialColors;

  Color _mainColor;
  //Color _shadeColor;
  //bool _isMainSelection;

  @override
  void initState() {
    super.initState();
    _initSelectedValue();
  }

  @protected
  void didUpdateWidget(covariant ColorThemeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    //_initSelectedValue();
  }

  void _initSelectedValue() {
    _mainColor = widget.selectedColor;
    /*if (widget.colors != null) _colors = widget.colors;

    Color shadeColor = widget.selectedColor ?? _defaultValue;
    ColorSwatch mainColor = _findMainColor(shadeColor);

    if (mainColor == null) {
      mainColor = _colors[0];
      shadeColor = mainColor[500] ?? mainColor[400];
    }

    setState(() {
      _mainColor = mainColor;
      _shadeColor = shadeColor;
      _isMainSelection = true;
    });*/
  }

  void _onMainColorSelected(Color color) {
    setState(() {
      _mainColor = color;
    });

    if (widget.onColorChange != null) widget.onColorChange(color);
  }

  List<Widget> _buildListMainColor(List<Color> colors) => colors
      .map((color) => CircleColor(
            color: color,
            circleSize: widget.circleSize,
            onColorChoose: () => _onMainColorSelected(color),
            isSelected: _mainColor == color,
            iconSelected: widget.iconSelected,
            elevation: widget.elevation,
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    // Size of dialog
    final double width = MediaQuery.of(context).size.width * .80;
    // Number of circle per line, depend on width and circleSize
    final int nbrCircleLine = width ~/ (widget.circleSize + widget.spacing);

    return Container(
      width: width,
      child: GridView.count(
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: widget.spacing,
        mainAxisSpacing: widget.spacing,
        crossAxisCount: nbrCircleLine,
        children: _buildListMainColor(_colors),
      ),
    );
  }
}

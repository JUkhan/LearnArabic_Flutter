import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/models/MemoModel.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';
import 'package:learn_arabic/widgets/ColorThemeWidget.dart';
import 'package:learn_arabic/widgets/NavBarWidget.dart';
import 'package:learn_arabic/widgets/Painter.dart';
import 'package:learn_arabic/widgets/TextWidget.dart';
import 'package:learn_arabic/blocs/models/PainterModel.dart';
import 'package:learn_arabic/blocs/models/CombinnedPainter.dart';

class WritingBoardWidget extends StatelessWidget {
  const WritingBoardWidget({
    Key key,
    @required this.colors,
    @required this.memo,
    @required this.lines,
    @required this.book,
  }) : super(key: key);

  final List<Color> colors;
  final MemoModel memo;
  final List<JLine> lines;
  final BookModel book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FloatingActionButton(
            heroTag: 'tags1',
            onPressed: () => dispatch('painterPrev'),
            child: Icon(Icons.navigate_before),
            tooltip: 'Previous',
            mini: true,
          ),
          FloatingActionButton(
            heroTag: 'tags2',
            onPressed: () => dispatch('painterNext'),
            child: Icon(Icons.navigate_next),
            tooltip: 'Next',
            mini: true,
          ),
          FloatingActionButton(
            heroTag: 'tags3',
            onPressed: () => dispatch('openColorPicker'),
            tooltip: 'Choose Color',
            mini: true,
            child: StreamBuilder<PainterModel>(
                initialData: PainterModel.init(),
                stream: select<PainterModel>('painter'),
                builder: (context, snapshot) {
                  return Icon(Icons.brightness_1, color: snapshot.data.color);
                }),
          ),
          FloatingActionButton(
            heroTag: 'tags5',
            onPressed: () => dispatch('clearOffset'),
            child: Icon(Icons.clear_all),
            tooltip: 'Clear All',
            mini: true,
          )
        ],
      ),
      //drawer: DrawerWidget(),
      bottomNavigationBar: NavBarWidget(),
      body: Container(
          //padding: const EdgeInsets.only(top: 5),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                color: Theme.of(context).backgroundColor,
                height: 120,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: StreamBuilder<PainterModel>(
                      initialData: PainterModel.init(),
                      stream: select<PainterModel>('painter'),
                      builder: (context, snapshot) {
                        return snapshot.data.colorPickerOpened || lines == null
                            ? Container(
                                height: 160,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      height: 120,
                                      child: ColorThemeWidget(
                                        circleSize: 30,
                                        colors: colors,
                                        onColorChange: (color) {
                                          dispatch('paintColor', color);
                                        },
                                        selectedColor: snapshot.data.color,
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      child: Slider(
                                          min: 1.0,
                                          max: 20.0,
                                          divisions: 38,
                                          label: '${snapshot.data.strokeWidth}',
                                          value: snapshot.data.strokeWidth,
                                          onChanged: (value) {
                                            dispatch('setStrokeWidth', value);
                                          }),
                                    ),
                                  ],
                                ),
                              )
                            : TextWidget(
                                line: lines[snapshot.data.currentIndex],
                                memo: memo,
                                bookModel: book,
                              );
                      }),
                ),
              ),
              GestureDetector(
                onPanDown: (details) {
                  dispatch('addOffset', details.localPosition);
                },
                onPanUpdate: (DragUpdateDetails details) {
                  dispatch('addOffset', details.localPosition);
                },
                onPanEnd: (DragEndDetails details) {
                  dispatch('addOffset', null);
                },
                child: StreamBuilder<CombinnedPainter>(
                    initialData: CombinnedPainter(PainterModel.init(), false),
                    stream: select2((m) => CombinnedPainter(m['painter'],
                        m['memo'].selectedWord?.word?.isNotEmpty)),
                    builder: (context, snapshot) {
                      return CustomPaint(
                        painter: Painter(snapshot.data.painter),
                        size: Size(
                            MediaQuery.of(context).size.width,
                            //200 -(34 + 34)
                            MediaQuery.of(context).size.height -
                                (snapshot.data.hasSelectedWord ? 268 : 200)),
                      );
                    }),
              ),
            ],
          )),
    );
  }
}

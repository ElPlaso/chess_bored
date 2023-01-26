import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

/// Page for the chess board view and state.
class ChessHomePage extends StatefulWidget {
  const ChessHomePage({super.key, required this.title});

  final String title;

  @override
  State<ChessHomePage> createState() => _ChessHomePageState();
}

class _ChessHomePageState extends State<ChessHomePage> {
  ChessBoardController controller = ChessBoardController();

  BoardColor color = BoardColor.brown;

  PlayerColor boardOrientation = PlayerColor.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Theme: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  DropdownButton<BoardColor>(
                    value: color,
                    icon: const Icon(Icons.expand_more),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onChanged: (value) {
                      setState(() {
                        color = value!;
                      });
                    },
                    items: BoardColor.values.map((BoardColor value) {
                      return DropdownMenuItem<BoardColor>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    switch (boardOrientation) {
                      case PlayerColor.white:
                        boardOrientation = PlayerColor.black;
                        break;
                      case PlayerColor.black:
                        boardOrientation = PlayerColor.white;
                        break;
                    }
                  });
                },
                icon: const Icon(
                  Icons.import_export,
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.resetBoard();
                },
                icon: const Icon(
                  Icons.restart_alt_outlined,
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: ChessBoard(
              controller: controller,
              boardColor: color,
              boardOrientation: boardOrientation,
            ),
          ),
          TextButton.icon(
            onPressed: () {
              // I have observed that this does not undo pawn moves or captures.
              controller.undoMove();
            },
            icon: const Icon(
              Icons.undo,
            ),
            label: const Text("Undo a consecutive non-pawn/capture move"),
          ),
        ],
      ),
    );
  }
}

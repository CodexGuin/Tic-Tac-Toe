import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  /* Variables */
  int xScore = 0;
  int oScore = 0;

  bool gameEnd = false;
  bool xTurn = true;

  List<String> fields = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];

  List<Color> cellColors = List<Color>.filled(9, const Color(0xFFf7b2ad));

  /* Update fields */
  void fieldTap(int idx) {
    setState(() {
      if (!gameEnd && fields[idx] == '') {
        fields[idx] = xTurn ? 'X' : 'O';
        xTurn = !xTurn;
        gameLogic();
      }
    });
  }

  /* Game logic */
  void gameLogic() {
    final List<List<int>> winningConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (final condition in winningConditions) {
      if (fields[condition[0]] == fields[condition[1]] &&
          fields[condition[1]] == fields[condition[2]] &&
          fields[condition[0]] != '') {
        gameEnd = true;

        if (fields[condition[0]] == 'X') {
          xScore++;
        } else {
          oScore++;
        }

        setState(() {
          for (final index in condition) {
            cellColors[index] = Colors.green;
          }
        });

        break;
      }
    }

    // Check for a draw
    if (!gameEnd && fields.every((element) => element.isNotEmpty)) {
      gameEnd = true;
    }
  }

  /* Restart button */
  void restartGame() {
    setState(() {
      fields.fillRange(0, fields.length, '');
      cellColors.fillRange(0, cellColors.length, const Color(0xFFf7b2ad));
      gameEnd = false;
      xTurn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333232),
      appBar: AppBar(
        title: const Text("Tic Tac Toe!"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt_sharp),
            onPressed: restartGame,
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Score section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildScoreTile('X', xScore, Colors.red),
                  _buildScoreTile('O', oScore, Colors.blue),
                ],
              ),
              // Playing field
              SizedBox(
                height: MediaQuery.of(context).size.width,
                child: Container(
                  color: const Color(0xFF333232),
                  child: GridView.builder(
                    itemCount: 9,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => fieldTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: cellColors[index],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFF333232),
                                blurRadius: 4,
                                spreadRadius: 3,
                                blurStyle: BlurStyle.outer,
                              ),
                            ],
                          ),
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 100),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Text(
                                fields[index],
                                key: ValueKey<String>(fields[index]),
                                style: const TextStyle(
                                  fontSize: 100,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF210b2c),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreTile(String player, int score, Color color) {
    return Column(
      children: [
        Text(
          player,
          style: TextStyle(
              fontSize: 50, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          score.toString(),
          style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

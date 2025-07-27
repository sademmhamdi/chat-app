import 'package:flutter/material.dart';

class GamesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        children: [
          GameCard(
            title: 'Tic Tac Toe',
            icon: Icons.grid_3x3,
            color: Colors.blue,
            onTap: () => _navigateToGame(context, 'tictactoe'),
          ),
          GameCard(
            title: 'Word Guess',
            icon: Icons.quiz,
            color: Colors.green,
            onTap: () => _navigateToGame(context, 'wordguess'),
          ),
          GameCard(
            title: 'Rock Paper Scissors',
            icon: Icons.back_hand,
            color: Colors.orange,
            onTap: () => _navigateToGame(context, 'rps'),
          ),
          GameCard(
            title: 'Number Guess',
            icon: Icons.numbers,
            color: Colors.purple,
            onTap: () => _navigateToGame(context, 'numberguess'),
          ),
        ],
      ),
    );
  }

  void _navigateToGame(BuildContext context, String gameType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(chatRoomId: '', gameType: gameType),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const GameCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.8), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }
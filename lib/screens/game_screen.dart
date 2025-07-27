import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../models/message_model.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  final String chatRoomId;
  final String gameType;

  const GameScreen({
    Key? key,
    required this.chatRoomId,
    this.gameType = 'tictactoe',
  }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getGameTitle()),
      ),
      body: _buildGameWidget(),
    );
  }

  String _getGameTitle() {
    switch (widget.gameType) {
      case 'tictactoe':
        return 'Tic Tac Toe';
      case 'wordguess':
        return 'Word Guess';
      case 'rps':
        return 'Rock Paper Scissors';
      case 'numberguess':
        return 'Number Guess';
      default:
        return 'Game';
    }
  }

  Widget _buildGameWidget() {
    switch (widget.gameType) {
      case 'tictactoe':
        return TicTacToeGame(chatRoomId: widget.chatRoomId);
      case 'wordguess':
        return WordGuessGame(chatRoomId: widget.chatRoomId);
      case 'rps':
        return RockPaperScissorsGame(chatRoomId: widget.chatRoomId);
      case 'numberguess':
        return NumberGuessGame(chatRoomId: widget.chatRoomId);
      default:
        return Center(child: Text('Game not available'));
    }
  }
}

// Tic Tac Toe Game
class TicTacToeGame extends StatefulWidget {
  final String chatRoomId;

  const TicTacToeGame({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> board = List.filled(9, '');
  bool isPlayerXTurn = true;
  String gameStatus = 'Player X\'s turn';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            gameStatus,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _makeMove(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      board[index],
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: board[index] == 'X' ? Colors.blue : Colors.red,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _resetGame,
                  child: Text('Reset Game'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _shareResult,
                  child: Text('Share Result'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _makeMove(int index) {
    if (board[index] != '' || gameStatus.contains('wins') || gameStatus.contains('Draw')) {
      return;
    }

    setState(() {
      board[index] = isPlayerXTurn ? 'X' : 'O';
      
      if (_checkWinner()) {
        gameStatus = 'Player ${isPlayerXTurn ? 'X' : 'O'} wins!';
      } else if (board.every((cell) => cell != '')) {
        gameStatus = 'Draw!';
      } else {
        isPlayerXTurn = !isPlayerXTurn;
        gameStatus = 'Player ${isPlayerXTurn ? 'X' : 'O'}\'s turn';
      }
    });
  }

  bool _checkWinner() {
    const winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (var combination in winningCombinations) {
      if (board[combination[0]] != '' &&
          board[combination[0]] == board[combination[1]] &&
          board[combination[1]] == board[combination[2]]) {
        return true;
      }
    }
    return false;
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      isPlayerXTurn = true;
      gameStatus = 'Player X\'s turn';
    });
  }

  void _shareResult() {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (widget.chatRoomId.isNotEmpty) {
      chatService.sendMessage(
        chatRoomId: widget.chatRoomId,
        content: 'Tic Tac Toe: $gameStatus',
        senderId: authService.user!.uid,
        senderName: authService.currentUserModel?.displayName ?? 'Unknown',
        type: MessageType.game,
        gameData: {
          'gameType': 'tictactoe',
          'result': gameStatus,
          'board': board,
        },
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Game result shared!')),
    );
  }
}

// Word Guess Game
class WordGuessGame extends StatefulWidget {
  final String chatRoomId;

  const WordGuessGame({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  _WordGuessGameState createState() => _WordGuessGameState();
}

class _WordGuessGameState extends State<WordGuessGame> {
  final List<String> words = [
    'FLUTTER', 'MOBILE', 'CODING', 'CHAT', 'GAME', 'PHONE', 'SCREEN', 'BUTTON'
  ];
  
  String currentWord = '';
  String guessedWord = '';
  List<String> guessedLetters = [];
  int wrongGuesses = 0;
  final int maxWrongGuesses = 6;
  final TextEditingController _guessController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    final random = Random();
    currentWord = words[random.nextInt(words.length)];
    guessedWord = '_' * currentWord.length;
    guessedLetters.clear();
    wrongGuesses = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Word Guess Game',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Wrong guesses: $wrongGuesses / $maxWrongGuesses',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
          SizedBox(height: 20),
          Text(
            guessedWord.split('').join(' '),
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4),
          ),
          SizedBox(height: 20),
          Text(
            'Guessed letters: ${guessedLetters.join(', ')}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          if (!_isGameOver())
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _guessController,
                    decoration: InputDecoration(
                      labelText: 'Guess a letter',
                      border: OutlineInputBorder(),
                    ),
                    maxLength: 1,
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _makeGuess,
                  child: Text('Guess'),
                ),
              ],
            ),
          if (_isGameOver())
            Column(
              children: [
                Text(
                  _isWinner() ? 'You won!' : 'Game over! The word was: $currentWord',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isWinner() ? Colors.green : Colors.red,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _startNewGame,
                        child: Text('New Game'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _shareResult,
                        child: Text('Share Result'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _makeGuess() {
    final guess = _guessController.text.toUpperCase();
    if (guess.isEmpty || guessedLetters.contains(guess)) {
      return;
    }

    setState(() {
      guessedLetters.add(guess);
      
      if (currentWord.contains(guess)) {
        // Update guessed word
        String newGuessedWord = '';
        for (int i = 0; i < currentWord.length; i++) {
          if (guessedLetters.contains(currentWord[i])) {
            newGuessedWord += currentWord[i];
          } else {
            newGuessedWord += '_';
          }
        }
        guessedWord = newGuessedWord;
      } else {
        wrongGuesses++;
      }
    });

    _guessController.clear();
  }

  bool _isGameOver() {
    return _isWinner() || wrongGuesses >= maxWrongGuesses;
  }

  bool _isWinner() {
    return !guessedWord.contains('_');
  }

  void _shareResult() {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    String result = _isWinner() 
        ? 'Won word guess game! Word: $currentWord'
        : 'Lost word guess game. Word was: $currentWord';

    if (widget.chatRoomId.isNotEmpty) {
      chatService.sendMessage(
        chatRoomId: widget.chatRoomId,
        content: 'Word Guess: $result',
        senderId: authService.user!.uid,
        senderName: authService.currentUserModel?.displayName ?? 'Unknown',
        type: MessageType.game,
        gameData: {
          'gameType': 'wordguess',
          'result': result,
          'word': currentWord,
        },
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Game result shared!')),
    );
  }
}

// Rock Paper Scissors Game
class RockPaperScissorsGame extends StatefulWidget {
  final String chatRoomId;

  const RockPaperScissorsGame({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  _RockPaperScissorsGameState createState() => _RockPaperScissorsGameState();
}

class _RockPaperScissorsGameState extends State<RockPaperScissorsGame> {
  String playerChoice = '';
  String computerChoice = '';
  String result = '';
  int playerScore = 0;
  int computerScore = 0;

  final List<String> choices = ['Rock', 'Paper', 'Scissors'];
  final Map<String, IconData> choiceIcons = {
    'Rock': Icons.circle,
    'Paper': Icons.note,
    'Scissors': Icons.content_cut,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Rock Paper Scissors',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('$playerScore', style: TextStyle(fontSize: 32, color: Colors.blue)),
                ],
              ),
              Column(
                children: [
                  Text('Computer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('$computerScore', style: TextStyle(fontSize: 32, color: Colors.red)),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),
          if (playerChoice.isNotEmpty && computerChoice.isNotEmpty)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Icon(choiceIcons[playerChoice]!, size: 64, color: Colors.blue),
                        Text(playerChoice, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Text('VS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Column(
                      children: [
                        Icon(choiceIcons[computerChoice]!, size: 64, color: Colors.red),
                        Text(computerChoice, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  result,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: result.contains('Win') ? Colors.green : 
                           result.contains('Lose') ? Colors.red : Colors.orange,
                  ),
                ),
              ],
            ),
          SizedBox(height: 30),
          Text('Choose your move:', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: choices.map((choice) {
              return GestureDetector(
                onTap: () => _makeChoice(choice),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Column(
                    children: [
                      Icon(choiceIcons[choice]!, size: 40, color: Colors.blue),
                      SizedBox(height: 8),
                      Text(choice),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _resetGame,
                  child: Text('Reset Score'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _shareResult,
                  child: Text('Share Result'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _makeChoice(String choice) {
    final random = Random();
    final computerChoice = choices[random.nextInt(choices.length)];

    setState(() {
      playerChoice = choice;
      this.computerChoice = computerChoice;
      result = _determineWinner(choice, computerChoice);
      
      if (result.contains('Win')) {
        playerScore++;
      } else if (result.contains('Lose')) {
        computerScore++;
      }
    });
  }

  String _determineWinner(String player, String computer) {
    if (player == computer) {
      return 'It\'s a tie!';
    }

    if ((player == 'Rock' && computer == 'Scissors') ||
        (player == 'Paper' && computer == 'Rock') ||
        (player == 'Scissors' && computer == 'Paper')) {
      return 'You win!';
    } else {
      return 'You lose!';
    }
  }

  void _resetGame() {
    setState(() {
      playerChoice = '';
      computerChoice = '';
      result = '';
      playerScore = 0;
      computerScore = 0;
    });
  }

  void _shareResult() {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    String shareText = 'Rock Paper Scissors - Score: You $playerScore - Computer $computerScore';
    if (result.isNotEmpty) {
      shareText += ' | Last round: $result';
    }

    if (widget.chatRoomId.isNotEmpty) {
      chatService.sendMessage(
        chatRoomId: widget.chatRoomId,
        content: shareText,
        senderId: authService.user!.uid,
        senderName: authService.currentUserModel?.displayName ?? 'Unknown',
        type: MessageType.game,
        gameData: {
          'gameType': 'rps',
          'playerScore': playerScore,
          'computerScore': computerScore,
          'lastResult': result,
        },
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Game result shared!')),
    );
  }
}

// Number Guess Game
class NumberGuessGame extends StatefulWidget {
  final String chatRoomId;

  const NumberGuessGame({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  _NumberGuessGameState createState() => _NumberGuessGameState();
}

class _NumberGuessGameState extends State<NumberGuessGame> {
  int targetNumber = 0;
  int attempts = 0;
  List<String> guessHistory = [];
  bool gameWon = false;
  final TextEditingController _guessController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    final random = Random();
    targetNumber = random.nextInt(100) + 1;
    attempts = 0;
    guessHistory.clear();
    gameWon = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Number Guess Game',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Guess a number between 1 and 100',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            'Attempts: $attempts',
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
          SizedBox(height: 30),
          if (!gameWon)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _guessController,
                    decoration: InputDecoration(
                      labelText: 'Enter your guess',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _makeGuess,
                  child: Text('Guess'),
                ),
              ],
            ),
          if (gameWon)
            Column(
              children: [
                Text(
                  'Congratulations! 🎉',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                Text(
                  'You guessed $targetNumber in $attempts attempts!',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _startNewGame,
                        child: Text('New Game'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _shareResult,
                        child: Text('Share Result'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          SizedBox(height: 30),
          if (guessHistory.isNotEmpty)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Guess History:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: guessHistory.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 2),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(guessHistory[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _makeGuess() {
    final guessText = _guessController.text;
    final guess = int.tryParse(guessText);

    if (guess == null || guess < 1 || guess > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a number between 1 and 100')),
      );
      return;
    }

    setState(() {
      attempts++;
      
      if (guess == targetNumber) {
        guessHistory.add('$guess - Correct! 🎉');
        gameWon = true;
      } else if (guess < targetNumber) {
        guessHistory.add('$guess - Too low! 📈');
      } else {
        guessHistory.add('$guess - Too high! 📉');
      }
    });

    _guessController.clear();
  }

  void _shareResult() {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    String result = 'Number Guess Game: Guessed $targetNumber in $attempts attempts!';

    if (widget.chatRoomId.isNotEmpty) {
      chatService.sendMessage(
        chatRoomId: widget.chatRoomId,
        content: result,
        senderId: authService.user!.uid,
        senderName: authService.currentUserModel?.displayName ?? 'Unknown',
        type: MessageType.game,
        gameData: {
          'gameType': 'numberguess',
          'targetNumber': targetNumber,
          'attempts': attempts,
          'result': result,
        },
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Game result shared!')),
    );
  }
}

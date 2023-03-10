import 'package:bloc/bloc.dart';
import 'package:chess_bored/app/data/game_history.dart';
import 'package:chess_bored/app/models/finished_game.dart';
import 'package:chess_bored/app/models/finished_game_win_status.dart';
import 'package:chess_bored/chess_home/bloc/game_result_type.dart';
import 'package:chess_bored/chess_home/data/chess_clock_settings.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:get_it/get_it.dart';

part 'game_history_event.dart';
part 'game_history_state.dart';

class GameHistoryBloc extends Bloc<GameHistoryEvent, GameHistoryState> {
  final GameHistory _gameHistory = GetIt.instance<GameHistory>();

  GameHistoryBloc() : super(GameHistoryInitial()) {
    on<GameHistoryLoadedEvent>(_onGameHistoryLoaded);
    on<GameSavedEvent>(_onGameSaved);
    on<AllHistoryClearedEvent>(_onAllHistoryCleared);
  }

  _onGameHistoryLoaded(GameHistoryLoadedEvent event, emit) async {
    if (state is GameHistoryInitial) {
      await _gameHistory.loadGameHistory();
    }
    emit(GameHistoryLoadedState(
        _gameHistory.gameHistory.finishedGames.reversed.toList()));
  }

  _onGameSaved(GameSavedEvent event, emit) {
    FinishedGame game = FinishedGame(
        event.chessBoardController.getFen(),
        event.chessBoardController.getSan(),
        event.boardTheme,
        event.chessClockSettings,
        event.gameResultType,
        event.finishedGameWinStatus);

    _gameHistory.saveGameToList(game);

    emit(GameSavedState());
  }

  _onAllHistoryCleared(event, emit) {
    _gameHistory.clearAll();
    emit(
      const GameHistoryLoadedState([]),
    );
  }
}

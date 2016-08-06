import React from "react";
import Board from './Board';

export default class Game extends React.Component {
  static propTypes = {
    guessURL: React.PropTypes.string.isRequired,
    rowLength: React.PropTypes.number.isRequired,
    untouched: React.PropTypes.number.isRequired,
    miss: React.PropTypes.number.isRequired,
    hit: React.PropTypes.number.isRequired,
    placedShip: React.PropTypes.number.isRequired,
    playerBoard: React.PropTypes.arrayOf(React.PropTypes.object).isRequired,
    opponentBoard: React.PropTypes.arrayOf(React.PropTypes.object).isRequired,
    defaultShips: React.PropTypes.arrayOf(React.PropTypes.object).isRequired
  };

  state = {
    playerBoard: this.props.playerBoard,
    opponentBoard: this.props.opponentBoard,
    playerShips: this.initializeShips(),
    opponentShips: this.initializeShips(),
    playerTurn: true,
    gameOver: false,
    playerWon: false
  };
  guess = this.guess.bind(this);

  initializeShips() {
    return this.props.defaultShips.map((ship) => {return { ...ship, alive: ship.size}})
  }

  async guess() {
    let options = {
      method: 'POST',
      body: this.buildParams({squares: JSON.stringify(this.state.playerBoard)})
    };
    let response = await fetch(this.props.guessURL, options);
    let index = await response.text()
    this.processGuess(this.state.playerBoard[index], true)
  };

  buildParams(params) {
    let searchParams = new URLSearchParams;
    Object.keys(params).forEach(key => searchParams.append(key, params[key]));
    return searchParams
  }

  onClick = (e) => {
    if (!this.state.playerTurn) return;

    let id = e.target.getAttribute('data-board-index');
    let square = this.state.opponentBoard[id];

    if (square.status != this.props.untouched && square.status != this.props.placedShip) return; // If square is not eligible to be hit

    this.processGuess(square, false)
  };

  async processGuess(square, player, callback) {
    if (square.status == this.props.miss || square.status == this.props.hit) throw "This square has already been revealed";
    let newSquare = {...square};
    square.ship == null ? newSquare.status = this.props.miss : newSquare.status = this.props.hit
    await this.setState((previousState) => {
      let newBoard = this.immutableReplace(previousState[player ? 'playerBoard' : 'opponentBoard'], newSquare, square.index);
      return {[player ? 'playerBoard' : 'opponentBoard']: newBoard, playerTurn: !previousState.playerTurn}
    });
    if (!this.state.playerTurn) this.guess()
  }

  immutableReplace(array, elem, index) {
    return [...array.slice(0, index), elem, ...array.slice(index + 1)]
  }

  gameOverMessage() {
    return this.state.playerWon ? 'You Win!' : 'Opponent Wins'
  }

  doNothing() {}

  render() {
    return (
      <div className="game">
        <div className="game-over">
          {this.state.gameOver ? this.gameOverMessage() : ''}
        </div>

        <div className="current-player">
          {this.state.playerTurn ? 'Your Turn' : "Opponent's Turn"}
        </div>

        <Board
          board={this.state.playerBoard}
          rowLength={this.props.rowLength}
          onClick={this.doNothing}
          hover={false}
          hideShips={false}
          untouched={this.props.untouched}
          placedShip={this.props.placedShip}
          title="You"
        />

        <Board
          board={this.state.opponentBoard}
          rowLength={this.props.rowLength}
          onClick={this.onClick}
          hover={this.state.playerTurn}
          hideShips={true}
          untouched={this.props.untouched}
          placedShip={this.props.placedShip}
          title="Opponent"
        />
      </div>
    )
  }
}

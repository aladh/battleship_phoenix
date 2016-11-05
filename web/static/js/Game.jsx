import React from "react";
import Board from './Board';

export default class Game extends React.Component {
  static propTypes = {
    guessURL: React.PropTypes.string.isRequired,
    boardURL: React.PropTypes.string.isRequired,
    rowLength: React.PropTypes.number.isRequired,
    untouched: React.PropTypes.number.isRequired,
    miss: React.PropTypes.number.isRequired,
    hit: React.PropTypes.number.isRequired,
    placedShip: React.PropTypes.number.isRequired,
    playerBoard: React.PropTypes.arrayOf(React.PropTypes.object).isRequired,
    opponentBoard: React.PropTypes.arrayOf(React.PropTypes.object).isRequired,
    defaultShips: React.PropTypes.arrayOf(React.PropTypes.object).isRequired
  };

  static childContextTypes = {
    hit: React.PropTypes.number.isRequired,
    placedShip: React.PropTypes.number.isRequired,
    untouched: React.PropTypes.number.isRequired,
    rowLength: React.PropTypes.number.isRequired
  };

  state = this.initalState(this.props.playerBoard, this.props.opponentBoard);
  guess = this.guess.bind(this);
  resetGame = this.resetGame.bind(this);

  getChildContext() {
    return {
      hit: this.props.hit,
      placedShip: this.props.placedShip,
      untouched: this.props.untouched,
      rowLength: this.props.rowLength
    }
  }

  initializeShips() {
    return this.props.defaultShips.map((ship) => {return { ...ship, alive: ship.size}})
  }

  initalState(playerBoard, opponentBoard) {
    return {
      playerBoard: playerBoard,
      opponentBoard: opponentBoard,
      playerShips: this.initializeShips(),
      opponentShips: this.initializeShips(),
      playerTurn: true,
      gameOver: false,
      playerWon: false
    }
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

  async getNewBoard() {
    let response = await fetch(this.props.boardURL);
    let board = await response.json();
    return board.squares
  }

  onClick = (e) => {
    if (!this.state.playerTurn) return;

    let id = e.target.getAttribute('data-board-index');
    let square = this.state.opponentBoard[id];

    if (square.status != this.props.untouched && square.status != this.props.placedShip) return; // If square is not eligible to be hit

    this.processGuess(square, false)
  };

  async processGuess(square, player, callback) {
    if (this.state.gameOver) return;
    if (square.status == this.props.miss || square.status == this.props.hit) throw "This square has already been revealed";
    let newSquare = {...square};
    square.ship == null ? newSquare.status = this.props.miss : newSquare.status = this.props.hit
    if (newSquare.ship) {
      let oldShip = this.state[player ? 'playerShips' : 'opponentShips'][newSquare.ship.id - 1]
      var newShip = {...oldShip, alive: oldShip.alive - 1}
    }

    await this.setState((previousState) => {
      let newBoard = this.immutableReplace(previousState[player ? 'playerBoard' : 'opponentBoard'], newSquare, square.index);
      let newShips = newSquare.ship ? this.immutableReplace(previousState[player ? 'playerShips' : 'opponentShips'], newShip, newSquare.ship.id - 1) : previousState[player ? 'playerShips' : 'opponentShips']
      return {
        [player ? 'playerBoard' : 'opponentBoard']: newBoard,
        playerTurn: !previousState.playerTurn,
        [player ? 'playerShips' : 'opponentShips']: newShips
      }
    });

    if (this.state[player ? 'playerShips' : 'opponentShips'].every((ship) => ship.alive == 0)) this.gameOver(player);
    if (!this.state.playerTurn) this.guess()
  }

  async gameOver(player) {
    await this.setState({gameOver: true, playerWon: !player})
    ga('send', 'event', 'Game', `${this.state.playerWon ? 'player': 'opponent'}_win`)
  }

  immutableReplace(array, elem, index) {
    return [...array.slice(0, index), elem, ...array.slice(index + 1)]
  }

  async resetGame() {
    let [playerBoard, opponentBoard] = await Promise.all([await this.getNewBoard(), await this.getNewBoard()]);
    this.setState({...this.initalState(playerBoard, opponentBoard)})
    ga('send', 'event', 'Game', 'reset')
  }

  renderHeadline() {
    if (this.state.gameOver) {
      return (
        <span>
          {this.state.playerWon ? 'You Win! ' : 'Opponent Wins. '}
          <a onClick={this.resetGame}>
            Play again?
          </a>
        </span>
      )
    } else {
      return this.state.playerTurn ? 'Your Turn' : "Opponent's Turn"
    }
  }

  render() {
    return (
      <div className="game">
        <div className="headline">
          {this.renderHeadline()}
        </div>
        
        <Board
          board={this.state.opponentBoard}
          onClick={this.onClick}
          hover={!this.state.gameOver && this.state.playerTurn}
          hideShips={true}
          title="Opponent"
          ships={this.state.opponentShips}
        />

        <Board
          board={this.state.playerBoard}
          hover={false}
          hideShips={false}
          title="You"
          ships={this.state.playerShips}
        />
      </div>
    )
  }
}

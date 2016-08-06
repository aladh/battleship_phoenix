import React from "react";
import Board from './Board';
import URLSearchParams from 'url-search-params'; // Need polyfill for safari

export default class Game extends React.Component {
  static propTypes = {
    guessURL: React.PropTypes.string.isRequired,
    rowLength: React.PropTypes.number.isRequired,
    untouched: React.PropTypes.number.isRequired,
    miss: React.PropTypes.number.isRequired,
    hit: React.PropTypes.number.isRequired,
    placedShip: React.PropTypes.number.isRequired,
    playerBoard: React.PropTypes.arrayOf(React.PropTypes.object).isRequired,
    opponentBoard: React.PropTypes.arrayOf(React.PropTypes.object).isRequired
  };

  onContinue = this.onContinue.bind(this);
  guess = this.guess.bind(this);
  playerBoard = this.props.playerBoard;
  opponentBoard = this.props.opponentBoard;
  playerClicked = false;
  state = {
    currentBoard: this.playerBoard,
    showingPlayerBoard: true
  };

  async onContinue() {
    this.playerClicked = false;

    await this.setState((previousState) => {
      let board = previousState.showingPlayerBoard ? this.opponentBoard : this.playerBoard;
      return {showingPlayerBoard: !previousState.showingPlayerBoard, currentBoard: board}
    });

    if (!this.state.showingPlayerBoard) this.guess();
  };

  async guess() {
    let options = {
      method: 'POST',
      body: this.buildParams({squares: JSON.stringify(this.playerBoard)})
    };
    let response = await fetch(this.props.guessURL, options);
    let index = await response.text()
    this.processGuess(this.playerBoard[index])
  };

  buildParams(params) {
    let searchParams = new URLSearchParams;
    Object.keys(params).forEach(key => searchParams.append(key, params[key]));
    return searchParams
  }

  onClick = (e) => {
    let id = e.target.getAttribute('data-board-index');
    let square = this.opponentBoard[id];

    if (this.state.showingPlayerBoard == true || this.playerClicked == true) return; // If not the players turn or player already clicked
    if (square.status != this.props.untouched && square.status != this.props.placedShip) return; // If square is not eligible to be hit

    this.playerClicked = true;
    this.processGuess(square);
    this.setState({currentBoard: this.opponentBoard})
  };

  processGuess(square) {
    if (square.status == this.props.miss || square.status == this.props.hit) throw "This square has already been revealed";
    square.ship == null ? square.status = this.props.miss : square.status = this.props.hit
  }

  render() {
    return (
      <div className="game">
        <div className="current-player">
          {this.state.showingPlayerBoard ? 'Your Board' : "Opponent's Board"}
        </div>

        <Board
          board={this.state.currentBoard}
          rowLength={this.props.rowLength}
          onClick={this.onClick}
          hover={!this.state.showingPlayerBoard && !this.playerClicked}
          hideShips={!this.state.showingPlayerBoard}
          untouched={this.props.untouched}
          placedShip={this.props.placedShip}
        />

        <button onClick={this.onContinue}>
          Continue
        </button>
      </div>
    )
  }
}

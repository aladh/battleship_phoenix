import React from "react";
import $ from "jquery";
import Board from './Board';

export default class Game extends React.Component {
  static propTypes = {
    boardURL: React.PropTypes.string.isRequired,
    guessURL: React.PropTypes.string.isRequired,
    rowLength: React.PropTypes.number.isRequired,
    untouched: React.PropTypes.number.isRequired,
    miss: React.PropTypes.number.isRequired,
    hit: React.PropTypes.number.isRequired,
    placedShip: React.PropTypes.number.isRequired
  };

  onContinue = this.onContinue.bind(this);
  guess = this.guess.bind(this);
  playerSquares = null;
  cpuSquares = null;
  playerClicked = false;
  state = {
    currentSquares: [],
    showingPlayerBoard: true
  };

  async componentDidMount() {
    let getSquares = (board) => board.squares;
    this.playerSquares = getSquares(await $.getJSON(this.props.boardURL));
    this.setState({currentSquares: this.playerSquares});
    this.cpuSquares = getSquares(await $.getJSON(this.props.boardURL));
  }

  async onContinue() {
    this.playerClicked = false;

    await this.setState((previousState) => {
      let squares = previousState.showingPlayerBoard ? this.cpuSquares : this.playerSquares;
      return {showingPlayerBoard: !previousState.showingPlayerBoard, currentSquares: squares}
    });

    if (!this.state.showingPlayerBoard) this.guess();
  };

  async guess() {
    let index = await $.getJSON(this.props.guessURL, {squares: JSON.stringify(this.playerSquares)});
    this.processGuess(this.playerSquares[index])
  };

  onClick = (e) => {
    let id = $(e.target).data('square-index');
    let square = this.cpuSquares[id];

    if (this.state.showingPlayerBoard == true || this.playerClicked == true) return; // If not the players turn or player already clicked
    if (square.status != this.props.untouched && square.status != this.props.placedShip) return; // If square is not eligible to be hit

    this.playerClicked = true;
    this.processGuess(square);
    this.setState({currentSquares: this.cpuSquares})
  };

  processGuess(square) {
    square.ship == null ? square.status = this.props.miss : square.status = this.props.hit
  }

  render() {
    return(
      <div>
        <div className="current-player">
          {this.state.showingPlayerBoard ? 'Your Board' : "Opponent's Board"}
        </div>

        <Board
          squares={this.state.currentSquares}
          rowLength={this.props.rowLength}
          onClick={this.onClick}
          hover={!this.state.showingPlayerBoard && !this.playerClicked}
          hideShips={!this.state.showingPlayerBoard}
          untouched={this.props.untouched}
        />

        <button onClick={this.onContinue}>
          Continue
        </button>
      </div>
    )
  }
}

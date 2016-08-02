import React from "react"
import $ from "jquery";
import Board from './Board'

export default class Game extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      currentSquares: [],
      showingPlayerBoard: true
    }

    this.playerSquares = null;
    this.cpuSquares = null;
    this.playerClicked = false;

    this.onContinue = this.onContinue.bind(this)
    this.onClick = this.onClick.bind(this)
    this.processGuess = this.processGuess.bind(this);
  }

  componentWillMount() {
    $.getJSON(Game.boardURL, (response) => {
      this.playerSquares = response.squares;
      this.setState({currentSquares: this.playerSquares});
    });

    $.getJSON(Game.boardURL, (response) => {
      this.cpuSquares = response.squares;
    });
  }

  onContinue() {
    this.playerClicked = false;
    this.setState((previousState) => {
      let squares = previousState.showingPlayerBoard ? this.cpuSquares : this.playerSquares;
      return {showingPlayerBoard: !previousState.showingPlayerBoard, currentSquares: squares}
    }, () => {
      if(this.state.showingPlayerBoard) { return }
      $.getJSON(Game.guessURL, {squares: JSON.stringify(this.playerSquares)}, (index) => {
        this.processGuess(index)
      });
    });
  }

  processGuess(index) {
    let square = this.playerSquares[index];
    if(square.ship == null) {
      square.status = Game.miss;
    } else {
      square.status = Game.hit;
    }
  }

  onClick(e) {
    if(this.state.showingPlayerBoard == true || this.playerClicked == true) { return }
    let id = $(e.target).data('square-index');
    let square = this.cpuSquares[id];

    if(square.status != Game.untouched && square.status != Game.placedShip) { return }

    this.playerClicked = true;

    if(square.ship) {
      square.status = Game.hit;
      this.setState({currentSquares: this.cpuSquares})
    } else {
      square.status = Game.miss;
      this.setState({currentSquares: this.cpuSquares})
    }
  }

  renderCurrentPlayer() {
    return (
      <div className="current-player">
        {this.state.showingPlayerBoard ? 'Your Board' : "Opponent's Board"}
      </div>
    )
  }

  render() {
    return(
      <div>
        {this.renderCurrentPlayer()}

        <Board
          squares={this.state.currentSquares}
          rowLength={this.props.rowLength}
          onClick={this.onClick}
          hover={!this.state.showingPlayerBoard && !this.playerClicked}
          hideShips={!this.state.showingPlayerBoard}
        />

        <button onClick={this.onContinue}>
          Continue
        </button>
      </div>
    )
  }
}

Game.defaultProps = {
  rowLength: 8
}

Game.untouched = 0;
Game.miss = 1;
Game.hit = 3;
Game.placedShip = 4;
Game.boardURL = $('#game').data('board-url');
Game.guessURL = $('#game').data('guess-url');

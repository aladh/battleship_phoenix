import React from "react"
import $ from "jquery";
import Board from './Board'

export default class Game extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      currentSquares: [],
      player: true
    }

    this.playerSquares = null;
    this.cpuSquares = null;

    this.onContinue = this.onContinue.bind(this)
    this.onClick = this.onClick.bind(this)
    this.processGuess = this.processGuess.bind(this);
  }

  componentWillMount() {
    $.getJSON('/api/board/new', (response) => {
      this.playerSquares = response.squares;
      this.setState({currentSquares: this.playerSquares});
    });

    $.getJSON('/api/board/new', (response) => {
      this.cpuSquares = response.squares;
    });
  }

  onContinue() {
    this.setState((previousState) => {
      let squares = previousState.player ? this.cpuSquares : this.playerSquares;
      return {player: !previousState.player, currentSquares: squares}
    }, () => {
      if(this.state.player) { return }
      $.getJSON('/api/guess', {squares: JSON.stringify(this.playerSquares)}, (index) => {
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
    if(this.state.player == true) { return }
    let id = $(e.target).data('square-index');
    let square = this.cpuSquares[id];

    if(square.status != Game.untouched && square.status != Game.placedShip) { return }

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
        {this.state.player ? 'Your Board' : "Computer's Board"}
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
          hover={!this.state.player}
          hideShips={!this.state.player}
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

import React from "react"
import Game from './Game'

export default class Board extends React.Component {
  static propTypes = {
    rowLength: React.PropTypes.number.isRequired,
    board: React.PropTypes.arrayOf(React.PropTypes.object).isRequired,
    onClick: React.PropTypes.func.isRequired,
    hover: React.PropTypes.bool.isRequired,
    hideShips: React.PropTypes.bool.isRequired,
    untouched: React.PropTypes.number.isRequired,
    placedShip: React.PropTypes.number.isRequired,
    title: React.PropTypes.string.isRequired
  };

  hideShipId(ship) {
    return this.props.hideShips || ship == null
  }

  maskSquareStatus(square) {
    return this.props.hideShips && square.status == this.props.placedShip
  }

  endOfRow(cellIndex) {
   return cellIndex % this.props.rowLength == this.props.rowLength - 1;
  }

  createBoard() {
    let board = [];

    for (var i = 0; i < this.props.board.length; i++) {
      let square = this.props.board[i];
      let squareElement = (
        <div
          key={i}
          className={`square ${this.props.hover ? 'hover' : ''}`}
          onClick={this.props.onClick}
          data-ship-id={this.hideShipId(square.ship) ? null : square.ship.id}
          data-board-index={square.index}
          data-square-status={this.maskSquareStatus(square) ? this.props.untouched : square.status}
        />
      )

      board.push(squareElement);
      if (this.endOfRow(i)) board.push(<br key={1000000 + i}/>);
    }

    return board
  }

  render() {
    return (
      <div className="board-container">
        <div className="title">
          {this.props.title}
        </div>
        
        <div className="board">
          {this.createBoard()}
        </div>
      </div>
    )
  }
}

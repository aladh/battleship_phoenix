import React from "react"
import Game from './Game'

export default class Board extends React.Component {

  endOfRow(cellIndex) {
   return cellIndex % this.props.rowLength == this.props.rowLength - 1;
  }

  createCellGrid() {
    let grid = [];

    for (var i = 0; i < this.props.squares.length; i++) {
      let square = (
        <div
          className={`square ${this.props.hover ? 'hover' : ''}`}
          key={i}
          data-ship-id={(this.props.squares[i].ship != null && !this.props.hideShips)? this.props.squares[i].ship.id : null}
          data-square-index={i}
          data-square-status={(this.props.hideShips && this.props.squares[i].status == 4) ? Game.untouched : this.props.squares[i].status}
          onClick={this.props.onClick}
        />
      )

      grid.push(square);

      if (this.endOfRow(i)) {
        grid.push(<br key={1000000 + i}/>)
      }
    }

    return grid
  }

  render() {
    return (
      <div className="board">
        {this.createCellGrid()}
      </div>
    )
  }
}

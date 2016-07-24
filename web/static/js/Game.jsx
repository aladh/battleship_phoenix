import React from "react"
import $ from "jquery";

export default class Game extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      squares: [],
      mousePosition: 0
    }

    // this.gridStates = {
    //   untouched: 0,
    //   placedShip: 4
    // }

    this.onMouseOver = this.onMouseOver.bind(this);
    this.onMouseLeave = this.onMouseLeave.bind(this);
    this.onClick = this.onClick.bind(this);
  }

  componentWillMount() {
    $.getJSON('/api/board/new', (response) => {
      this.setState({squares: response.squares});
    });
  }

  endOfRow(cellIndex) {
   return cellIndex % this.props.rowLength == this.props.rowLength - 1;
 }

 onMouseOver(e) {
  //  if(!this.state.shipsPlaced) {
  //    let mousePosition = parseInt(e.target.classList[2]);
  //    if(this.state.grid[mousePosition] != this.gridStates.placedShip) {
  //      let newGrid = this.state.grid;
   //
  //      newGrid[mousePosition] = this.gridStates.tempPlacedShip
   //
  //      this.setState({grid: newGrid})
  //    }
  //  }
 }

 onMouseLeave(e) {
  //  if(!this.state.shipsPlaced) {
  //    let mousePosition = parseInt(e.target.classList[2]);
   //
  //    if(this.state.grid[mousePosition] != this.gridStates.placedShip) {
  //      let newGrid = this.state.grid;
   //
  //      newGrid[mousePosition] = this.gridStates.untouched;
   //
  //      this.setState({grid: newGrid})
  //    }
  //  }
 }

 onClick(e) {
  //  if(!this.state.shipsPlaced) {
  //    let mousePosition = parseInt(e.target.classList[2]);
  //    if(this.state.grid[mousePosition] != this.gridStates.placedShip) {
  //      let newGrid = this.state.grid;
   //
  //      newGrid[mousePosition] = this.gridStates.placedShip;
   //
  //      this.setState({grid: newGrid})
  //    }
  //  }
 }

 createCellGrid() {
   let grid = [];

   for (var i = 0; i < this.state.squares.length; i++) {
     let square = (
       <div
         className={`square status_${this.state.squares[i].status}`}
         key={i}
         onMouseOver={this.onMouseOver}
         onMouseLeave={this.onMouseLeave}
         onClick={this.onClick}
         data-ship-id={this.state.squares[i].ship != null ? this.state.squares[i].ship.id : null}
         data-square-id={i}
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
    return(
      <div>
        <div className="grid">
          {this.createCellGrid()}
        </div>
      </div>
    )
  }
}

Game.defaultProps = {
  rowLength: 8
}

import React from "react"
import $ from "jquery";

export default class Game extends React.Component {
  constructor(props) {
    super(props);

    this.gridStates = {
      untouched: 0,
      tempPlacedShip: 4,
      placedShip: 5
    }

    var a = new Array(props.rowLength * props.rowLength);
    for (var i = a.length-1; i >= 0; -- i) a[i] = this.gridStates.untouched;

    this.state = {
      grid: a,
      player: 1,
      shipsPlaced: false,
      mousePosition: 0,
      vertical: true
    }

    this.onMouseOver = this.onMouseOver.bind(this);
    this.onMouseLeave = this.onMouseLeave.bind(this);
    this.onClick = this.onClick.bind(this);
  }

  componentWillMount() {
    $.getJSON('/api/guess', {foo: 'bar'}, (response) => {
      console.log(response)
    })
  }

  endOfRow(cellIndex) {
   return cellIndex % this.props.rowLength == this.props.rowLength - 1;
 }

 onMouseOver(e) {
   if(!this.state.shipsPlaced) {
     let mousePosition = parseInt(e.target.classList[2]);
     if(this.state.grid[mousePosition] != this.gridStates.placedShip) {
       let newGrid = this.state.grid;

       newGrid[mousePosition] = this.gridStates.tempPlacedShip

       this.setState({grid: newGrid})
     }
   }
 }

 onMouseLeave(e) {
   if(!this.state.shipsPlaced) {
     let mousePosition = parseInt(e.target.classList[2]);

     if(this.state.grid[mousePosition] != this.gridStates.placedShip) {
       let newGrid = this.state.grid;

       newGrid[mousePosition] = this.gridStates.untouched;

       this.setState({grid: newGrid})
     }
   }
 }

 onClick(e) {
   if(!this.state.shipsPlaced) {
     let mousePosition = parseInt(e.target.classList[2]);
     if(this.state.grid[mousePosition] != this.gridStates.placedShip) {
       let newGrid = this.state.grid;

       newGrid[mousePosition] = this.gridStates.placedShip;

       this.setState({grid: newGrid})
     }
   }
 }

 createCellGrid() {
   let grid = [];

   for (var i = 0; i < this.props.rowLength * this.props.rowLength; i++) {
     grid.push(<div className={`square _${this.state.grid[i]} ${i}`}
       key={i} onMouseOver={this.onMouseOver}
       onMouseLeave={this.onMouseLeave}
       onClick={this.onClick} />);

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

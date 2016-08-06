import React from "react";
import Square from './Square';

export default class Ships extends React.Component {
  static propTypes = {
    ships: React.PropTypes.arrayOf(React.PropTypes.object).isRequired
  };

  static contextTypes = {
    hit: React.PropTypes.number.isRequired,
    placedShip: React.PropTypes.number.isRequired
  };

  renderShip = (ship) => {
    let squares = [];

    for(var i = 0; i < ship.size; i++) {
      squares.push(
        <Square
          key={`${ship.id}-${i}`}
          shipId={ship.id}
          squareStatus={ship.alive > i ? this.context.placedShip : this.context.hit}
        />
      )
    }

    return (
      <div key={ship.id} className="ship">
        {squares}
      </div>
    )
  }

  render() {
    return (
      <div className="ships">
        {this.props.ships.map(this.renderShip)}
      </div>
    )
  }
}

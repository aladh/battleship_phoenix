import React from 'react';

const Square = (props) => {
  return (
    <div
      className={props.className}
      onClick={props.onClick}
      data-ship-id={props.shipId}
      data-board-index={props.boardIndex}
      data-square-status={props.squareStatus}
    />
  )
}

Square.displayName = 'Square';
Square.propTypes = {
  className: React.PropTypes.string.isRequired,
  onClick: React.PropTypes.func.isRequired,
  shipId: React.PropTypes.number,
  boardIndex: React.PropTypes.number.isRequired,
  squareStatus: React.PropTypes.number.isRequired,
}

export default Square;

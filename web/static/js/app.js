import "phoenix_html"
import React from "react"
import ReactDOM from "react-dom"
import "babel-polyfill";

import * as Game from "./Game";

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll('[data-react-class]').forEach((element) => {
    let klass = element.getAttribute('data-react-class');
    let props = JSON.parse(element.getAttribute('data-react-props'));
    let reactElement = React.createElement(eval(klass).default, props);
    ReactDOM.render(reactElement, element);
  });
});

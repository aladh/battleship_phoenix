// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import React from "react"
import ReactDOM from "react-dom"
import "babel-polyfill";
import $ from "jquery";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import * as Game from "./Game";

let element = $('[data-react-class]')[0];
let klass = $('[data-react-class]').data('react-class');
let props = $('[data-react-class]').data('react-props');
let reactElement = React.createElement(eval(klass).default, props);
ReactDOM.render(reactElement, element);

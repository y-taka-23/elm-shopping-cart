'use strict';

require('../html/index.html');

const { Elm } = require('../elm/Main.elm');

const app = Elm.Main.init({
  node: document.getElementById('app')
});

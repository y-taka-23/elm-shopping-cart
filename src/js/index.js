'use strict';

require('../html/index.html');
require('../css/style.css');

const { Elm } = require('../elm/Main.elm');

const app = Elm.Main.init({
  node: document.getElementById('app')
});

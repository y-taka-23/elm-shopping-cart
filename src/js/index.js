'use strict';

require('../html/index.html');
require('../css/style.css');

const shop = require('./shop');
const { Elm } = require('../elm/Main.elm');

const app = Elm.Main.init({
  node: document.getElementById('app')
});

app.ports.fetchProducts.subscribe(() => {
  shop.getProducts((products) => {
    app.ports.setProducts.send(products);
  });
});

app.ports.checkout.subscribe(cart => {
  shop.buyProducts(
    cart,
    () => {
      app.ports.setCheckoutStatus.send(true);
    },
    () => {
      app.ports.setCheckoutStatus.send(false);
    },
  );
});

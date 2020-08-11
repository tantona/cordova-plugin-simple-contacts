const exec = require("cordova/exec");
const PLUGIN_NAME = "SimpleContacts";

const SimpleContacts = function () {};

SimpleContacts.list = () =>
  new Promise((resolve, reject) => {
    exec(resolve, reject, PLUGIN_NAME, "list", []);
  });

module.exports = SimpleContacts;

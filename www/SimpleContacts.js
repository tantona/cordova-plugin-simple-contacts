const exec = require("cordova/exec");
const PLUGIN_NAME = "SimpleContacts";

const SimpleContacts = function () {};
// All of your plugin functions go below this.
// Note: We are not passing any options in the [] block for this, so make sure you include the empty [] block.
SimpleContacts.list = new Promise((resolve, reject) => {
  exec(resolve, reject, PLUGIN_NAME, "list", []);
});

module.exports = SimpleContacts;

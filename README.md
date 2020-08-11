# Cordova Plugin Simple Contacts

## Installation

`cordova plugin add cordova-plugin-simple-contacts`

## Usage

```js
// then/catch
window.SimpleContacts.list()
  .then(contacts => console.log(contacts))
  .catch(err => console.log(err))
);

// async/await
try {
  const contacts = await window.SimpleContacts.list()
  console.log(contacts)
}catch(err) {
  console.log(err)
}
```

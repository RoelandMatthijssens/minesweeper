const path = require("path");

module.exports = {
  username: "root",
  password: "root",
  storage: path.join(__dirname, "..", "database.sqlite"),
  host: "localhost",
  dialect: "sqlite",
  logging: console.log,
};

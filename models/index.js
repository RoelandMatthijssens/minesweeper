const db_config = require("../config/db.js");
const Sequelize = require("sequelize");
const sequelize = new Sequelize(
  db_config.storage,
  db_config.username,
  db_config.password,
  db_config
);

const Chunk = require("./chunk");

const models = {
  Chunk: Chunk.init(sequelize, Sequelize),
};

const db = {
  ...models,
  sequelize,
};
module.exports = db;

module.exports = (app) => {
  const chunks = require("../controllers/chunks.js");
  var router = require("express").Router();
  router.get("/", chunks.findAll);
  router.get("/:x/:y", chunks.findOne);
  app.use("/chunks", router);
};

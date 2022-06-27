const db = require("../models");
const Chunk = db.Chunk;

exports.create = (req, res) => {};

exports.findAll = (req, res) => {
  Chunk.findAll().then((data) => {
    res.send(data);
  });
};

exports.findOne = async (req, res) => {
  const { x, y } = req.params;
  let chunk = await Chunk.findOne({ where: { x, y } });
  if (!chunk) {
    chunk = await Chunk.create({ x, y });
    // we have to generate this after initial creation because we rely on the ID for the random seed and we have no ID
    // before the instance was created.
    chunk.mine_data = chunk.generate_mine_data();
    // so unfortunately we have to do a second save to the DB on creation
    await chunk.save();
  }
  res.send(chunk);
};

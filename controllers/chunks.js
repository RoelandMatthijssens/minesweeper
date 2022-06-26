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
    chunk = Chunk.build({ x, y });
    await chunk.save();
  }
  chunk.generate_mine_data();
  res.send(chunk);
};

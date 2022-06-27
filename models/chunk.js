const Sequelize = require("sequelize");
const RandomNumberGenerator = require("../utils/random_seed");
const BitArray = require("../utils/bit_array");

class Chunk extends Sequelize.Model {
  static init(sequelize, DataTypes) {
    return super.init(
      {
        id: {
          type: Sequelize.INTEGER,
          allowNull: false,
          autoIncrement: true,
          primaryKey: true,
        },
        x: {
          type: Sequelize.INTEGER,
          allowNull: false,
        },
        y: {
          type: Sequelize.INTEGER,
          allowNull: false,
        },
        mine_data: {
          type: Sequelize.STRING(64 * 64),
          allowNull: true,
        },
      },
      {
        sequelize,
      }
    );
  }
  generate_mine_data() {
    const total_bits = 32 * 32;
    const random_generator = new RandomNumberGenerator(this.id);
    const number_of_mines = Math.floor(total_bits * 0.2);
    const bit_array = new BitArray(total_bits);
    const mine_locations = [];
    for (let i = 0; i < number_of_mines; i++) {
      bit_array.setAt(random_generator.random(total_bits), true);
    }
    return bit_array.toString();
  }
}

module.exports = Chunk;

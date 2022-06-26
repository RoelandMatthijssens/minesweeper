const Sequelize = require("sequelize");

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
          type: Sequelize.INTEGER,
          allowNull: true,
        },
      },
      { sequelize }
    );
  }
  generate_mine_data() {
    this.mine_data = 1234;
    console.log(this.mine_data);
  }
}

module.exports = Chunk;

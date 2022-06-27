class RandomNumberGenerator {
  constructor(seed) {
    this.seed = seed;
    this.generator = null;
    this.reset();
  }

  reset() {
    var mask = 0xffffffff;
    var m_w = (123456789 + this.seed) & mask;
    var m_z = (987654321 - this.seed) & mask;

    this.generator = () => {
      m_z = (36969 * (m_z & 65535) + (m_z >>> 16)) & mask;
      m_w = (18000 * (m_w & 65535) + (m_w >>> 16)) & mask;

      var result = ((m_z << 16) + (m_w & 65535)) >>> 0;
      result /= 4294967296;
      return result;
    };
  }

  random(min, max) {
    const rand = this.generator();
    if (min == null && max == null) {
      return rand;
    } else if (min != null && max == null) {
      max = min;
      min = 0;
    }
    return Math.floor(rand * (max - min + 1)) + min;
  }
}

module.exports = RandomNumberGenerator;

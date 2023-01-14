/**
 * @file CGRandom.js
 * @author liujiacheng
 * @date 2021/8/23
 * @brief CGRandom.js
 * @copyright Copyright (c) 2021, ByteDance Inc, All Rights Reserved
 */

const {BaseNode} = require('./BaseNode');
const Amaz = effect.Amaz;

class CGRandom extends BaseNode {
  constructor() {
    super();
  }

  getOutput(index) {
    if (!this.inputs[0] === undefined || !this.inputs[1] === undefined) {
      return 0;
    }
    if (this.inputs[0]() === undefined || !this.inputs[1]() === undefined) {
      return 0;
    }
    const upper = Math.max(this.inputs[0](), this.inputs[1]());
    const lower = Math.min(this.inputs[0](), this.inputs[1]());
    return Number((Math.random() * Math.abs(upper - lower) + lower).toFixed(3));
  }
}

exports.CGRandom = CGRandom;

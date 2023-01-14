/**
 * @file CGAnd.js
 * @author
 * @date 2021/8/15
 * @brief CGAnd.js
 * @copyright Copyright (c) 2021, ByteDance Inc, All Rights Reserved
 */

const {BaseNode} = require('./BaseNode');
const Amaz = effect.Amaz;

class CGAnd extends BaseNode {
  constructor() {
    super();
  }

  getOutput(index) {
    return this.inputs[0]() && this.inputs[1]();
  }
}

exports.CGAnd = CGAnd;

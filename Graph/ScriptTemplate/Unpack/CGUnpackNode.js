/**
 * @file CGUnpackNode.js
 * @author Weifeng Huang (huangweifeng.2067@bytedance.com)
 * @date 2021-08-26
 * @brief
 * @copyright Copyright (c) 2021, ByteDance Inc, All Rights Reserved
 */
const {BaseNode} = require('./BaseNode');
const Amaz = effect.Amaz;

class CGUnpackNode extends BaseNode {
  constructor() {
    super();
    this.valueType = null;
  }

  getOutput(index) {
    const res = this.inputs[0]();
    if (this.valueType === 'Color') {
      const colorVal = ['r', 'g', 'b', 'a'];
      return res[colorVal[index]];
    }
    if (index === 0) {
      return res.x;
    } else if (index === 1) {
      return res.y;
    }
    if (this.valueType !== 'Rect') {
      if (index === 2) {
        return res.z;
      } else if (index === 3) {
        return res.w;
      }
    } else {
      if (index === 2) {
        return res.width;
      } else if (index === 3) {
        return res.height;
      }
    }
  }
}

exports.CGUnpackNode = CGUnpackNode;

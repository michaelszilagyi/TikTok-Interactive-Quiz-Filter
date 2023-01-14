/**
 * @file CGAdd.js
 * @author
 * @date 2021/8/15
 * @brief CGAdd.js
 * @copyright Copyright (c) 2021, ByteDance Inc, All Rights Reserved
 */

const {BaseNode} = require('./BaseNode');
const Amaz = effect.Amaz;

class CGAdd extends BaseNode {
  constructor() {
    super();
  }

  getOutput() {
    let curType = this.valueType;
    if (curType == null) {
      return null;
    }

    if (curType == 'Int' || curType == 'Double') {
      let result = 0.0;
      for (let k = 0; k < this.inputs.length; ++k) {
        var op = this.inputs[k]();

        if (op == null) {
          return null;
        }
        result += op;
      }
      return result;
    } else if (curType == 'Vector2f') {
      let resultX = 0.0;
      let resultY = 0.0;
      for (let k = 0; k < this.inputs.length; ++k) {
        var op = this.inputs[k]();

        if (op == null) {
          return null;
        }
        resultX += op.x;
        resultY += op.y;
      }
      return new Amaz.Vector2f(resultX, resultY);
    } else if (curType == 'Vector3f') {
      let resultX = 0.0;
      let resultY = 0.0;
      let resultZ = 0.0;

      for (let k = 0; k < this.inputs.length; ++k) {
        var op = this.inputs[k]();

        if (op == null) {
          return null;
        }
        resultX += op.x;
        resultY += op.y;
        resultZ += op.z;
      }
      return new Amaz.Vector3f(resultX, resultY, resultZ);
    } else if (curType == 'Vector4f') {
      let resultX = 0.0;
      let resultY = 0.0;
      let resultZ = 0.0;
      let resultW = 0.0;

      for (let k = 0; k < this.inputs.length; ++k) {
        var op = this.inputs[k]();

        if (op == null) {
          return null;
        }
        resultX += op.x;
        resultY += op.y;
        resultZ += op.z;
        resultW += op.w;
      }
      return new Amaz.Vector4f(resultX, resultY, resultZ, resultW);
    }
  }
}

exports.CGAdd = CGAdd;

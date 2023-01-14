const {BaseNode} = require('./BaseNode');
const Amaz = effect.Amaz;

class CGTransitByTime extends BaseNode {
  constructor() {
    super();

    this.start = false;
    this.updating = false;
    this.curTime = 0;
    this.loopIndex = 0;
    this.combNum = [];

    this.from = 0;
    this.to = 0;
    this.duration = 0;
    this.interpolator = '';
    this.loopTimes = 0;
    this.value = 0;
  }

  beforeStart(sys) {
    this.value = this.inputs[4]();
  }

  configTransition() {
    this.from = this.inputs[4]();
    this.to = this.inputs[5]();
    this.duration = Math.max(0, this.inputs[6]());
    this.interpolator = this.inputs[7]();
    this.loopTimes = Math.max(1, Math.round(this.inputs[8]()));
  }

  execute(index) {
    if (index === 0) {
      this.updating = true;
      this.loopIndex = 0;
      this.curTime = 0;
      this.start = true;
      this.configTransition();
      this.value = this.from;
      if (this.nexts[0]) {
        this.nexts[0]();
      }
    } else if (index === 1) {
      this.updating = false;
    } else if (index === 2 && this.start) {
      this.updating = true;
    } else if (index === 3) {
      this.updating = false;
      this.loopIndex = 0;
      this.curTime = 0;
      this.start = false;
      this.value = this.from;
      if (this.nexts[2]) {
        this.nexts[2]();
      }
    }
  }

  combination(n, i) {
    if (i < 0 || n === 0) {
      return 0;
    }
    if (this.combNum[n] && this.combNum[n][i]) {
      return this.combNum[n][i];
    }
    if (this.combNum[n] === undefined) {
      this.combNum[n] = [];
    }
    if (i === 0 || n === i) {
      this.combNum[n][i] = 1;
    } else {
      this.combNum[n][i] = this.combination(n - 1, i) + this.combination(n - 1, i - 1);
    }
    return this.combNum[n][i];
  }

  bezier(nums, t) {
    let p = 1 - t;
    let item = nums;
    let pp = 1;
    let tt = 1;
    for (let i = 0; i < nums.length; ++i) {
      item[i] = item[i] * tt;
      item[nums.length - i - 1] = item[nums.length - i - 1] * pp;
      item[i] = item[i] * this.combination(nums.length - 1, i);
      pp = pp * p;
      tt = tt * t;
    }
    return item.reduce((pre, cur) => pre + cur, 0);
  }

  getCurNumber(numStart, numEnd, t) {
    if (this.duration === 0) {
      t = 0;
    } else {
      t = t / this.duration;
    }
    switch (this.interpolator) {
      case 'Linear':
        return this.bezier([numStart, numEnd], t);
      case 'Ease-in':
        return this.bezier([numStart, numStart, numEnd], t);
      case 'Ease-out':
        return this.bezier([numStart, numEnd, numEnd], t);
      case 'Ease-in-out':
        return this.bezier([numStart, numStart, numEnd, numEnd], t);
      case 'Ease-out-in':
        return this.bezier([numStart, (numStart + numEnd) / 2, (numStart + numEnd) / 2, numEnd], t);
    }
  }

  getCurValue(t) {
    const valStart = this.from;
    const valEnd = this.to;
    if (this.valueType === 'Double') {
      return this.getCurNumber(valStart, valEnd, t);
    } else if (this.valueType === 'Int') {
      return Math.floor(this.getCurNumber(valStart, valEnd, t));
    } else if (this.valueType === 'Vector2f') {
      const x = this.getCurNumber(valStart.x, valEnd.x, t);
      const y = this.getCurNumber(valStart.y, valEnd.y, t);
      return new Amaz.Vector2f(x, y);
    } else if (this.valueType === 'Vector3f') {
      const x = this.getCurNumber(valStart.x, valEnd.x, t);
      const y = this.getCurNumber(valStart.y, valEnd.y, t);
      const z = this.getCurNumber(valStart.z, valEnd.z, t);
      return new Amaz.Vector3f(x, y, z);
    } else if (this.valueType === 'Vector4f') {
      const x = this.getCurNumber(valStart.x, valEnd.x, t);
      const y = this.getCurNumber(valStart.y, valEnd.y, t);
      const z = this.getCurNumber(valStart.z, valEnd.z, t);
      const w = this.getCurNumber(valStart.w, valEnd.w, t);
      return new Amaz.Vector4f(x, y, z, w);
    } else if (this.valueType === 'Color') {
      const r = this.getCurNumber(valStart.r, valEnd.r, t);
      const g = this.getCurNumber(valStart.g, valEnd.g, t);
      const b = this.getCurNumber(valStart.b, valEnd.b, t);
      const a = this.getCurNumber(valStart.a, valEnd.a, t);
      return new Amaz.Color(r, g, b, a);
    }
  }

  onUpdate(sys, deltatime) {
    if (!this.updating) {
      return;
    }

    this.value = this.getCurValue(Math.min(this.curTime, this.duration));
    if (this.nexts[1]) {
      this.nexts[1]();
    }

    if (this.curTime >= this.duration) {
      this.loopIndex = this.loopIndex + 1;
      this.curTime = 0;
    } else {
      this.curTime = this.curTime + deltatime;
    }

    if (this.loopIndex >= this.loopTimes) {
      this.start = false;
      this.updating = false;
      if (this.nexts[2]) {
        this.nexts[2]();
      }
    }
  }

  getOutput(index) {
    return this.value;
  }
}

exports.CGTransitByTime = CGTransitByTime;

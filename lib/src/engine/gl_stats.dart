part of pixies.engine;

class _GLStats {
  final html.DivElement element;
  final int _maximum;
  num _sumPassed = 0;
  num _sumDraw = 0;
  int _count = 0;
  
  _GLStats(this.element, {int averageCount: 60})
      : _maximum = averageCount {
    _drawElement(0.0, 0.0);
  }
  
  double _getAverage(List<num> nums) {
    num sum = 0;
    for (int index = 0; index < _maximum; index++)
      sum += nums[index];
    return sum / _maximum;
  }
  
  void addTimes(num passedTime, num drawTime) {
    _sumPassed += passedTime;
    _sumDraw += drawTime;
    
    _count++;
    if (_count >= _maximum) {
      _count = 0;
      _drawElement(_sumPassed / _maximum, _sumDraw / _maximum);
      _sumPassed = 0;
      _sumDraw = 0;
    }
  }
  
  void _drawElement(double passed, double draw) {
    element.innerHtml = '''
<div>fps:   ${((1 / passed) * 1000).toStringAsFixed(2)}</div>
<div>draw:   ${draw.toStringAsFixed(2)}</div>
''';
  }
  
}

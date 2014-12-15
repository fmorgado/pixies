part of pixies.controllers;

abstract class ControllerContainer
    <P extends Controller, C extends Controller>
    implements Controller {
  
  final _children = <C>[];
  
  void addChild(C child) {
    
  }
  
  void addChildAt(C child, int index) {
    
  }
  
}

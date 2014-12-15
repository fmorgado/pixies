part of pixies.stage;

abstract class RenderFilter {
  
  void render(Stage stage, GLTexture texture);

  int get paddingBottom => 0;
  int get paddingLeft => 0;
  int get paddingRight => 0;
  int get paddingTop => 0;
  
}

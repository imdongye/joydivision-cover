import processing.sound.*;
SoundFile song;
Waveform waveform;
PFont f;
final int samples = 100;

void setup() {
  size(500, 500, P3D);
  f = createFont( "Arial", 45);
  song = new SoundFile(this, "transmision.mp3");
  song.play();
  waveform = new Waveform(this, samples);
  waveform.input(song);
}
void draw() {
  background(20);
  translate(width/2, height/2);
  scale(0.7);
  translate(-width/2, -height/2);
  rotateX(PI/4*map(mouseY, 0, height, 0, 1));
  
  // A minimum 0.1 is used instead of 0 to avoid a warning message.
  float volume = map(mouseX, 0, width, 0.1, 1);
  song.amp(volume);
  float speed = map(mouseY, 0, height, 0.1, 2);
  song.rate(speed);

  // draw a line to show where we are in the song
  stroke(255, 0, 0);
  strokeWeight(10);
  float lineWidth = map(song.position(), 0, song.duration(), 10, width-10);
  line(10, height-10, lineWidth, height-10);

  // draw wave
  stroke(255);
  strokeWeight(2);
  fill(0);
  
  final int maxlines = 30;
  waveform.analyze();
  for (int i = 0; i < maxlines; i++) {
    float hh = map(i, 0, maxlines, 80, height-80);
    beginShape();
    int bassi = (int)random(30);
    for (int j = 0; j < samples; j++)
    {
      int index = bassi + j;
      float x = map(j, 0, samples, 100, width-100);
      float y = waveform.data[index%samples] * height*0.7;
      // clamp out of middle
      float mulByX = constrain(sin(map(j, samples/3.5, samples-samples/3.5, 0, PI)), 0, 1);
      mulByX +=0.2;
      y = hh-abs(y)*mulByX;
      vertex(x, y);
    }
    endShape();
  }

  fill(255);
  textFont(f);
  textAlign(CENTER);
  text("JOY DIVISION", width/2, 70);
  textFont(f, 26);
  text("UNKNOWN PLEASURES", width/2, height-70);
  
  // indicators
  stroke(0);
  strokeWeight(1);
  fill(51, 100);
  ellipse(mouseX, height/2, 80, 80);
  ellipse(width/2, mouseY, 80, 80);
}

void mouseWheel(MouseEvent event) {
  // jumps to the left or right by mousewheel.
  float position = constrain(song.position()+event.getCount()*2, 0, song.duration());
  song.jump(position);
}

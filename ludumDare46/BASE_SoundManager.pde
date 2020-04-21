import processing.sound.*;

public class SongFlyingLower {
  final int[] bassSequence = { 52, 0, 52, 0, 55, 0, 53, 0};
  final int[] meloSequence = { 60, 62, 65, 64, 67, 71, 69, 69};
  final int[] meloRndSeq =   {67, 69, 71, 72};
  final int[] drumSequence = { 72, 0, 60, 0, 72, 0, 60, 0};

  final int sequenceCount = bassSequence.length;

  // Set the duration between the notes
  final int BPM = 80;
  final int MSpB = 60*1000/BPM/2;


  int trigger;
  int note; 

  TriOsc triOsc;
  SinOsc sinOsc;
  SqrOsc sqrOsc;
  SawOsc sawOsc;

  boolean playing;

  public SongFlyingLower() {
    triOsc = new TriOsc(partenApplet);
    sinOsc = new SinOsc(partenApplet);
    sqrOsc = new SqrOsc(partenApplet);
    sawOsc = new SawOsc(partenApplet);

    playing = false;
  }

  public void playSong() {
    trigger = millis() + MSpB;
    note = 0;
    playing = true;
  }

  public void updateSong() {
    if (playing) {
      if ((millis() > trigger)) {

        if (bassSequence[note] > 0) {
          sinOsc.play(midiToFreq(bassSequence[note]), 1);
          //bassEnv.play(sinOsc, 0.08, 0.1, 0.99, 0.2);
        }
        if (meloSequence[note] > 0) {
          if (note < 4) {
            triOsc.play(midiToFreq(meloSequence[note]), 0.8);
          } else {
            int rndNote = (int) random(meloRndSeq.length);
            triOsc.play(midiToFreq(meloRndSeq[rndNote]), 0.8);
          }
          //meloEnv.play(triOsc, attackTime, sustainTime, sustainLevel, releaseTime);
        }
        if (drumSequence[note] > 0) {
          sawOsc.play(midiToFreq(drumSequence[note]), 0.1);
        } else {
          sawOsc.stop();
        }


        // Create the new trigger according to predefined durations and speed
        trigger = millis() + MSpB;

        // Advance by one note in the midiSequence;
        note = (note+1)%sequenceCount;
      }
    }
  }

  public void stopSong() {
    playing = false;
    triOsc.stop();
    sinOsc.stop();
    sqrOsc.stop();
    sawOsc.stop();
  }

  private float midiToFreq(int note) {
    return (pow(2, ((note-69)/12.0)))*440;
  }
}

public class SoundManager {
  private SongFlyingLower song;
  
  public SoundManager() {
    song = new SongFlyingLower();
  }
  
  public void playMusic() {
    song.playSong();
  }
  
  public void updateMusic() {
    song.updateSong();
  }
  
  public void stopSong() { 
    song.stopSong();
  }
}

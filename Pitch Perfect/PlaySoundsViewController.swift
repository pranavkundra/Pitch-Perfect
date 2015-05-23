//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Pranav Kundra on 23/05/15.
//  Copyright (c) 2015 Pranav Kundra. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var audioPlayerNode:AVAudioPlayerNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Legacy Code
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            var filePathURL = NSURL.fileURLWithPath(filePath);
//            
//        }
//        else{
//            println("Invalid File Path");
//        }
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil);
        audioPlayer.enableRate = true;
        
        audioEngine = AVAudioEngine();
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(0.5);
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(1.5);
    }
    
    func playAudio(speed: Float){
        
        if((audioPlayerNode) != nil)
        {
            audioPlayerNode.stop();
            audioPlayerNode.reset();
        }
        
        audioPlayer.stop();
        audioPlayer.rate = speed;
        audioPlayer.currentTime = 0.0;
        audioPlayer.play();
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000);
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000);
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop();
        audioPlayer.stop();
        audioEngine.stop();
        audioEngine.reset();
        
        audioPlayerNode = AVAudioPlayerNode();
        audioEngine.attachNode(audioPlayerNode);
        
        var changePitchEffect = AVAudioUnitTimePitch();
        changePitchEffect.pitch = pitch;
        audioEngine.attachNode(changePitchEffect);
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil);
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil);
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil);
        audioEngine.startAndReturnError(nil);
        
        audioPlayerNode.play();
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        if((audioPlayerNode) != nil)
        {
            audioPlayerNode.stop();
            audioPlayerNode.reset();
        }
        audioPlayer.stop();
        audioPlayer.rate = 1.0;
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

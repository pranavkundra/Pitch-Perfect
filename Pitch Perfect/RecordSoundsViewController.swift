//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Pranav Kundra on 23/05/15.
//  Copyright (c) 2015 Pranav Kundra. All rights reserved.


import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordingInProgress.hidden = true;
        stopButton.hidden = true;
        recordButton.enabled = true;
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        recordingInProgress.hidden = false;
        stopButton.hidden = false;
        recordButton.enabled = false;
//        println("in recordAudio");
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String;
        
        let currentDateTime = NSDate();
        let formatter = NSDateFormatter();
        formatter.dateFormat = "ddMMyyyy-HHmmss";
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav";
        let pathArray = [dirPath, recordingName];
        let filePath = NSURL.fileURLWithPathComponents(pathArray);
        println(filePath);
        
        var session = AVAudioSession.sharedInstance();
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil);
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil);
        audioRecorder.delegate = self;
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord();
        audioRecorder.record();
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag)
        {
            //save recorded audio
            recordedAudio = RecordedAudio();
            recordedAudio.filePathURL = recorder.url;
            recordedAudio.title = recorder.url.lastPathComponent;
            
            //perform segue!
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio);
        }
        
        else
        {
            println("Error in Recording Audio");
            recordingInProgress.hidden = true;
            stopButton.hidden = true;
            recordButton.enabled = true;
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController;
            let data = sender as! RecordedAudio;
            playSoundsVC.receivedAudio = data;
        }
    }

    @IBAction func stopAudio(sender: UIButton) {
        
        recordingInProgress.hidden = true;
//        println("in stopAudio");
        
        audioRecorder.stop();
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil);
    }
}


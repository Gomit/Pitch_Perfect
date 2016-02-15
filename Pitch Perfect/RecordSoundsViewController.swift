//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Meron Goitom on 14/02/15.
//  Copyright (c) 2015 Meron Goitom. All rights reserved.
//

import UIKit
//importerar AVFoundation biblioteket #1
import AVFoundation
//HIT #1

//Lägger till "AVAudioRecorderDelegate" till classen #2
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
//#HIT
    
    @IBOutlet weak var recordButton: UIButton!
    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.hidden = true
        
        // #1
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil)
        // HIT
    }
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    //deklarerar ett globalt audiorecorder object #1
    var audioRecorder:AVAudioRecorder!
    //HIT #1
    
    // declrerea ny funktion #3
    var recordedAudio:RecordedAudio!
    // HIT #3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordButton.enabled = false
        stopButton.hidden = false
        recordingInProgress.hidden = false
        println("in recordAudio")
        
        //spela in användarens röst #1
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //set up audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL:filePath, settings: nil, error: nil)
        //#2
        audioRecorder.delegate = self
        //#2
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        //HIT #1
    }
    
    //move sound to next slider #4
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            //Spara inspelade audio #3
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            // flytta till nästa scene #3
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else {
            println("Recording was not successfull")
            recordButton.enabled = true
            stopButton.hidden = true
            
            //HIT#3
        }
        }
    }




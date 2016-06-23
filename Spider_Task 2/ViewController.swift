//
//  ViewController.swift
//  Spider_Task 2
//
//  Created by Gautham Kumar on 21/06/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var PlayStopButton: UIButton!
    @IBOutlet weak var MainImage: UIImageView!
    @IBOutlet weak var SlideshowButton: UIButton!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var Picker: UIPickerView!
    
    var imageTimer: NSTimer?
    var imageno = 0
    var slideshowInProgress: Bool = false
    
    var milliSecondNumber: Int = 0
    var secondNumber: Int = 0
    var minuteNumber: Int = 0
    var milliSecondString: String = "00"
    var secondString: String = "00"
    var minuteString: String = "00"
    
    var pickerArray = ["Sky Full of Stars","Hurts like Heaven","Counting Stars"]
    var currentPickerRow: Int = 0
    var isPlaying: Bool = false
    var audioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.blackColor()
        Picker.tintColor = UIColor.whiteColor()
        TimerLabel.textColor = UIColor.whiteColor()
        
        Picker.delegate = self
        Picker.dataSource = self
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func changeImage() {
        
        milliSecondNumber += 1
        
        if milliSecondNumber == 100 {
            milliSecondNumber = 0
            secondNumber += 1
        }
        if secondNumber == 60 {
            secondNumber = 0
            minuteNumber += 1
        }
        
        if milliSecondNumber < 10 {
            milliSecondString = "0\(milliSecondNumber)"
        } else {
            milliSecondString = "\(milliSecondNumber)"
        }
        
        if secondNumber < 10 {
            secondString = "0\(secondNumber)"
        } else {
            secondString = "\(secondNumber)"
        }
        
        if minuteNumber < 10 {
            minuteString = "0\(minuteNumber)"
        } else {
            minuteString = "\(minuteNumber)"
        }
        
        TimerLabel.text = minuteString + ":" + secondString + ":" + milliSecondString
        
        if secondNumber%3 == 0 && milliSecondNumber == 0 {
            if imageno == 5 {
                imageno = 0
            }
            imageno += 1
            
            let toImage = UIImage(named: "space\(imageno)")
            
            UIView.transitionWithView(self.MainImage, duration: 1, options: .TransitionCrossDissolve, animations: {self.MainImage.image = toImage}, completion: nil)
        }
        
    }
    
    @IBAction func OnSlideshowClick(sender: AnyObject) {
        
        if slideshowInProgress {
            SlideshowButton.setTitle("Start Slideshow", forState: UIControlState.Normal)
            
            milliSecondNumber = 0
            secondNumber = 0
            minuteNumber = 0
            TimerLabel.text = "00:00:00"
            
            imageTimer?.invalidate()
            
            UIView.transitionWithView(self.MainImage, duration: 1, options: .TransitionCrossDissolve, animations: {self.MainImage.image = UIImage(named: "defaultpic")}, completion: nil)
            imageno = 0 
            
        }
        else {
            
            milliSecondNumber = 0
            secondNumber = 0
            minuteNumber = 0
        
            SlideshowButton.setTitle("Stop Slideshow", forState: UIControlState.Normal)
            
            imageTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(ViewController.changeImage), userInfo: nil, repeats: true)
        }
        
        slideshowInProgress = !slideshowInProgress
        
    }
    
    @IBAction func OnPlayStopClick(sender: AnyObject) {
        
        if isPlaying {
            
            PlayStopButton.setTitle("Play", forState: UIControlState.Normal)
            
            audioPlayer.stop()
        }
            
        else {
            
            PlayStopButton.setTitle("Stop", forState: UIControlState.Normal)
            
            var path: NSURL?
            print(currentPickerRow)
            if currentPickerRow == 0 {
                path = NSBundle.mainBundle().URLForResource("A Sky Full of Stars", withExtension: "mp3")
            }
            else if currentPickerRow == 1 {
                path = NSBundle.mainBundle().URLForResource("Hurts Like Heaven", withExtension: "mp3")
            }
            else if currentPickerRow == 2 {
                path = NSBundle.mainBundle().URLForResource("Counting Stars", withExtension: "mp3")
            }
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOfURL: path!)
            }
            catch {
                print("Something went wrong")
            }
            
            audioPlayer.play()
        }
        
        isPlaying = !isPlaying
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentPickerRow = row
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let attributedString = NSAttributedString(string: pickerArray[row], attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        
        return attributedString
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
}


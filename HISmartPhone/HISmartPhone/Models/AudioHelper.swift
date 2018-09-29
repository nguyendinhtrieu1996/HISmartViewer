//
//  AudioHelper.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 4/8/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit
import AVFoundation

class AudioHelper {
    
    class var shared: AudioHelper {
        struct Static {
            static var instance = AudioHelper()
        }
        return Static.instance
    }
    
    private var player: AVAudioPlayer?
    
    private init() {
        
    }
    
    public func play() {
        guard let url = Bundle.main.url(forResource: "Beep", withExtension: "mp3") else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player  else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

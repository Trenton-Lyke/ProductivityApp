//
//  SoundPlayer.swift
//  Productivity
//
//  Created by Trenton Lyke on 5/1/24.
//

import AVKit

class SoundPlayer {
    
    static let shared = SoundPlayer()
    
    private var player: AVAudioPlayer = AVAudioPlayer()
    
    private init(){}
    
    func playSound(forResource: String, withExtension: String, numberOfLoops: Int = 0) {

        
        guard let soundFilePath = Bundle.main.path(
            forResource: forResource,
            ofType: withExtension
        ) else {
            return
        }
        
        let soundFileURL = URL(fileURLWithPath: soundFilePath)
        
        do {

            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.playback
            )

            try AVAudioSession.sharedInstance().setActive(true)

            stopSound()
            
            player = try AVAudioPlayer(
                contentsOf: soundFileURL
            )
            
            player.numberOfLoops = numberOfLoops
            
            player.play()
        }
        catch {

        }
    }
    
    func isPlaying() -> Bool {
        return player.isPlaying
    }
    
    func stopSound() {
        if player.isPlaying {
            player.stop()
        }
    }

}

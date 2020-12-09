//
//  ViewController.swift
//  MusicPlayer
//
//  Created by JeongHwan Seok on 2020/12/07.
//

import UIKit
import AVFoundation
//사운드 및 영상 미디어의 처리, 제어, 가져오기 및 내보내기 등 광범위한 기능을 제공하는 프레임워크
//주요 기능 : 미디어 재생 및 편집, 디바이스 카메라와 마이크를 이용한 영상 녹화 및 사운드 녹음, 시스템 사운드 제어, 문자의 음성화

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    //프로퍼티
    var player: AVAudioPlayer!
    var timer: Timer!
    
    //인스턴스 프로퍼티 //인터페이스 빌더 아웃렛
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var progressSlider: UISlider!
    
    // MARK: - Methods
    //처음에 플레이어 초기화 메소드
    func initializePlayer() {
        guard let soundAsset: NSDataAsset = NSDataAsset(name: "sound") else {
            print("음원 파일 에셋을 가져올 수 없습니다")
            return
        }
        
        do {
            try self.player = AVAudioPlayer(data: soundAsset.data)
            self.player.delegate = self
        } catch let error as NSError {
            print("플레이어 초기화 실패")
            print("코드 : \(error.code), 메시지 : \(error.localizedDescription)")
        }
        
        self.progressSlider.maximumValue = Float(self.player.duration) //사운드의 총 재생 시간(초 단위)
        self.progressSlider.minimumValue = 0
        self.progressSlider.value = Float(self.player.currentTime) //사운드의 현재 재생 시각
    }
    
    //레이블을 매초마다 업데이트해줄 메소드
    func updateTimeLabelText(time: TimeInterval) {
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        
        let timeText: String = String(format: "%02ld:%02ld:%02ld", minute, second, milisecond)
        
        self.timeLabel.text = timeText
    }
    
    //타이머를 만들고 수행해줄 메소드
    func makeAndFireTimer() {
        //repeat: true일 때는 자동으로 조정, block: timer가 작동될 때 실행 될 것들
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self]
            (timer: Timer) in
            
            //이벤트 컨트롤 여부 확인, slider에서 잘 진행되고 있으면 true
            if self.progressSlider.isTracking { return }
            
            //오디오 현재 재생 시간을 전달
            self.updateTimeLabelText(time: self.player.currentTime)
            self.progressSlider.value = Float(self.player.currentTime)
        })
        self.timer.fire()
    }
    
    //타이머를 해제해줄 메소드
    func invalidateTimer() {
        self.timer.invalidate() //반복되는 타이머 기능 정지
        self.timer = nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initializePlayer()
    }

    //                            어떤 버튼이 이 메소드를 호출했는지 매개변수로 받아옴
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.player?.play()
        } else {
            self.player?.pause()
        }
        
        if sender.isSelected {
            self.makeAndFireTimer()
        } else {
            self.invalidateTimer()
        }
    }
    
    @IBAction func slideValueChanged(_ sender: UISlider) {
        self.updateTimeLabelText(time: TimeInterval(sender.value))
        if sender.isTracking { return }
        self.player.currentTime = TimeInterval(sender.value)
    }
    
    //AVAudioPlayerDelegate -> 어떤 객체가 할 일을 부분적으로 대신처리한다
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        guard let error: Error = error else {
            print("오디오 플레이어 디코드 오류발생")
            return
        }
        
        let message: String
        message = "오디오 플레이어 오류 발생 \(error.localizedDescription)"
        
        let alert: UIAlertController = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (action: UIAlertAction) -> Void in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playPauseButton.isSelected = false
        self.progressSlider.value = 0
        self.updateTimeLabelText(time: 0)
        self.invalidateTimer()
    }
    
}


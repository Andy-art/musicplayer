//
//  ViewController.swift
//  MusicPlayer
//
//  Created by JeongHwan Seok on 2020/12/07.
//

import UIKit

class ViewController: UIViewController {
    
    //인스턴스 프로퍼티 //인터페이스 빌더 아웃렛
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var progressSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //                            어떤 버튼이 이 메소드를 호출했는지 매개변수로 받아옴
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        print("button tapped")
    }
    
    @IBAction func slideValueChanged(_ sender: UISlider) {
        print("slider value changed")
    }
    
}


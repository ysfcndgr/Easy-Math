//
//  ViewController.swift
//  EasyMath
//
//  Created by Can on 15.03.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var outputTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Task {
            await GeminiManager.shared.fetchMathQuestion(mathImage: UIImage(named: "s2")!) { text in
                print("text2: \(text)")
                self.outputTextView.text = text
               
                
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let cameraVC = CameraVC()
            self.navigationController?.pushViewController(cameraVC, animated: true)
        }
        
    }
}


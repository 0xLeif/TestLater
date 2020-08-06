//
//  ViewController.swift
//  TestLater
//
//  Created by Zach Eriksen on 8/4/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit
import Later

class ViewController: UIViewController {
    private let imageURL = "https://github.com/0xLeif/SwiftUIKit/blob/master/assets/SwiftUIKit_logo_v1.png?raw=true"
    
    private lazy var futureImage: LaterValue<UIImage?> = Later.promise { (promise) in
        sleep(3)
        URL(string: self.imageURL).map { url in
            Later.fetch(url: url) { data in
                guard let image = UIImage(data: data) else {
                    promise.succeed(nil)
                    return
                }
                
                promise.succeed(image)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.embed {
            Label("Hello World!")
                .text(alignment: .center)
                .configure { label in

                    Later.do(withDelay: 2) {
                        DispatchQueue.main.async {
                            label.text = "Later!"
                        }
                    }
                    
                    self.futureImage.always { result in
                        switch result {
                        case .success(let image):
                            DispatchQueue.main.async {
                                label.clear().embed {
                                    image.map { Image($0) } ?? Image(.systemRed)
                                }
                            }
                        default:
                            print("-1")
                        }
                    }
            }
        }
    }
}

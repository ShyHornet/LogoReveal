

import UIKit
import QuartzCore



class MasterViewController: UIViewController {
  
  let logo = SwiftLogoLayer.logoLayer()

    
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Start"
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    //添加手势识别器
    let tap = UITapGestureRecognizer(target: self, action: Selector("didTap"))
    view.addGestureRecognizer(tap)
    
    //把swiftlogo添加到视图上
    logo.position = CGPoint(x: view.layer.bounds.size.width/2,
      y: view.layer.bounds.size.height/2+30)
    
    logo.fillColor = UIColor.whiteColor().CGColor
    view.layer.addSublayer(logo)
  }
  
  //
  // 手势识别器的触发方法
  //
  func didTap() {
    performSegueWithIdentifier("details", sender: nil)
  }
  
}

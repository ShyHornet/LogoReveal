

import UIKit

class RevealAnimator: NSObject,UIViewControllerAnimatedTransitioning {
    let animationDuration = 2.0
    
    weak var storedContext:UIViewControllerContextTransitioning?
    
    
    var operation:UINavigationControllerOperation = .Push
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return animationDuration
        
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        //保存跳转上下文
        storedContext = transitionContext
        
        if operation == .Push{ //如果跳转方向是MasterVC--->DetailVC
          
         //从跳转上下文中取出跳转开始和目的视图控制器
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MasterViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! DetailViewController
            //将跳转目的视图控制器的主视图添加到跳转上下文的容器视图中
        transitionContext.containerView().addSubview(toVC.view)
        
        //配置变形的核心动画,将logo上移一段距离并放大到150倍
        let animation = CABasicAnimation(keyPath: "transform")
        
        animation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
        
        animation.toValue = NSValue(CATransform3D:
            CATransform3DConcat(
                CATransform3DMakeTranslation(0.0, -10.0, 0.0),
                CATransform3DMakeScale(150.0, 150.0, 1.0)
            )
        )
            
        animation.duration = animationDuration
        animation.delegate = self
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseIn)
       
            //同时给遮罩和logo添加变形动画
        toVC.maskLayer.addAnimation(animation, forKey: nil)
        fromVC.logo.addAnimation(animation, forKey: nil)
            //配置逐渐显现的核心动画
            let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
            fadeInAnimation.fromValue = 0.0
            fadeInAnimation.toValue   =  1.0
            fadeInAnimation.duration = animationDuration

            //给目的视图控制器的视图添加fade-in动画
            toVC.view.layer.addAnimation(fadeInAnimation, forKey: nil)
        }else{//如果跳转方向是返回
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)! as UIView
            
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)! as UIView
            
            transitionContext.containerView().insertSubview(toView, belowSubview: fromView)
           
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
             fromView.transform = CGAffineTransformMakeScale(0.1, 0.1)
                fromView.alpha = 0.0
                
            }, completion: { (finish) -> Void in
        transitionContext.completeTransition(true)
                
            })
        
        
        }
        
        
    }
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        
            if let context = storedContext{
        context.completeTransition(!context.transitionWasCancelled())
         //重置logo
            let fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MasterViewController
        fromVC.logo.removeAllAnimations()
        
        
            }
            storedContext = nil
            
           
            
    }
}

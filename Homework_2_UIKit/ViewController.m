#import "ViewController.h"
#import "AZRect.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.targetView = [[AZRect alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self.view addSubview: self.targetView];
    
    //Делитель, который будет нужен для вычисления цвета.
    // |parentView|
    // |[view]    |
    // |[view]    |
    // |parentView|
    self.devider = (CGRectGetMaxX(self.view.bounds) - CGRectGetMaxX(self.targetView.bounds));
}

- (void)viewWillAppear:(BOOL)animate
{
    self.targetView.backgroundColor = [UIColor grayColor];

    CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    self.targetView.center = centerPoint;
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPointInParrentView = [touch locationInView:self.view];
    
    //проверяем, что дотронулись до targetView
    UIView *hittedView = [self.view hitTest:touchPointInParrentView withEvent:event];
    if (![hittedView isEqual:self.view]){
        self.targetView = hittedView;
        
        CGPoint touchPointInTargetView = [touch locationInView:self.targetView];
        
        //смещение, задается один раз в начале процесса перемещения targetView относительно её центра
        self.touchOffset = CGSizeMake(CGRectGetMidX(self.targetView.bounds) - touchPointInTargetView.x, CGRectGetMidY(self.targetView.bounds) - touchPointInTargetView.y);
    } else {
        self.targetView = nil; //сбрасываем предыдущую ссылку на перемещающуюся View
    }
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //проверяем, что вьюха для перетаскивания установлена
    if (!self.targetView) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPointOnParrentView = [touch locationInView: self.view];
    CGPoint newTargetCenterPoint = CGPointMake(touchPointOnParrentView.x + self.touchOffset.width, touchPointOnParrentView.y + self.touchOffset.height);
    self.targetView.center = newTargetCenterPoint;
    
    //меняем цвет
    CGFloat white =  1 - (CGRectGetMinX(self.targetView.frame)  / self.devider);
    self.targetView.backgroundColor = [[UIColor alloc] initWithWhite:white alpha:1];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.targetView = nil;
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.targetView = nil;
}


@end

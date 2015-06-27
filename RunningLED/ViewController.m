//
//  ViewController.m
//  RunningLED
//
//  Created by Nguyen Minh Khue on 6/15/15.
//  Copyright (c) 2015 Nguyen Minh Khue. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end



@implementation ViewController
{
    CGFloat _margin; // > ball radius
    CGFloat _marginVertical;
    
    int _numberOfBall; //so luong cot
    int _numberOfRow; //so luong hang
    
    CGFloat _space; //> ball diameter
    
    CGFloat _ballDiameter;
    NSString* _BallColor; //tham so mau cua bong
    NSTimer * _timer; //Timer
    NSTimer * _timer2;

    int lastOnLED;  //
    int lastRowOnLED;
    
    bool direct;
    
    int lastOnLEDRight;  //
    int lastRowOnLEDRight;
    int MaTranLED[sizeof(NSUInteger)][sizeof(NSUInteger)];//mang
    NSMutableArray * InputArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    direct = true;
    
    lastOnLED = -1;
    lastRowOnLED = -1;
    
    lastOnLEDRight = -1;
    lastRowOnLEDRight = -1;
    
    _margin = 40.0; //Le trai phai
    _marginVertical = 50.0; //Le tren duoi
    
    _ballDiameter = 24.0;
    
    _numberOfBall = 5; //So luong bong tren moi hang
    _numberOfRow = 6; //So luong hang
    
    _BallColor = @"grey"; //grey or green
    
    [self checkSizeOfApp];

    [self numberOfBallvsSpace];

    [self drawRowOfBalls:_numberOfBall :_numberOfRow :_BallColor];
    
    InputArray= [[NSMutableArray alloc] init];
    
    //Tao mang 1 chieu xoan oc
    InputArray = [self GetSpiralArray:_numberOfRow :_numberOfBall];
    
    //Tao mang 1 chieu ZigZag
    //InputArray = [self GetZigZagArray:_numberOfRow :_numberOfBall];
    
    long count = [InputArray count];
    
    //In mang ra de kiem tra
    for (int dem=0; dem<count; dem++)
    {
        NSLog(@"Mang 1 chieu: %@ \n", [InputArray objectAtIndex:dem]);
    }
    
    NSString* Left2RightcolorON = @"green";
    NSString* Left2RightcolorOFF = @"grey";

    NSDictionary *userDict;
    userDict = [NSDictionary dictionaryWithObjectsAndKeys:Left2RightcolorON,
                @"ColorOn",
                Left2RightcolorOFF,
                @"ColorOFF", nil];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(runningLEDbyTAG) userInfo:userDict repeats:true];

    /* Timer thu 2 chay tu phai qua trai
     
    NSString* Right2LeftcolorON = @"sepia";
    NSString* Right2LeftcolorOFF = @"grey";
    
    NSDictionary *userDictRight2Left;
    userDictRight2Left = [NSDictionary dictionaryWithObjectsAndKeys:Right2LeftcolorON,
                @"ColorOnRight2Left",
                Right2LeftcolorOFF,
                @"ColorOFFRight2Left", nil];
    
    _timer2 = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(runningLEDfromRight2Left) userInfo:userDictRight2Left repeats:true];
     */
}

-(NSMutableArray*) GetSpiralArray:(int) SoHang : (int) SoCot{
    NSMutableArray* MaTran1Chieu= [[NSMutableArray alloc] initWithCapacity:sizeof(NSInteger)];

     int SoPhanTu = -1;
     int HangTren = 0;
     int HangDuoi = SoHang-1; //Bien duoi
     
     int CotTrai = 0;
     int CotPhai = SoCot -1; //Bien phai
     
     while ((HangTren<=HangDuoi) && (CotTrai<=CotPhai))
     {
         for (int dem = CotTrai; dem<=CotPhai; dem++)
         {
             SoPhanTu++;
             [MaTran1Chieu addObject:[NSNumber numberWithInt:MaTranLED[HangTren][dem]]];
         }
         HangTren++;
         
         for (int dem = HangTren;dem<=HangDuoi;dem++)
         {
             SoPhanTu++;
             [MaTran1Chieu addObject:[NSNumber numberWithInt:MaTranLED[dem][CotPhai]]];
         }
         CotPhai--;
         
         for (int dem=CotPhai;dem>=CotTrai;dem--)
         {
             SoPhanTu++;
             [MaTran1Chieu addObject:[NSNumber numberWithInt:MaTranLED[HangDuoi][dem]]];
         }
         HangDuoi--;
         
         for (int dem=HangDuoi;dem>=HangTren;dem--)
         {
             SoPhanTu++;
             [MaTran1Chieu addObject:[NSNumber numberWithInt:MaTranLED[dem][CotTrai]]];
         }
         CotTrai++;
     }
    return [MaTran1Chieu copy];
}

-(NSMutableArray*) GetZigZagArray:(int) SoHang : (int) SoCot{
    NSMutableArray* MaTran1Chieu= [[NSMutableArray alloc] initWithCapacity:sizeof(NSInteger)];
    
    int SoPhanTu = -1;
    
    int ChayNgang = 0;
    int ChayDoc = 0;
    
    while ((ChayNgang< SoHang-1) || (ChayDoc< SoCot-1))
    {
        //Di ngang
        if (ChayDoc==SoCot-1)
            ChayNgang++;
        else
            ChayDoc++;
        
        [MaTran1Chieu addObject:[NSNumber numberWithInt:MaTranLED[ChayNgang][ChayDoc]]];
        
        //Di duong cheo xuong
        while (ChayNgang<SoHang-1 && ChayDoc>0)
        {
            ChayNgang++;
            ChayDoc--;
            SoPhanTu++;
            [MaTran1Chieu addObject:[NSNumber numberWithInt:MaTranLED[ChayNgang][ChayDoc]]];
        }
        
        //Di xuong
        if (ChayNgang == SoHang-1)
            ChayDoc++;
        else
            ChayNgang++;
        
        [MaTran1Chieu addObject:[NSNumber numberWithInt:MaTranLED[ChayNgang][ChayDoc]]];
        
        //Di duong cheo len
        while (ChayNgang>0 && ChayDoc<SoCot-1)
        {
            ChayNgang--;
            ChayDoc++;
            SoPhanTu++;
            [MaTran1Chieu addObject:[NSNumber numberWithInt:MaTranLED[ChayNgang][ChayDoc]]];
        }
        
    }
    return [MaTran1Chieu copy];
}


-(void) runningLEDbyTAG{
    NSString * valueColorON = [[_timer userInfo] objectForKey:@"ColorOn"];
    NSString * valueColorOFF = [[_timer userInfo] objectForKey:@"ColorOFF"];
    
    long count = [InputArray count];

    long CurrentTag;
    
    if (lastOnLED != -1)
    {
        //Vi tri cu
        CurrentTag = [[InputArray objectAtIndex:lastOnLED] integerValue];
        [self turnOFFLed_Tag:(int)CurrentTag : valueColorOFF];
    }
    
    //Dao chieu khi den Tag cuoi hoac Tag dau tien
    if (lastOnLED==count-1)
    {
        direct=false;
    }
    else if (lastOnLED==0)
    {
        direct=true;
    }
    
    //Chieu thuan thi tang gia tri, chieu nghich thi giam gia tri
    if (direct)
    {
        lastOnLED++;
    }
    else
    {
        lastOnLED--;
    }
    
    //Vi tri moi
    CurrentTag = [[InputArray objectAtIndex:lastOnLED] integerValue];
    [self turnONLed_Tag:(int)CurrentTag : valueColorON];
}

-(void) runningLEDfromRight2Left{
    NSString * valueColorON = [[_timer2 userInfo] objectForKey:@"ColorOnRight2Left"];
    NSString * valueColorOFF = [[_timer2 userInfo] objectForKey:@"ColorOFFRight2Left"];
    
    //Tat LED o vi tri hien tai
    if ((lastOnLEDRight != -1) && (lastRowOnLEDRight != -1))
    {
        [self turnOFFLed:lastOnLEDRight :lastRowOnLEDRight : valueColorOFF];
    }
    
    //Bat dau
    if ((lastOnLEDRight == -1) && (lastRowOnLEDRight == -1))
    {
        //Vi tri bat dau la o hang cuoi, cot cuoi
        lastOnLEDRight=_numberOfBall - 1;
        lastRowOnLEDRight = _numberOfRow-1;
    }
    //Neu chua chay het cot
    else if (lastOnLEDRight != 0)
    {
        //Van chua het cot thi lui lai 1 vi tri
        lastOnLEDRight--;
    }
    //Neu da chay het cot
    else if (lastOnLEDRight == 0)
    {
        //Neu hang hien tai khong phai hang dau tien
        if (lastRowOnLEDRight!=0)
        {
            //Cho ve vi tri cot cuoi cung va lui lai 1 hang
            lastOnLEDRight = _numberOfBall - 1;
            lastRowOnLEDRight--;
        }
        else
        {
            //Neu la hang dau tien thi dat lai vi tri hang cuoi, cot cuoi
            lastOnLEDRight=_numberOfBall - 1;
            lastRowOnLEDRight = _numberOfRow-1;
        }
    }
    //Neu ma la cot dau, hang dau thi cho ve vi tri cuoi cung
    else {  //Reach the first LED in row, move to last LED
        lastOnLEDRight=_numberOfBall - 1;
        lastRowOnLEDRight = _numberOfRow-1;
    }
    
    //Bat LED o vi tri moi len
    [self turnONLed:lastOnLEDRight :lastRowOnLEDRight : valueColorON];
}

-(void) runningLEDfromLeft2Right{
    NSString * valueColorON = [[_timer userInfo] objectForKey:@"ColorOn"];
    NSString * valueColorOFF = [[_timer userInfo] objectForKey:@"ColorOFF"];
    
    if ((lastOnLED != -1) && (lastRowOnLED != -1))
    {
        [self turnOFFLed:lastOnLED :lastRowOnLED : valueColorOFF];
    }
    
    if ((lastOnLED == -1) && (lastRowOnLED == -1))
    {
        lastOnLED=0;
        lastRowOnLED = 0;
    }
    else if (lastOnLED != _numberOfBall - 1)
    {
         lastOnLED++;

    }
    else if (lastOnLED == _numberOfBall - 1)
    {
        if (lastRowOnLED!=_numberOfRow-1)
        {
            lastOnLED = 0;
            lastRowOnLED++;
        }
        else
        {
            lastOnLED = 0;
            lastRowOnLED = 0;
        }
    }
    else {  //Reach the last LED in row, move to first LED
        lastOnLED = 0;
        lastRowOnLED = 0;
    }
    
    [self turnONLed:lastOnLED :lastRowOnLED : valueColorON];
}

- (void) placeBallAtX: (CGFloat) x
                andY:(CGFloat) y
                withTag:(int) tag
                color: (NSString*) BallColor
{
    UIImageView* ball= [[UIImageView alloc] initWithImage:[UIImage imageNamed:BallColor]];
    ball.center=CGPointMake(x,y);
    ball.tag= tag;
    NSLog(@"Tag: %i", tag);
    
    [self.view addSubview:ball];
    
    NSLog(@"Ball Size Width: %3.0f - Height: %3.0f", ball.bounds.size.width,ball.bounds.size.height);

}

- (CGFloat) spaceBetweenBallCenterWhenNumberBallIsKnown: (int) n{
    CGFloat spaceBetweenBall;
    if (n<=1)
    {
        spaceBetweenBall= 0.0;
    }
    else
    {
        spaceBetweenBall=(self.view.bounds.size.width - 2 * _margin) / (n - 1);
    }
    return spaceBetweenBall;
}

- (CGFloat) spaceInHeightBetweenBallCenterWhenNumberBallIsKnown: (int) n{
    CGFloat spaceBetweenBall;
    if (n<=1)
    {
        spaceBetweenBall= 0.0;
    }
    else
    {
        spaceBetweenBall=(self.view.bounds.size.height - 2 * _marginVertical) / (n - 1);
    }
    return spaceBetweenBall;
}

- (void) drawRowOfBalls: (int) numberBalls
                       : (int) numberRow
                 : (NSString*) BallColor{
    CGFloat space = [self spaceBetweenBallCenterWhenNumberBallIsKnown:numberBalls];
    CGFloat spaceVertical = [self spaceInHeightBetweenBallCenterWhenNumberBallIsKnown:numberRow];
    
    int tagValue;
    
    for (int row = 0; row <numberRow ; row ++)
    {
        for (int col = 0; col < numberBalls ; col++)
        {
            tagValue=col + row * 10 + 100;
            
            MaTranLED[row][col] = tagValue;
            
            [self placeBallAtX:_margin + col * space
                      andY:_marginVertical + row * spaceVertical
                   withTag:tagValue
                        color:BallColor];
        }
    }
}

- (void) numberOfBallvsSpace{
    BOOL stop = false;
    int n = 3;
    while (!stop)
    {
        CGFloat space = [self spaceBetweenBallCenterWhenNumberBallIsKnown: n];
        if (space < _ballDiameter){
            stop = true;
        }else{
            NSLog(@"Number of ball %d, space between ball center %3.0f",n,space);
        }
        n++;
    }
}

-(void) turnONLed: (int) index : (int) row : (NSString*) color{
    NSLog(@"LED Tag: %i",index + row * 10 + 100);
    UIView* view= [self.view viewWithTag:index + row * 10 + 100];
    if (view && [view isMemberOfClass:[UIImageView class]])
    {
        UIImageView* ball= (UIImageView*) view;
        ball.image= [UIImage imageNamed:color];
        NSLog(@"Turn ON LED Tag: %i",index + row * 10 + 100);
    }
    
}

-(void) turnOFFLed: (int) index : (int) row : (NSString*) color{
    NSLog(@"LED Tag: %i",index + row * 100 + 100);
    UIView* view= [self.view viewWithTag:index + row * 10 + 100];
    if (view && [view isMemberOfClass:[UIImageView class]])
    {
        UIImageView* ball= (UIImageView*) view;
        ball.image= [UIImage imageNamed:color];
        NSLog(@"Turn OFF LED Tag: %i",index + row * 10 + 100);
    }
    
}

-(void) turnONLed_Tag: (int) TagOnLED : (NSString*) color{
    NSLog(@"LED Tag: %i",TagOnLED);
    UIView* view= [self.view viewWithTag:TagOnLED];
    if (view && [view isMemberOfClass:[UIImageView class]])
    {
        UIImageView* ball= (UIImageView*) view;
        ball.image= [UIImage imageNamed:color];
        NSLog(@"Turn ON LED Tag: %i",TagOnLED);
    }
    
}

-(void) turnOFFLed_Tag: (int) TagLED : (NSString*) color{
    NSLog(@"LED Tag: %i",TagLED);
    UIView* view= [self.view viewWithTag:TagLED];
    if (view && [view isMemberOfClass:[UIImageView class]])
    {
        UIImageView* ball= (UIImageView*) view;
        ball.image= [UIImage imageNamed:color];
        NSLog(@"Turn OFF LED Tag: %i",TagLED);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void) checkSizeOfApp{
    
    CGSize size= self.view.bounds.size;
    NSLog(@"width: %3.0f - height: %3.0f", size.width, size.height);
}

@end

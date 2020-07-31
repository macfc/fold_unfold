//
//  ViewController.m
//  Fold_Unfold
//
//  Created by MU on 2020/7/31.
//  Copyright © 2020 MU. All rights reserved.
//

#import "ViewController.h"
#import "YYText.h"

@interface ViewController ()

@property (nonatomic, strong) YYLabel *textLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"【显示全部】or【收起】效果";
    label.font = [UIFont systemFontOfSize:20.f];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    [self.view addSubview:self.textLabel];
    
    label.frame = CGRectMake(25.f, 100.f, [UIScreen mainScreen].bounds.size.width - 2*25.f, 30.f);
    _textLabel.frame = CGRectMake(25.f, 100.f + 20.f + 30.f, [UIScreen mainScreen].bounds.size.width - 2*25.f, 20.f);
    
    [self configLabel];
}
 
- (void)configLabel {
    self.textLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14.f];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"用户起诉抖音和微信读书侵犯个人隐私案件有了新进展。据央视新闻报道，7月30日，北京互联网法院作出一审宣判，认定抖音、微信读书均有侵害用户个人信息的情形。两案也成为《中华人民共和国民法典》颁布后，体现民法典保护互联网时代公民个人信息权益的典型案件。"];
    attr.yy_font = self.textLabel.font;
    attr.yy_lineSpacing = 5.f;
    attr.yy_color = [UIColor whiteColor];
    self.textLabel.attributedText = attr;
    NSString *foldIdentifer = @" ... 展开";
    NSMutableAttributedString *foldText = [[NSMutableAttributedString alloc] initWithString:foldIdentifer];
    NSRange expandRange = [foldText.string rangeOfString:foldIdentifer];
    
    [foldText addAttribute:NSForegroundColorAttributeName value:[UIColor systemOrangeColor] range:expandRange];
    [foldText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, expandRange.location)];
    
    //添加点击事件
    YYTextHighlight *foldHi = [YYTextHighlight new];
    [foldText yy_setTextHighlight:foldHi range:[foldText.string rangeOfString:foldIdentifer]];
    
    __weak typeof(self) weakSelf = self;
    foldHi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        //点击展开
        [weakSelf configStatusWithIsFold:YES];
    };
    
    foldText.yy_font = attr.yy_font;
    foldText.yy_lineSpacing = attr.yy_lineSpacing;
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = foldText;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:foldText.yy_font alignment:YYTextVerticalAlignmentTop];
    
    self.textLabel.truncationToken = truncationToken;
    
    [self configStatusWithIsFold:NO];
}

//点击展开
- (NSAttributedString *)foldText {
    NSString *appendText = @" 收起";
    if ([self.textLabel.attributedText.string containsString:appendText]) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
 
    NSMutableAttributedString *append = [[NSMutableAttributedString alloc] initWithString:appendText attributes:@{NSFontAttributeName : self.textLabel.font, NSForegroundColorAttributeName : [UIColor systemOrangeColor]}];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [append yy_setTextHighlight:hi range:[append.string rangeOfString:appendText]];
    
    __weak typeof(self) weakSelf = self;
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        [weakSelf configStatusWithIsFold:NO];
    };
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = append;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:append.yy_font alignment:YYTextVerticalAlignmentTop];
    
    self.textLabel.truncationToken = truncationToken;

    return append;
}
 
//点击收起
- (void)unfoldText {
    NSString *appendText = @" ... 展开";
    if ([self.textLabel.attributedText.string containsString:appendText]) {
        return ;
    }

    NSMutableAttributedString *append = [[NSMutableAttributedString alloc] initWithString:appendText attributes:@{NSFontAttributeName : self.textLabel.font, NSForegroundColorAttributeName : [UIColor systemOrangeColor]}];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [append yy_setTextHighlight:hi range:[append.string rangeOfString:appendText]];
    
    __weak typeof(self) weakSelf = self;
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        [weakSelf configStatusWithIsFold:YES];
    };
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = append;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:append.yy_font alignment:YYTextVerticalAlignmentTop];
    
    self.textLabel.truncationToken = truncationToken;
}
 
- (void)configStatusWithIsFold:(BOOL)isFold {
    if (isFold) {
        //当前状态：展开
        NSMutableAttributedString *attri = [self.textLabel.attributedText mutableCopy];
        [attri appendAttributedString:[self foldText]];
        self.textLabel.attributedText = attri;
        self.textLabel.numberOfLines = 0;
    } else {
        //当前状态：收起
        [self unfoldText];
        self.textLabel.numberOfLines = 2;
    }
    CGFloat maxWidth = self.textLabel.frame.size.width;
    YYTextContainer *summaryContainer = [YYTextContainer new];
     //限制宽度
    summaryContainer.size = CGSizeMake(maxWidth, CGFLOAT_MAX);
    summaryContainer.maximumNumberOfRows = self.textLabel.numberOfLines;
    YYTextLayout *smmaryLayout = [YYTextLayout layoutWithContainer:summaryContainer text:self.textLabel.attributedText];
    CGSize s_size = CGSizeMake(maxWidth, smmaryLayout.textBoundingSize.height);
    self.textLabel.frame = CGRectMake(25.f, self.textLabel.frame.origin.y, [UIScreen mainScreen].bounds.size.width - 2*25.f, s_size.height);
}

- (YYLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [YYLabel new];
        _textLabel.numberOfLines = 2;
        _textLabel.backgroundColor = [UIColor systemBlueColor];
    }
    
    return _textLabel;
}

@end

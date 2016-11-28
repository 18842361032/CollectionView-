//
//  RootViewController.m
//  CollectionView多选删除图片
//
//  Created by admin on 16/10/12.
//  Copyright © 2016年 Danae. All rights reserved.
//

#import "RootViewController.h"
#import "ImgCollectionViewCell.h"
//屏幕宽高
#define kSCREEN_W [UIScreen mainScreen].bounds.size.width
#define kSCREEN_H [UIScreen mainScreen].bounds.size.height

@interface RootViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    BOOL isEdit;/** 记录当前是否为编辑状态*/
    NSMutableArray *imgDataArr;/** 图片数组*/
    NSMutableArray *selectedImgArr;/** 所选择图片数组*/
}

@property (nonatomic, strong) UICollectionView *collectionview;/** collectionView */

@end

@implementation RootViewController

#pragma mark - 点击编辑按钮
- (void)editorAction:(UIBarButtonItem *)item
{
    // 如果当前编辑状态为YES 则将编辑替换成取消，显示删除按钮
    if (isEdit == NO) {
        self.navigationItem.rightBarButtonItem.title  = @"取消";
        self.navigationItem.leftBarButtonItem.title = @"删除";
        isEdit = YES;
        
        [_collectionview reloadData];
    }else{
        // 如果当前编辑状态为NO 则将取消替换成编辑，删除按钮隐藏
        self.navigationItem.rightBarButtonItem.title  = @"编辑";
        self.navigationItem.leftBarButtonItem.title = @"";
        // 清空选中数组中的数据
        [selectedImgArr removeAllObjects];
        isEdit = NO;
        [_collectionview reloadData];
    }
    
}

#pragma mark - 点击删除按钮
- (void)deleteAction:(UIBarButtonItem *)item
{
    if (imgDataArr.count && selectedImgArr.count) {
        [imgDataArr removeObjectsInArray:selectedImgArr];
        [selectedImgArr removeAllObjects];
        [_collectionview reloadData];
    }else{
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    isEdit = NO;
    imgDataArr = [NSMutableArray arrayWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5" ,@"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19"]];
    selectedImgArr = [NSMutableArray array];
    [self setNavigation];
    [self createCollectionView];
    
}

#pragma mark - 设置navgationItem
- (void)setNavigation
{
    // 设置右侧navigationitme
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editorAction:)];
    self.navigationItem.rightBarButtonItem = item;
    // 设置左侧navigationitme
    UIBarButtonItem *deleitem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAction:)];
    self.navigationItem.leftBarButtonItem = deleitem;
}

#pragma mark - 创建collectionView
- (void)createCollectionView
{
    // 创建flowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置collectionView滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 设置cell大小
    layout.itemSize = CGSizeMake((kSCREEN_W - 40) / 3, (kSCREEN_W - 40) / 3 * 1.3);
    // 设置cell距上左下右的距离
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    // 创建CollectionView
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_W, kSCREEN_H) collectionViewLayout:layout];
    // 设置代理人
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    // 允许多选
    self.collectionview.allowsMultipleSelection = YES;
    // 设置collectionView背景色，默认为黑色
    self.collectionview.backgroundColor = [UIColor whiteColor];
    // 将collectionView 添加到父视图上
    [self.view addSubview:self.collectionview];
    // 注册重用池
    [_collectionview registerClass:[ImgCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark - collectionView datasourse & delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    // 获取cell的img的图片名字字符串
    NSString *imgid = [NSString stringWithFormat:@"%d.jpg", [imgDataArr[indexPath.row] intValue]];
    // 给cell的imageView赋值
    cell.img.image = [UIImage imageNamed:imgid];
    // 如果不是编辑转台
    if (isEdit == NO) {
        // 隐藏按钮
        cell.selectedImg.hidden = YES;
        // cell的用户交互关掉
        cell.userInteractionEnabled = NO;
    }else{
        // 如果为编辑状态
        // 显示所有按钮
        cell.selectedImg.hidden = NO;
        // cell的用户交互打开
        cell.userInteractionEnabled = YES;
        // 判断cell是否为选中状态
        if (cell.isSelected) {
            //如果是选中状态，则将将图片设置为选中 （划出屏外不会消失）
            cell.selectedImg.image = [UIImage imageNamed:@"Selected"];
        } else {
            // 如果不是选中状态，则将图片设置为未选中 
            cell.selectedImg.image = [UIImage imageNamed:@"UnSelected"];
        }
    }
    return cell;
}

#pragma mark - 点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 如果是编辑状态
    if (isEdit == YES) {
        // 找到items(获取) 自定义的注意强转
        ImgCollectionViewCell *cell = (ImgCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        // 设置被点击cell的选中按钮显示为选中状态
        cell.selectedImg.image = [UIImage imageNamed:@"Selected"];
        // 将所点击cell下标进行记录
        NSString *str = imgDataArr[indexPath.row];
        // 存到数组中
        [selectedImgArr addObject:str];
    }else{
    }
}

#pragma mark - 点击结束后（相当于第二次点击cell）
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // 找到items(获取) 自定义的注意强转
    ImgCollectionViewCell *cell = (ImgCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // 设置被点击cell的选中按钮显示为未选中状态
    cell.selectedImg.image = [UIImage imageNamed:@"UnSelected"];
    // 将所点击cell下标进行记录
    NSString *str = imgDataArr[indexPath.row];
    // 存到数组中
    [selectedImgArr removeObject:str];
}


#pragma mark - items设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((kSCREEN_W - 40) / 3, (kSCREEN_W - 40) / 3 * 1.3);
}

#pragma mark - items的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imgDataArr.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

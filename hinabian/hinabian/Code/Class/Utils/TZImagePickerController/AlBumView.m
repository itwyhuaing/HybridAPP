//
//  AlBumView.m
//  hinabian
//
//  Created by 何松泽 on 2017/8/16.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "AlBumView.h"
#import "TZAssetModel.h"
#import "TZAssetCell.h"
#import "TZImageManager.h"
#import "TZImagePickerController.h"
#import "TZPhotoPickerController.h"

@interface AlBumView() <UITableViewDataSource,UITableViewDelegate> {
    /*内容视图*/
    UITableView *_tableView;
    
    /*背景图*/
    UIButton *_backView;
    
}

@property (nonatomic, strong) NSMutableArray *albumArr;
/*被选中的Model*/
@property (nonatomic, strong) TZAlbumModel *preModel;

@end

@implementation AlBumView

+ (instancetype)albumViewWithData:(NSArray *)data superViewController:(UIViewController *)superViewController{
    AlBumView *ablumView = [[self alloc]init];
    ablumView.superViewController = superViewController;
    [ablumView.albumArr enumerateObjectsUsingBlock:^(TZAlbumModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            ablumView.preModel = obj;
            *stop = YES;
        }
    }];
    return ablumView;
}

- (instancetype)initWithFrame:(CGRect)frame superViewController:(UIViewController *)superViewController preModel:(TZAlbumModel *)preModel{
    if (self = [super initWithFrame:frame]) {
        self.superViewController = superViewController;
        _preModel = preModel;
        [self setUpViews];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder superViewController:(UIViewController *)superViewController{
    if (self = [super initWithCoder:aDecoder]) {
        self.superViewController = superViewController;
        
        [self setUpViews];
    }
    return self;
}
- (void)setUpViews{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.3f]];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(dismissFromSuper) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    _backView = btn;
    
    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.superViewController.navigationController;
    [imagePickerVc hideProgressHUD];
    if (_albumArr) {
        for (TZAlbumModel *albumModel in _albumArr) {
            albumModel.selectedModels = imagePickerVc.selectedModels;
        }
        [_tableView reloadData];
    } else {
        [self configTableView];
    }
    
}

- (void)configTableView {
    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.superViewController.navigationController;
    [[TZImageManager manager] getAllAlbums:imagePickerVc.allowPickingVideo allowPickingImage:imagePickerVc.allowPickingImage completion:^(NSArray<TZAlbumModel *> *models) {
        _albumArr = [NSMutableArray arrayWithArray:models];
        for (TZAlbumModel *albumModel in _albumArr) {
            albumModel.selectedModels = imagePickerVc.selectedModels;
        }
        if (!_tableView) {
            CGFloat top = 44;
            if (iOS7Later) top += 20;
            _tableView = [[UITableView alloc] init];
            _tableView.rowHeight = 70;
            _tableView.tableFooterView = [[UIView alloc] init];
            _tableView.dataSource = self;
            _tableView.delegate = self;
            [_tableView registerClass:[TZAlbumCell class] forCellReuseIdentifier:@"TZAlbumCell"];
            [self addSubview:_tableView];
        } else {
            [_tableView reloadData];
        }
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat top = 44;
    if (iOS7Later) top += 20;
    CGFloat height = 0.7*SCREEN_HEIGHT;
    
    _tableView.frame = CGRectMake(0, top, self.bounds.size.width, height);
    _backView.frame = CGRectMake(0, top, self.bounds.size.width, SCREEN_HEIGHT);
}

- (void)dismissFromSuper{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldRemoveFrom:)]) {
        [self.delegate shouldRemoveFrom:self];
    }
}


#pragma mark - UITableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TZAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZAlbumCell"];
    cell.selectedCountButton.backgroundColor = [UIColor colorWithRed:24.f/255.f green:143.f/255.f blue:255.f/255.f alpha:1.f];
    cell.model = _albumArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TZPhotoPickerController *photoPickerVc = [[TZPhotoPickerController alloc] init];
    photoPickerVc.columnNumber = self.columnNumber;
    TZAlbumModel *model = _albumArr[indexPath.row];
    if (model == self.preModel) {
        return;
    }
    model.isSelected = YES;
    self.preModel.isSelected = NO;
    photoPickerVc.model = model;
    [self.albumArr replaceObjectAtIndex:indexPath.row withObject:model];

    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCellForIndex:ForView:Model:)]) {
        [self.delegate clickCellForIndex:indexPath ForView:self Model:model];
    }
    [self dismissFromSuper];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end


@implementation UIImage (MyBundle)

+ (UIImage *)imageNamedFromMyBundle:(NSString *)name {
    UIImage *image = [UIImage imageNamed:[@"TZImagePickerController.bundle" stringByAppendingPathComponent:name]];
    if (image) {
        return image;
    } else {
        image = [UIImage imageNamed:[@"Frameworks/TZImagePickerController.framework/TZImagePickerController.bundle" stringByAppendingPathComponent:name]];
        if (!image) {
            image = [UIImage imageNamed:name];
        }
        return image;
    }
}


@end

//
//  JJImagePicker.m
//  ESKUTE
//
//  Created by HJJ on 2021/6/8.
//
//  UIImagePickerController除了相机外的两个sourceType将会在未来的版本中被废弃
//  取而代之的是PHPicker，iOS14可以开始使用PHPickerViewController

#import "JJImagePicker.h"
#import "UIImage+Compress.h"
#import <PhotosUI/PhotosUI.h>

static JJImagePicker *picker = nil;

@interface JJImagePicker ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate>

@property (nonatomic, copy) PickeImageCompletedBlock completedBlock;

@end

@implementation JJImagePicker

#pragma mark - 初始化
+ (instancetype)sharedPicker {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        picker = [[super allocWithZone:NULL] init];
    });
    return picker;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [JJImagePicker sharedPicker];
}

- (instancetype)copyWithZone:(nullable NSZone *)zone {
    return [JJImagePicker sharedPicker];
}

- (instancetype)mutableCopyWithZone:(nullable NSZone *)zone {
    return [JJImagePicker sharedPicker];
}

#pragma mark -
// 从相册选择
- (void)getPictureWithAlbum {
    if (@available(iOS 14, *)) {
        // 初始化配置
        PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] init];
        // 设置多媒体类型，默认为 imagesFilter，传多个类型用[PHPickerFilter anyFilterMatchingSubfilters:(NSArray<PHPickerFilter *> *)subfilters]
        configuration.filter = [PHPickerFilter imagesFilter];
        // 设置最大选择上限，默认为1(即单选)，0表示跟随系统允许的上限
        configuration.selectionLimit = 1;
        // 初始化控制器
        PHPickerViewController *phPickerController = [[PHPickerViewController alloc] initWithConfiguration:configuration];
        // 设置代理
        phPickerController.delegate = self;
        // 弹出控制器
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:phPickerController animated:YES completion:nil];
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            // 设置数据来源为相册
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            // 设置代理
            imagePickerController.delegate = self;
            // 打开相册
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}
// 拍照
- (void)getPictureWithCamera {// 调用相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        // 设置数据来源为摄像头
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 设置代理
        imagePickerController.delegate = self;
        // 模态弹出类型为全屏
        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        //
        imagePickerController.showsCameraControls = YES;
        // 开启相机
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [UIImage handleImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    if (self.completedBlock) {
        self.completedBlock(image);
    }
    // 将代理置空，防止触发多次代理方法（手机卡顿时，连点会触发多次代理方法）
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// 用户取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PHPickerViewController Delegate
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results  API_AVAILABLE(ios(14)){
    NSItemProvider *itemProvider = results.firstObject.itemProvider;
    if ([itemProvider canLoadObjectOfClass:UIImage.class]) {
        __weak typeof(self) weakSelf = self;
        [itemProvider loadObjectOfClass:UIImage.class completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            if ([object isKindOfClass:UIImage.class]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    UIImage *image = [UIImage handleImage:object];
                    if (strongSelf.completedBlock) {
                        strongSelf.completedBlock(image);
                    }
                });
            }
        }];
    }
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - block
- (void)pickImageFromAlbumCompleted:(PickeImageCompletedBlock)completed {
    [self getPictureWithAlbum];
    self.completedBlock = completed;
}

- (void)pickImageFromCamaraCompleted:(PickeImageCompletedBlock)completed {
    [self getPictureWithCamera];
    self.completedBlock = completed;
}

@end

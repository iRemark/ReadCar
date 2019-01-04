//
//  ViewController.m
//  ReadCar
//
//  Created by lichao on 2019/1/4.
//  Copyright © 2019 charles. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (IBAction)action:(NSButton *)sender {
    sender.enabled = false;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = true;
    });
    
    NSString *fromPath = self.sourceField.stringValue;
    NSString *toPath = self.toField.stringValue;
    
    if (fromPath.length == 0) {
        [self showAlert:@"提示" info:@"请输入.car 文件路径"]; return;
    }
    if (toPath.length == 0) {
        NSString *desktop = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSString *dirPath = [NSString stringWithFormat:@"%@/assetsFile",desktop];
        
        NSError *createError = [self createFile:dirPath];
        
        if (createError != nil) {
            [self showAlert:@"请输入解析到的路径" info:createError.description]; return;
        }
        toPath = dirPath;
    }
    
    if (fromPath.length > 0 && toPath.length > 0) {
        NSError *error = exportCarFileAtPath(fromPath, toPath);
        if (error == nil) {
            [self openFile:toPath];
            [self showAlert:@"提示" info:@"解析成功"]; return;
            
        }else {
            [self showAlert:@"" info:error.description.description]; return;
        }
    }
}

- (void)openFile:(NSString *)dirPath {
    NSURL *fileURL = [NSURL fileURLWithPath: dirPath];
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    [workspace selectFile:[fileURL path] inFileViewerRootedAtPath:nil];
}

- (NSError *)createFile:(NSString *)dirPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: dirPath]) {
        NSError *error = nil;
        BOOL isSuccess = [fileManager createDirectoryAtPath: dirPath withIntermediateDirectories:YES attributes:nil error: &error];
        
        if (error != nil) {
            return error;
        }
        
        NSLog(@"error = %@",error);
        NSLog(@"isSiccess = %d",isSuccess);
    }

    return nil;
    
//    NSError *error = nil;
//    BOOL isSuccess = [file writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
//    if (isSuccess && error == nil) {
//        NSLog(@"存储成功！！！");
//    }else{
//        NSLog(@"error = %@",error);
//        NSLog(@"存储失败！！！");
//    }
    
//    作者：KODIE
//    链接：https://www.jianshu.com/p/646c74d3efea
//    來源：简书
//    简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
//
//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSArray *paths = [fm URLsForDirectory:NSDesktopDirectory inDomains:NSUserDomainMask];
//    NSURL *path = [paths objectAtIndex:0];
//
//    NSString *myFiledFolder = [path.relativePath stringByAppendingFormat:@"/assets"];
//    NSString *myFiled = [myFiledFolder stringByAppendingFormat:@"/%.0f",[NSDate timeIntervalSinceReferenceDate]];
//    BOOL result = [fm fileExistsAtPath:myFiled];
//    if (!result) {
//        NSError *error;
//        BOOL isCreate = [fm createDirectoryAtPath:myFiledFolder withIntermediateDirectories:YES attributes:nil error:&error];
//        if (isCreate) {
//            return YES;
//        }
//    }
//    return NO;
}

- (void)showAlert:(NSString *)message info:(NSString *)info{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSAlertStyleWarning;
    [alert addButtonWithTitle:@"ok"];
    alert.messageText = message;
    alert.informativeText = info;
    
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
        NSLog(@"returnCode: %ld", (long)returnCode);
        
        if (returnCode == NSAlertFirstButtonReturn) {
            NSLog(@"确定");
        } else if (returnCode == NSAlertSecondButtonReturn) {
            NSLog(@"取消");
        } else {
            NSLog(@"其他按钮");
        }
    }];
}

@end

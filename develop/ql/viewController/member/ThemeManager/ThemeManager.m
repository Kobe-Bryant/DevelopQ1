//
//  ThemeManager.m
//  WXWeibo
//
//  Created by chenfeng on 13-5-14.
//  Copyright (c) 2014年 yunlai.cn. All rights reserved.
//

#import "ThemeManager.h"
#import "FileManager.h"
#import "chooseOrg_model.h"
//#import "theme_config_model.h"

static ThemeManager *sigleton = nil;

@implementation ThemeManager

- (id)init {
    self = [super init];
    if (self != nil) {
        //初始化主题配置文件
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
//        _themesConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        chooseOrg_model* themeMod = [[chooseOrg_model alloc] init];
        
        NSArray* themeArr = [themeMod getList];
        
        _themesConfig = [NSMutableDictionary dictionaryWithCapacity:0];
        
        for (NSDictionary* dic in themeArr) {
            [_themesConfig setObject:[NSString stringWithFormat:@"%@%@",[dic objectForKey:@"org_name"],[dic objectForKey:@"id"]] forKey:[dic objectForKey:@"org_name"]];
        }
        [themeMod release];
        
        [_themesConfig retain];
        
        //初始化字体配置文件
        NSString *fontConfigPath = [[NSBundle mainBundle] pathForResource:@"fontColor" ofType:@"plist"];
        _fontConfig = [[NSDictionary dictionaryWithContentsOfFile:fontConfigPath] retain];
        
        self.themeName = @"默认";
    }
    return self;
}

-(void) setThemesConfig:(NSMutableDictionary *)themesConfig{
    _themesConfig = [themesConfig copy];
}

- (void)setThemeName:(NSString *)themeName {
    if (_themeName != themeName) {
        [_themeName release];
        _themeName = [themeName copy];
    }

    //获取主题包的根目录
    NSString *themePath = [self getThemePath];
    NSString *filePath = [themePath stringByAppendingPathComponent:@"fontColor.plist"];
    
    self.fontConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
//    DLog(@"%@",self.fontConfig);
}

//获取当前主题包的目录
- (NSString *)getThemePath {
   
    NSString *path;
    
    if ([self.themeName isEqualToString:@"默认"]) {
        //项目包的根路径
        path = [[NSBundle mainBundle] resourcePath];
        
    }else{
        
        //取得当前主题的子路径: Skins/
        NSString *subPath = [_themesConfig objectForKey:self.themeName];
        //主题的完整路径
        path = [FileManager getFileDBPath:subPath];
        
    }
    return path;
}

//获取当前主题下的图片
- (UIImage *)getThemeImage:(NSString *)imageName {
    if (imageName.length == 0) {
        return nil;
    }
    
    //获取当前主题包的目录
    NSString *path = [self getThemePath];
    
    //imageName在当前主题的文件路径
    NSString *imagePath = [path stringByAppendingPathComponent:imageName];
    
//    DLog(@"%@",imagePath);
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    //获取不到图片，则使用工程目录下的图
    if (image == nil) {
        image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imageName]];
    }
    
    return image;
}

//返回当前主题下的颜色
- (UIColor *)getColorWithName:(NSString *)name {
    if (name.length == 0) {
        return nil;
    }

    NSString *rgb = [self.fontConfig objectForKey:name];
    if (rgb == nil) {
        
        rgb = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fontColor" ofType:@"plist"]] objectForKey:name];
    }
    NSArray *rgbs = [rgb componentsSeparatedByString:@","];
    if (rgbs.count == 3) {
        float r = [rgbs[0] floatValue];
        float g = [rgbs[1] floatValue];
        float b = [rgbs[2] floatValue];
        UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
        return color;
    }
    
    return nil;
}



#pragma mark - 单列相关的方法
+ (ThemeManager *)shareInstance {
    if (sigleton == nil) {
        @synchronized(self){
            sigleton = [[ThemeManager alloc] init];
        }
    }
    return sigleton;
}

//限制当前对象创建多实例
#pragma mark - sengleton setting
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sigleton == nil) {
            sigleton = [super allocWithZone:zone];
        }
    }
    return sigleton;
}

+ (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;
}

- (oneway void)release {
}

- (id)autorelease {
    return self;
}

@end

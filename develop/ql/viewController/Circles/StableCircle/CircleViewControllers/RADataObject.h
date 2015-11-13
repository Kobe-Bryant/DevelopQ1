
//The MIT License (MIT)
//
//Copyright (c) 2013 Rafał Augustyniak
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

@interface RADataObject : NSObject

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSArray *children;
@property (retain, nonatomic) NSString *count;
@property (retain, nonatomic) NSString *type; //判断是组织还是圈子

@property (retain, nonatomic) NSString *picImage;
@property (assign, nonatomic) NSInteger userId;
@property (retain, nonatomic) NSString *companyName;

- (id)initWithName:(NSString *)name count:(NSString *)count children:(NSArray *)array type:(NSString *)type;

+ (id)dataObjectWithName:(NSString *)name count:(NSString *)count  children:(NSMutableArray *)children type:(NSString *)type;


- (id)initWithName:(NSString *)name
                 picImage:(NSString *)picImage
                 userId:(NSInteger)userId
                 companyName:(NSString *)companyName
                 type:(NSString *)type;

+ (id)dataObjectWithName:(NSString *)name
                  picImage:(NSString *)picImage
                  userId:(NSInteger)userId
                  companyName:(NSString *)companyName
                  type:(NSString *)type;


@end

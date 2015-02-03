//
//  PDHTTPEngine.m
//  PDKitchen
//
//  Created by bright on 14/12/17.
//  Copyright (c) 2014年 mtf. All rights reserved.
//

#import "PDHTTPEngine.h"

@implementation PDHTTPEngine

-(id)init{
    self = [super init];
    if (self) {
        _HTTPEngine = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kHttpHost]];
        _HTTPEngine.requestSerializer = [[AFJSONRequestSerializer alloc] init];
        _HTTPEngine.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    }
    return self;
}

+(PDHTTPEngine *)sharedInstance{
    static dispatch_once_t once;
    static PDHTTPEngine * __singleton = nil;
    dispatch_once( &once, ^{ __singleton = [[PDHTTPEngine alloc] init]; } );
    return __singleton;
}

- (NSString *)signWithPath:(NSString *)path params:(NSMutableDictionary *)params password:(NSString *) password{
    
    NSMutableDictionary *p = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    // 添加版本，设备ID，平台等公用参数
    NSString *versionstr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [p setObject:versionstr forKey:@"version"];
    NSString *device = [[UIDevice currentDevice] deviceKeychanID];
    [p setObject:device forKey:@"device"];
    [p setObject:@"ios" forKey:@"plateform"];
    
    NSMutableString *sign = [[NSMutableString alloc] init];
    [sign appendString:path];
    for (NSString *key in [p keysSortedByValueUsingSelector:@selector(compare:)]) {
        [sign appendString:[NSString stringWithFormat:@"%@%@",key,p[key]]];
    }
    [sign appendString:password];
    
    return [sign md5];
}

- (NSMutableDictionary *)paramWithDictionary:(NSMutableDictionary *)dict{
    
    return dict;
}
-(void)sendverificationWithphone:(NSString *)phone
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:phone forKey:@"phone"];
    parameters = [self paramWithDictionary:parameters];
    [_HTTPEngine GET:klogicPathOfSendverification parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        int code = [result[@"code"] intValue];
        NSString *msg = result[@"msg"];
        id data = result[@"data"];
        if (code == 0) {
            success(operation,data);
        }else{
            [self tokenExpireWithCode:code];
            NSError *err = [NSError errorWithDomain:kHttpHost code:code userInfo:@{@"Message":msg}];
            failure(operation,err);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        NSLog(@"%@",error);
        NSError *err = [NSError errorWithDomain:kHttpHost code:error.code userInfo:@{@"Message":@"没有网络"}];
        failure(operation,err);
    }];
}
-(void)registerWithphone:(NSString *)phone
            verification:(NSString*)verification
                password:(NSString *)password
                    type:(NSString*)type
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:phone forKey:@"phone"];
    [parameters setObject:verification forKey:@"verification"];
    [parameters setObject:password forKey:@"password"];
    [parameters setObject:type forKey:@"type"];
    parameters = [self paramWithDictionary:parameters];
    
    [_HTTPEngine GET:klogicPathOfRegister parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        int code = [result[@"code"] intValue];
        NSString *msg = result[@"msg"];
        if (code == 0) {
            success(operation,result);
        }else{
            [self tokenExpireWithCode:code];
            NSError *err = [NSError errorWithDomain:kHttpHost code:code userInfo:@{@"Message":msg}];
            failure(operation,err);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        
        NSLog(@"%@",error);
        NSError *err = [NSError errorWithDomain:kHttpHost code:error.code userInfo:@{@"Message":@"没有网络"}];
        failure(operation,err);
        
    }];
}
-(void)loginWithphone:(NSString *)phone
             password:(NSString *)password
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:phone forKey:@"phone"];
    [parameters setObject:password forKey:@"password"];
    
    parameters = [self paramWithDictionary:parameters];
    
    [_HTTPEngine GET:klogicPathOfLogin parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        int code = [result[@"code"] intValue];
        NSString *msg = result[@"msg"];
        id data = result[@"data"];
        if (code == 0) {
            success(operation,data);
        }else{
            [self tokenExpireWithCode:code];
            NSError *err = [NSError errorWithDomain:kHttpHost code:code userInfo:@{@"Message":msg}];
            failure(operation,err);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        NSLog(@"%@",error);
        
        NSError *err = [NSError errorWithDomain:kHttpHost code:error.code userInfo:@{@"Message":@"没有网络"}];
        failure(operation,err);
    }];
    
    
}

-(void)getTodayOrderWithcourierid:(NSString*)courierid
                             type:(NSInteger)type
                             page:(NSInteger)page
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:courierid forKey:@"courierid"];
//    [parameters setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
//    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
//    
//    parameters = [self paramWithDictionary:parameters];
//    [_HTTPEngine GET:kPathOfToday parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //
//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        int code = [result[@"code"] intValue];
//        NSString *msg = result[@"msg"];
//        id data = result[@"data"];
//        if (code == 0) {
//            success(operation,data);
//        }else{
//            [self tokenExpireWithCode:code];
//            NSError *err = [NSError errorWithDomain:kHttpHost code:code userInfo:@{@"Message":msg}];
//            failure(operation,err);
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //
//        
//        NSLog(@"%@",error);
//        
    //        NSError *err = [NSError errorWithDomain:kHttpHost code:error.code userInfo:@{@"Message":@"没有网络"}];
    //failure(operation,err);
//    }];

}


-(void)confirmOrderWithcourierid:(NSString*)courierid
                         orderid:(NSInteger)orderid
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:courierid forKey:@"courierid"];
//    [parameters setObject:[NSNumber numberWithInteger:orderid] forKey:@"order_id"];
//    parameters = [self paramWithDictionary:parameters];
//    [_HTTPEngine GET:kPathOfConfirm parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //
//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        int code = [result[@"code"] intValue];
//        NSString *msg = result[@"msg"];
//        if (code == 0) {
//            success(operation,result);
//        }else{
//            [self tokenExpireWithCode:code];
//         NSError *err = [NSError errorWithDomain:kHttpHost code:code userInfo:@{@"Message":msg}];
//            failure(operation,err);
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //
//        
//        NSLog(@"%@",error);
//        
    //        NSError *err = [NSError errorWithDomain:kHttpHost code:error.code userInfo:@{@"Message":@"没有网络"}];
    //failure(operation,err);
//    }];
    
}
-(void)finishOrderWithcourierid:(NSString*)courierid
                        orderid:(NSInteger)orderid
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:courierid forKey:@"courierid"];
//    [parameters setObject:[NSNumber numberWithInteger:orderid] forKey:@"order_id"];
//    parameters = [self paramWithDictionary:parameters];
//    [_HTTPEngine GET:kPathOfFinish parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //
//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        int code = [result[@"code"] intValue];
//        NSString *msg = result[@"msg"];
//        if (code == 0) {
//            success(operation,result);
//        }else{
//            [self tokenExpireWithCode:code];
//            NSError *err = [NSError errorWithDomain:kHttpHost code:code userInfo:@{@"Message":msg}];
//            failure(operation,err);
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //
//        
//        NSLog(@"%@",error);
//        
    //        NSError *err = [NSError errorWithDomain:kHttpHost code:error.code userInfo:@{@"Message":@"没有网络"}];
    //failure(operation,err);
//    }];
    
}
-(void)refundOrderWithcourierid:(NSString*)courierid
                        orderid:(NSInteger)orderid
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:courierid forKey:@"courierid"];
//    [parameters setObject:[NSNumber numberWithInteger:orderid] forKey:@"order_id"];
//    parameters = [self paramWithDictionary:parameters];
//    [_HTTPEngine GET:kPathOfRefund parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //
//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        int code = [result[@"code"] intValue];
//        NSString *msg = result[@"msg"];
//        if (code == 0) {
//            success(operation,result);
//        }else{
//            [self tokenExpireWithCode:code];
//            NSError *err = [NSError errorWithDomain:kHttpHost code:code userInfo:@{@"Message":msg}];
//            failure(operation,err);
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //
//        
//        NSLog(@"%@",error);
//        
    //        NSError *err = [NSError errorWithDomain:kHttpHost code:error.code userInfo:@{@"Message":@"没有网络"}];
   // failure(operation,err);
//    }];
    
}
-(void)searchOrderWithcourierid:(NSString*)courierid
                           type:(NSInteger)type
                          phone:(NSString*)phone
                           page:(NSInteger)page
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:courierid forKey:@"courierid"];
    [parameters setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    if (phone) {
        [parameters setObject:phone forKey:@"phone"];
    }
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    parameters = [self paramWithDictionary:parameters];
    [_HTTPEngine GET:klogicPathOfSearch parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        int code = [result[@"code"] intValue];
        NSString *msg = result[@"msg"];
        id data = result[@"data"];
        if (code == 0) {
            success(operation,data);
        }else{
            [self tokenExpireWithCode:code];
            NSError *err = [NSError errorWithDomain:kHttpHost code:code userInfo:@{@"Message":msg}];
            failure(operation,err);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        
        NSLog(@"%@",error);
        
        NSError *err = [NSError errorWithDomain:kHttpHost code:error.code userInfo:@{@"Message":@"没有网络"}];
        failure(operation,err);
    }];
    
}
-(void)allOrderWithcourierid:(NSString*)courierid
                  start_date:(NSString*)start_date
                    end_date:(NSString*)end_date
                        page:(NSInteger)page
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:courierid forKey:@"courierid"];
    if (start_date) {
        [parameters setObject:start_date forKey:@"start_date"];
    }
    if (end_date) {
        [parameters setObject:end_date forKey:@"end_date"];
    }
    
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    parameters = [self paramWithDictionary:parameters];
    [_HTTPEngine GET:klogicPathOfAll parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        int code = [result[@"code"] intValue];
        NSString *msg = result[@"msg"];
        id data = result[@"data"];
        if (code == 0) {
            success(operation,data);
        }else{
            [self tokenExpireWithCode:code];
            NSError *err = [NSError errorWithDomain:kHttpHost code:code userInfo:@{@"Message":msg}];
            failure(operation,err);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        
        NSLog(@"%@",error);
        
        NSError *err = [NSError errorWithDomain:kHttpHost code:error.code userInfo:@{@"Message":@"没有网络"}];
        failure(operation,err);
    }];
    
}
-(void)changeOrderStatusWithcourierid:(NSString*)courierid
                             order_id:(NSInteger)order_id
                                 type:(NSInteger)type
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:courierid forKey:@"courierid"];
    [parameters setObject:[NSNumber numberWithInteger:order_id] forKey:@"order_id"];
    [parameters setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    parameters = [self paramWithDictionary:parameters];
    [_HTTPEngine GET:klogicPathOfStatus parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        int code = [result[@"code"] intValue];
        NSString *msg = result[@"msg"];
        if (code == 0) {
            success(operation,result);
        }else{
            [self tokenExpireWithCode:code];
            NSError *err = [NSError errorWithDomain:kHttpHost code:code userInfo:@{@"Message":msg}];
            failure(operation,err);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        
        NSLog(@"%@",error);
        
        NSError *err = [NSError errorWithDomain:kHttpHost code:error.code userInfo:@{@"Message":@"没有网络"}];
        failure(operation,err);
    }];

}

-(void)tokenExpireWithCode:(long)code{
    if (code == 202) { // 登录失效
        // 清除数据
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@" 登录失效,请重新登录"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
}
@end

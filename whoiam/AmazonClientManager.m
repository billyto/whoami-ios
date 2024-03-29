/*
 * Copyright 2010-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import "AmazonClientManager.h"
#import <AWSRuntime/AWSRuntime.h>

#import "Constants.h"

static AmazonS3Client       *s3  = nil;


@implementation AmazonClientManager


+(AmazonS3Client *)s3
{
    [AmazonClientManager validateCredentials];
    return s3;
}


+(bool)hasCredentials
{
    return (![ACCESS_KEY_ID isEqualToString:@"ENTER_YOUR_ACCESS_KEY"] && ![SECRET_KEY isEqualToString:@"ENTER_YOUR_SECRET_KEY"]);
}

+(void)validateCredentials
{
    if (s3 == nil ) {
        [AmazonClientManager clearCredentials];

        s3  = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        s3.endpoint = [AmazonEndpoints s3Endpoint:US_EAST_1];
        

    }
}

+(void)clearCredentials
{

    s3  = nil;

}


@end

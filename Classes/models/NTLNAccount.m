#import "NTLNAccount.h"
#import "NTLNConfigurationKeys.h"
#import "NTLNHttpClientPool.h"

static NTLNAccount *_instance;

@implementation NTLNAccount

+ (id) instance {
    if (!_instance) {
        return [NTLNAccount newInstance];
    }
    return _instance;
}

+ (id) newInstance {
    if (_instance) {
        [_instance release];
        _instance = nil;
    }
    
    _instance = [[NTLNAccount alloc] init];
    return _instance;
}

- (void) dealloc {
    [super dealloc];
}

- (void)setUsername:(NSString*)username {
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:NTLN_PREFERENCE_USERID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPassword:(NSString*)password {
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:NTLN_PREFERENCE_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUserId:(NSString*)user_id {
    [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:NTLN_PREFERENCE_TWITTER_USERID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*) username {
	return [[NSUserDefaults standardUserDefaults] stringForKey:NTLN_PREFERENCE_USERID];
}

- (NSString*) password {
	return [[NSUserDefaults standardUserDefaults] stringForKey:NTLN_PREFERENCE_PASSWORD];
}

- (NSString*) userId {
	return [[NSUserDefaults standardUserDefaults] stringForKey:NTLN_PREFERENCE_TWITTER_USERID];
}

- (NSString*)footer {
	return [[NSUserDefaults standardUserDefaults] stringForKey:NTLN_PREFERENCE_FOOTER];
}

- (BOOL) valid {
	NSString *pwd = self.password;
	NSString *usn = self.username;
	return usn != nil && usn.length > 0 &&
			pwd != nil && pwd.length > 0;
}

- (void)getUserId {
	
	NTLNTwitterUserClient *c = [[NTLNHttpClientPool sharedInstance] idleClientWithType:NTLNHttpClientPoolClientType_TwitterUserClient];
	c.delegate = self;
	[c getUserInfoForScreenName:[self username]];
}

- (void)twitterUserClientSucceeded:(NTLNTwitterUserClient*)sender {
	if ([sender.users count] > 0) {
		NTLNUser *user = [sender.users objectAtIndex:0];
		[self setUserId:user.user_id];
	}	
}

- (void)twitterUserClientFailed:(NTLNTwitterUserClient*)sender {
}


@end

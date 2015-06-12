#import <objc/runtime.h>

@interface NSDictionary(dictionaryWithObject)

+ (NSDictionary *)dictionaryWithPropertiesOfObject:(id) obj;
/**
 *  把模型对象转换用字典存储
 *
 *  @param obj 对象
 *
 *  @return 字典
 */
+ (NSDictionary *)dictionaryWithPropertiesOfObject_withoutNil:(id) obj;
@end
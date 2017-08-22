/*
 * 调用以下代码获取手机中装的App的所有Share Extension的ServiceType
 
 var composeVc = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
 
 * 我获得的部分数据
 
 com.taobao.taobao4iphone.ShareExtension  淘宝
 com.apple.share.Twitter.post  推特
 com.apple.share.Facebook.post 脸书
 com.apple.share.SinaWeibo.post 新浪微博
 com.apple.share.Flickr.post 雅虎
 com.burbn.instagram.shareextension   instagram
 com.amazon.AmazonCN.AWListShareExtension 亚马逊
 com.apple.share.TencentWeibo.post 腾讯微博
 com.smartisan.notes.SMShare 锤子便签
 com.zhihu.ios.Share 知乎
 com.tencent.mqq.ShareExtension QQ
 com.tencent.xin.sharetimeline 微信
 com.alipay.iphoneclient.ExtensionSchemeShare 支付宝
 com.apple.mobilenotes.SharingExtension  备忘录
 com.apple.reminders.RemindersEditorExtension 提醒事项
 com.apple.Health.HealthShareExtension      健康
 com.apple.mobileslideshow.StreamShareService  iCloud
 */


//预制的分享平台
public let PlatformNameSina:String = "PlatformNameSina"      //新浪微博
public let PlatformNameQQ:String = "PlatformNameQQ"          //QQ
public let PlatformNameEmail:String = "PlatformNameEmail"    //邮箱
public let PlatformNameSms:String = "PlatformNameSms"        //短信
public let PlatformNameWechat:String = "PlatformNameWechat"  //微信
public let PlatformNameAlipay:String = "PlatformNameAlipay"  //支付宝
/******************************待补充、没有图片😂***********************************************/
//public let PlatformNameTwitter:String = "PlatformNameTwitter"      //推特
//public let PlatformNameFacebook:String = "PlatformNameFacebook"    //脸书
//public let PlatformNameInstagram:String = "PlatformNameInstagram"  //instagram
//public let PlatformNameNotes:String = "PlatformNameNotes"          //备忘录
//public let PlatformNameReminders:String = "PlatformNameReminders"  //提醒事项
//public let PlatformNameiCloud:String = "PlatformNameiCloud"        //iCloud


//预制的分享事件
public let PlatformHandleSina:String = "PlatformHandleSina"
public let PlatformHandleQQ:String = "PlatformHandleQQ"
public let PlatformHandleEmail:String = "PlatformHandleEmail"
public let PlatformHandleSms:String = "PlatformHandleSms"
public let PlatformHandleWechat:String = "PlatformHandleWechat"
public let PlatformHandleAlipay:String = "PlatformHandleAlipay"
public let PlatformHandleTwitter:String = "PlatformHandleTwitter"
public let PlatformHandleFacebook:String = "PlatformHandleFacebook"
public let PlatformHandleInstagram:String = "PlatformHandleInstagram"
public let PlatformHandleNotes:String = "PlatformHandleNotes"
public let PlatformHandleReminders:String = "PlatformHandleReminders"
public let PlatformHandleiCloud:String = "PlatformHandleiCloud"
public let PlatformHandleUnknown:String = "PlatformHandleUnknown"






//
//  JCAPPMacroFile.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

// MARK: 通知
// 网络状态通知
public let APPLICATION_NET_CHANGE = "com.jc.notification.name.net.change"

// MARK: H5交互函数：
/// 关闭当前Web
let JC_CloseWebPage: String = "OfExcited"
/// 页面带参数跳转
let JC_PageTransitionNoParams: String = "WavesSeconds"
/// 页面带参数跳转
let JC_PageTransitionWithParams: String = "AcrossOf"
/// 关闭当前页面回到首页
let JC_CloseAndGotoHome: String = "DistinguishesAs"
/// 关闭当前页面回到个人中心
let JC_CloseAndGotoMineCenter: String = "ThisX"
/// 清空页面栈，跳转登录
let JC_CloseAndGotoLoginPage: String = "TheMagnetic"
/// App Store评分
let JC_GotoAppStore: String = "SlightlyStandard"
/// 确认申请埋点
let JC_ConfirmApplyBury: String = "CoilsRadio"
/// 开始绑卡时间
let JC_StartBindingBankCard: String = "ImagingUnit"
/// 结束绑卡时间
let JC_EndBindingBankCard: String = "ForA"

// TODO 替换
let Dynamic_Domain_Name_URL: String = "https://mx01-dc.oss-us-west-1.aliyuncs.com/"
let Dynamic_Domain_Name_Path: String = "access-cash/ac.json"

// MARK: Frame
let ScreenWidth: CGFloat = UIScreen.main.bounds.width
let ScreenHeight: CGFloat = UIScreen.main.bounds.height
let APP_PADDING_UNIT: CGFloat = 4.0

// MARK: Color
let BLUE_COLOR_515FF8: UIColor = UIColor.init(hexString:"#515FF8")!
let BLUE_COLOR_3372F4: UIColor = UIColor.init(hexString:"#3372F4")!
let BLUE_COLOR_2C65FE: UIColor = UIColor.init(hexString:"#2C65FE")!
let BLUE_COLOR_4169F6: UIColor = UIColor.init(hexString:"#4169F6")!
let CYAN_COLOR_56E1FE: UIColor = UIColor.init(hexString:"#56E1FE")!
let GRAY_COLOR_2F3127: UIColor = UIColor.init(hexString:"#2F3127")!
let BLACK_COLOR_2F3127: UIColor = UIColor.init(hexString:"#2F3127")!
let BLACK_COLOR_26264A: UIColor = UIColor.init(hexString:"#26264A")!

// MARK: 原声页面跳转
/// 设置页面
let APP_SETTING_PAGE: String = "jo://yca.sh/signal"
/// 首页
let APP_HOME_PAGE: String = "jo://yca.sh/field"
/// 登录
let APP_LOGIN_PAGE: String = "jo://yca.sh/imaging"
/// 订单
let APP_ORDER_PAGE: String = "jo://yca.sh/auterb"
/// 产品详情
let APP_PRODUCT_DETAIL: String = "jo://yca.sh/orporate"
        
// MARK: 输入类型
enum JCInputViewType: String {
    case Input_Enum = "incidenta"
    case Input_Text = "incidentb"
    case Input_City = "incidentc"
    case Input_Contacts = "incidentd"
}

// MARK: 首页元素
enum JCAPPHomeElementType: String {
    case Banner = "physiciansa"
    case BigCard = "physiciansb"
    case SmallCard = "physiciansc"
    case ProductList = "physiciansd"
}

// MARK: 产品认证项目
enum JCAPPCertificationType: String {
    case Certification_ID_Card = "coherenta"
    case Certification_Personal_Info = "coherentb"
    case Certification_Job_Info = "coherentc"
    case Certification_Contects = "coherentd"
    case Certification_BankCard = "coherente"
}

// MARK: 埋点上报
enum JCRiskControlPointsType: Int {
    case JC_APP_Register = 1
    case JC_APP_IDCardType = 2
    case JC_APP_TakingCardPhoto = 3
    case JC_APP_Face = 4
    case JC_APP_PersonalInfo = 5
    case JC_APP_WorkingInfo = 6
    case JC_APP_Contacts = 7
    case JC_APP_BindingBankCard = 8
    case JC_APP_BeginLoanApply = 9
    case JC_APP_EndLoanApply = 10
}

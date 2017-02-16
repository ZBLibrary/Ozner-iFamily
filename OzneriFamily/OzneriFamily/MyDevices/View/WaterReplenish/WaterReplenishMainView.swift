import UIKit
let kWidthOfWaterReplensh=width_screen/375
let kHightOfWaterReplensh=(height_screen-64)/(667-64)
enum SexType:String{
    case Man="男"
    case WoMan="女"
}
enum BodyParts:String{
    case Face="FaceSkinValue"
    case Eyes="EyesSkinValue"
    case Hands="HandSkinValue"
    case Neck="NeckSkinValue"
}//Face ，Eyes ,Hands, Neck
struct HeadOfWaterReplenishStruct {
    var skinValueOfToday:Double=0
    var lastSkinValue:Double=0
    var averageSkinValue:Double=0
    var checkTimes=0
}
class WaterReplenishMainView: OznerDeviceView,UIAlertViewDelegate {
    //head视图控件
   
    @IBOutlet weak var ClickAlertLabel: UILabel!
    @IBOutlet weak var personBgImgView: UIImageView!
   
    //中部圆形视图
    @IBOutlet weak var centerCircleView: UIView!
    @IBOutlet weak var alertBeforeTest: UILabel!
    @IBOutlet weak var resultValueContainView: UIView!
    @IBOutlet weak var stateOfTestLabel: UILabel!
    @IBOutlet weak var valueOfTestLabel: UILabel!
    @IBOutlet weak var TestingIcon: UIImageView!
    //footer容器里的视图
    @IBOutlet weak var skinButton: UIButton!
    @IBAction func skinButtonClick(_ sender: AnyObject) {
        var skinTypeIndex = 0
        skinTypeIndex = (skinButton.titleLabel?.text!.contains(loadLanguage("油性")))! ? 1:skinTypeIndex
        skinTypeIndex = (skinButton.titleLabel?.text!.contains(loadLanguage("干性")))! ? 2:skinTypeIndex
        skinTypeIndex = (skinButton.titleLabel?.text!.contains(loadLanguage("中性")))! ? 3:skinTypeIndex
        var tmpTimes=0
        if avgAndTimesArr.count>0 {
            tmpTimes=(avgAndTimesArr[0]?.checkTimes)!+(avgAndTimesArr[1]?.checkTimes)!+(avgAndTimesArr[2]?.checkTimes)!+(avgAndTimesArr[3]?.checkTimes)!
        }
        self.delegate.DeviceViewPerformSegue!(SegueID: "showSeeSkin", sender: ["totalTimes":tmpTimes,"currentSkinTypeIndex":skinTypeIndex])
    }
    @IBOutlet weak var resultOfFooterContainView: UIView!
    @IBOutlet weak var resultValueLabel: UILabel!
    @IBOutlet weak var resultStateLabel: UILabel!
   
    @IBAction func toDetailClick(_ sender: AnyObject) {
        self.delegate.DeviceViewPerformSegue!(SegueID: "showSkinDetail", sender: currentBodyPart)
    }
    
    fileprivate let centerOfImg=CGPoint(x: width_screen/2, y: 446*kHightOfWaterReplensh/2)
    //数组以 脸 眼 手 颈 的顺序 半径30范围内
    //*((446*64)/602)
    fileprivate let locationOfImg=[
        SexType.WoMan:[CGPoint(x: 142*kWidthOfWaterReplensh, y: 265*kHightOfWaterReplensh+((446*64)/602)),CGPoint(x: 214*kWidthOfWaterReplensh, y: 243*kHightOfWaterReplensh+((446*64)/602)),CGPoint(x: 142*kWidthOfWaterReplensh, y: 370*kHightOfWaterReplensh+((446*64)/602)),CGPoint(x: 206*kWidthOfWaterReplensh, y: 328*kHightOfWaterReplensh+((446*64)/602))],
        SexType.Man:[CGPoint(x: 142*kWidthOfWaterReplensh, y: 262*kHightOfWaterReplensh+((446*64)/602)),CGPoint(x: 214*kWidthOfWaterReplensh, y: 240*kHightOfWaterReplensh+((446*64)/602)),CGPoint(x: 142*kWidthOfWaterReplensh, y: 370*kHightOfWaterReplensh+((446*64)/602)),CGPoint(x: 206*kWidthOfWaterReplensh, y: 328*kHightOfWaterReplensh+((446*64)/602))]
    ]
    
    func personImgTapClick(_ sender: UITapGestureRecognizer) {
        let touchPoint=sender.location(in: personBgImgView)
        if stateOfView>0//当前页是局部器官图二级界面
        {
            stateOfView=0
        }
        else//当前页是主视图一级界面
        {
            let locaArr=locationOfImg[currentSex]
            switch true
            {
            case isInside(locaArr![0],touchPoint):
                currentBodyPart=BodyParts.Face
                alertBeforeTest.text=loadLanguage("请将补水仪放置脸部")
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![1])
                stateOfView=1
            case isInside(locaArr![1],touchPoint):
                currentBodyPart=BodyParts.Eyes
                alertBeforeTest.text=loadLanguage("请将补水仪放置眼部")
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![2])
                stateOfView=1
            case isInside(locaArr![2],touchPoint):
                currentBodyPart=BodyParts.Hands
                alertBeforeTest.text=loadLanguage("请将补水仪放置手部")
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![3])
                stateOfView=1
            case isInside(locaArr![3],touchPoint):
                currentBodyPart=BodyParts.Neck
                alertBeforeTest.text=loadLanguage("请将补水仪放置颈部")
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![4])
                stateOfView=1
            default:
                print("点击了其它区域")
                break
            }
            
        }
        
        
    }
    //返回是不是在点的30半径范围内
    fileprivate var isInside={ (point1:CGPoint,point2:CGPoint)->Bool in
        
        return pow(point1.x-point2.x, 2)+pow(point1.y-point2.y, 2)<=30*30
    }
    override func draw(_ rect: CGRect) {
        
        centerCircleView.layer.cornerRadius=60.0*width_screen/375.0
        centerCircleView.layer.masksToBounds=true
        
        stateOfView=0
        //图片添加触摸事件
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(personImgTapClick))
        tapGesture.numberOfTapsRequired=1
        tapGesture.numberOfTouchesRequired=1
        personBgImgView.addGestureRecognizer(tapGesture)
        SetWaterReplenishView()
        NotificationCenter.default.addObserver(self, selector: #selector(SexChanged), name: NSNotification.Name(rawValue: "BuShuiYiSexChanged"), object: nil)
    }
    
    //0初始页面,1点击某个部位进入的页面,2检测中,3检测结果出来显示的页面
    fileprivate let color_blue=UIColor(red: 61/255.0, green: 127/255.0, blue: 250/255.0, alpha: 1)
    fileprivate let color_yellow=UIColor(red: 251/255.0, green: 125/255.0, blue: 67/255.0, alpha: 1)
    //当前选中部位
    var currentBodyPart:BodyParts=BodyParts.Face
    fileprivate var stateOfView = -1{
        didSet{
            ClickAlertLabel.isHidden=true
            centerCircleView.isHidden=false
            alertBeforeTest.isHidden=true
            resultValueContainView.isHidden=true
            resultOfFooterContainView.isHidden=false
            skinButton.isHidden=true
            TestingIcon.isHidden=true
            isStopAnimation=true
            runTimeOfAnimations=0.0
            switch stateOfView
            {
            case 0:
                ClickAlertLabel.isHidden=false
                centerCircleView.isHidden=true
                skinButton.isHidden=false
                
                resultOfFooterContainView.isHidden=true
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![0])
                
            case 1:
                alertBeforeTest.isHidden=false
                centerCircleView.backgroundColor=color_blue
                alertBeforeTest.font=UIFont.systemFont(ofSize: 16)
                resultStateLabel.text=""
                
                if avgAndTimesArr.count>0
                {
                    let tmpStruct=avgAndTimesArr[currentBodyPart.hashValue]! as HeadOfWaterReplenishStruct
                    resultValueLabel.text = "\(loadLanguage("上一次检测")) \(Int(tmpStruct.lastSkinValue))%  |  \(loadLanguage("平均值")) \(Int(tmpStruct.averageSkinValue))%（\(tmpStruct.checkTimes)\(loadLanguage("次"))）"
                }
            case 2:
                centerCircleView.backgroundColor=color_blue
                alertBeforeTest.isHidden=false
                TestingIcon.isHidden=false
                alertBeforeTest.text=loadLanguage("检测中")
                alertBeforeTest.font=UIFont.systemFont(ofSize: 20)
                resultStateLabel.text=""
                //检测转圈动画
                isStopAnimation=false
                runTimeOfAnimations=0.0
                startAnimations(0)
                if avgAndTimesArr.count>0
                {
                    let tmpStruct=avgAndTimesArr[currentBodyPart.hashValue]! as HeadOfWaterReplenishStruct
                    resultValueLabel.text = "\(loadLanguage("上一次检测")) \(Int(tmpStruct.lastSkinValue))%  |  \(loadLanguage("平均值")) \(Int(tmpStruct.averageSkinValue))%（\(tmpStruct.checkTimes)\(loadLanguage("次"))）"
                }
            case 3:
                resultValueContainView.isHidden=false
                let testResult=getNeedOilAndWaterValue((self.currentDevice as! WaterReplenishmentMeter).status.oil,moisture: (self.currentDevice as! WaterReplenishmentMeter).status.moisture)
                valueOfTestLabel.text=testResult.moistureValue
                stateOfTestLabel.text=WaterType[testResult.TypeIndex]
                centerCircleView.backgroundColor=ColorType[testResult.TypeIndex]
                resultStateLabel.text=WaterStateArr[currentBodyPart]![testResult.TypeIndex]
                if currentBodyPart==BodyParts.Face {
                    currentSkinTypeIndex=testResult.skinTypeIndex
                }
                uploadSKinData(testResult.oilValue, snumber: testResult.moistureValue)
                
                let tmpTimes=avgAndTimesArr[currentBodyPart.hashValue]?.checkTimes ?? 0
                avgAndTimesArr[currentBodyPart.hashValue]?.checkTimes+=1
                
                avgAndTimesArr[currentBodyPart.hashValue]?.lastSkinValue=Double(testResult.moistureValue as String)!
                var tmpAvg=Double(testResult.moistureValue as String)!
                
                tmpAvg=tmpAvg+(avgAndTimesArr[currentBodyPart.hashValue]?.averageSkinValue ?? 0)!*Double(tmpTimes)
                tmpAvg=tmpAvg/Double(tmpTimes+1)
                avgAndTimesArr[currentBodyPart.hashValue]?.averageSkinValue=Double(String(format: "%.1f",tmpAvg))!
                if avgAndTimesArr.count>0
                {
                    let tmpStruct=avgAndTimesArr[currentBodyPart.hashValue]! as HeadOfWaterReplenishStruct
                    resultValueLabel.text = "\(loadLanguage("上一次检测")) \(Int(tmpStruct.lastSkinValue))%  |  \(loadLanguage("平均值")) \(Int(tmpStruct.averageSkinValue))%（\(tmpStruct.checkTimes)\(loadLanguage("次"))）"
                }
            default:
                break
            }
        }
    }
    
    //水分类型描述
    fileprivate let WaterStateArr=[
        BodyParts.Face:[loadLanguage("脸颊两边皮肤干燥起皮,T区油腻毛孔粗大痘痘横行,脸部亟需补水哦"),loadLanguage("皮肤不油也不干,脸部缺水问题暂时得到缓解"),loadLanguage("脸部细腻红润有光泽,补水到位,面色也不一样哦")],
        BodyParts.Eyes:[loadLanguage("眼部肌肤干燥，易出现皱纹及水肿。此处皮肤一旦松弛较难恢复原状态。补水是延缓衰老的根本保障"),loadLanguage("眼部现在的皮肤水分属于正常水平，但是略显疲惫，请注意保湿！"),loadLanguage("眼部现在的肌肤已经喝饱了水分！要继续保持哦！")],
        BodyParts.Hands:[loadLanguage("手部干燥细纹也跑出来啦,手指的肉刺也变多,需要赶快补充水分哦"),loadLanguage("手部现在的肌肤水份得到补充,果然光滑许多"),loadLanguage("手部润滑有弹性,喝饱水的肌肤果然让人爱不释手呢 ")],
        BodyParts.Neck:[loadLanguage("颈部组织薄弱，油脂分泌少，水分难以保持，皱纹容易产生，补水显得格外重要"),loadLanguage("颈部水份已达标，别让颈纹泄露了你的年龄"),loadLanguage("颈部现在很水润，但不要松懈哦")]
    ]
    
    
    fileprivate let SkinType=[loadLanguage("干性"),loadLanguage("中性"),loadLanguage("油性")]
    fileprivate let WaterType=[loadLanguage("干燥"),loadLanguage("正常"),loadLanguage("水润")]
    fileprivate let ColorType=[UIColor(red: 252/255, green: 128/255, blue: 65/255, alpha: 1),UIColor(red: 64/255, green: 125/255, blue: 250/255, alpha: 1),UIColor(red: 64/255, green: 125/255, blue: 250/255, alpha: 1)]
    
    //water,取值范围
    let WaterTypeValue=[BodyParts.Face:[32,42],
                                    BodyParts.Eyes:[35,45],
                                    BodyParts.Hands:[30,38],
                                    BodyParts.Neck:[35,45]
    ]
    fileprivate func getNeedOilAndWaterValue(_ oil:Float,moisture:Float)->(oilValue:String,moistureValue:String,TypeIndex:Int,skinTypeIndex:Int)
    {
        
        let tmpOil=Int(oil)>=100 ? 99:Int(oil)
        
        let tmpmoisture=Int(moisture)>=100 ? 99:Int(moisture)
        //肤质类型
        var tmpTypeindex=1
        
        if tmpmoisture<WaterTypeValue[currentBodyPart]![0]
        {
            tmpTypeindex=0
        }
        else if tmpmoisture>WaterTypeValue[currentBodyPart]![1]
        {
            tmpTypeindex=2
        }
        var tmpskinTypeIndex=1
        if tmpOil<12
        {
            tmpskinTypeIndex=0
        }
        else if tmpOil>20
        {
            tmpskinTypeIndex=2
        }
        return ("\(tmpOil)","\(tmpmoisture)",tmpTypeindex,tmpskinTypeIndex)
    }
    //private getStateOf
    //检测中动画效果
    fileprivate var isStopAnimation=false
    fileprivate var runTimeOfAnimations:Double=0.0
    fileprivate func startAnimations(_ angle:CGFloat)
    {
        runTimeOfAnimations+=0.1
        let endAngle:CGAffineTransform = CGAffineTransform(rotationAngle: angle*CGFloat(M_PI/180.0))
        UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.TestingIcon.transform = endAngle
            }, completion: {[weak self](finished:Bool) in
                
                if self!.isStopAnimation==false&&self!.runTimeOfAnimations<=10.0
                {
                    self!.startAnimations(angle+30)
                }else
                {
                    if self!.runTimeOfAnimations>=10.0
                    {
                        let alertView=SCLAlertView()
                        _=alertView.showTitle("", subTitle: loadLanguage("您的检测时间未满5秒..."), duration: 2.0, completeText: loadLanguage("完成"), style: SCLAlertViewStyle.notice)
                        self!.stateOfView=1
                        self!.alertBeforeTest.text=loadLanguage("检测失败,请重试")
                    }
                    self!.runTimeOfAnimations=0.0
                    self!.isStopAnimation=true
                    
                }
                
                
            })
    }
    
    fileprivate let personImgArray=[
        SexType.WoMan:["womanOfReplensh1","womanOfReplensh2","womanOfReplensh3","womanOfReplensh4","womanOfReplensh5"],
        SexType.Man:["manOfReplensh1","manOfReplensh2","manOfReplensh3","manOfReplensh4","manOfReplensh5"]
    ]
    
    //当前性别
    fileprivate var currentSex:SexType=SexType.WoMan{
        didSet{
            stateOfView=0
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    //更新性别
    func SexChanged(notice:Notification)
    {
        let sexStr=notice.userInfo?["sex"] as! String
        currentSex = sexStr=="女" ? SexType.WoMan:SexType.Man
    }
    //皮肤检测回掉方法
    func updateViewState()
    {
        switch stateOfView {
        case 1:
            if (self.currentDevice as! WaterReplenishmentMeter).status.testing==true {
                stateOfView=2//检测中
            }
        case 2:
            if (self.currentDevice as! WaterReplenishmentMeter).status.testing==false {
                let weakSelf=self
                if (self.currentDevice as! WaterReplenishmentMeter).status.oil==0 {
                    let alertView=SCLAlertView()
                    _=alertView.showTitle("", subTitle: loadLanguage("您的检测时间未满5秒..."), duration: 2.0, completeText: loadLanguage("完成"), style: SCLAlertViewStyle.notice)
                    weakSelf.stateOfView=1
                    weakSelf.alertBeforeTest.text=loadLanguage("检测失败,请重试")
                }
                else if ((self.currentDevice as! WaterReplenishmentMeter).status.oil < 0)||((self.currentDevice as! WaterReplenishmentMeter).status.moisture < 0){
                    weakSelf.alertBeforeTest.text=loadLanguage("水分太低")
                    weakSelf.stateOfView=1
                }else{
                    stateOfView=3//检测完成
                }
                
            }
        case 3:
            if (self.currentDevice as! WaterReplenishmentMeter).status.testing==true {
                stateOfView=2//检测中
            }
        default:
            return
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    //初始化视图
    func SetWaterReplenishView()
    {
        let sexStr=((self.currentDevice as! WaterReplenishmentMeter).settings.get("sex", default: "女"))! as! String
        currentSex = sexStr=="女" ? SexType.WoMan:SexType.Man
        getAllWeakAndMonthData()
    }
    
    
    
    //上传检测数据
    fileprivate func uploadSKinData(_ ynumber:String,snumber:String)
    {
        User.UpdateBuShuiYiNumber(mac: (self.currentDevice?.identifier)!, ynumber: ynumber, snumber: snumber, action: currentBodyPart.rawValue, success: {
            print("上传检测肤质成功")
            }) { (error) in
                
        }
    }
    fileprivate func removeAdressOfDeviceName(_ tmpName:String)->String
    {
        if tmpName.characters.contains("(")==false
        {
            return tmpName
        }
        else
        {
            let NameStr = tmpName.components(separatedBy: "(") as AnyObject
            return (NameStr.object(at: 0) as! String)
        }
    }
    
    
    var currentSkinTypeIndex:Int = -1//-1暂无，0，1，2，干中油
        {
        didSet{
            if currentSkinTypeIndex>0&&currentSkinTypeIndex<3
            {
                self.skinButton.setTitle("\(loadLanguage("您的肤质"))   "+self.SkinType[currentSkinTypeIndex], for: UIControlState())
                
            }
            
        }
    }
    
    var avgAndTimesArr=[Int:HeadOfWaterReplenishStruct]()
    //下载周月数据
    func getAllWeakAndMonthData()
    {
        User.GetBuShuiFenBu(mac: (self.currentDevice?.identifier)!, action: currentBodyPart.rawValue, success: { (index, AvgAndTimes, _, _) in
             self.avgAndTimesArr=AvgAndTimes
            self.currentSkinTypeIndex=index
            }, failure: { (error) in
            
        })
    }
    
    override func SensorUpdate(device: OznerDevice!) {
        //更新传感器视图
        
    }
    override func StatusUpdate(device: OznerDevice!, status: DeviceViewStatus) {
        //更新连接状态视图
        
//        self.updateViewState()
    }
    
}

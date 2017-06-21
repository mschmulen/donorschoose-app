import Foundation
import UIKit

// MAS TODO FAIcon ? import via Cart ?

public extension UIBarButtonItem {
    
    /**
     To set an icon, use i.e. `barName.FAIcon = FAType.FAGithub`
     */
    func setFAIcon(_ icon: FAType, iconSize: CGFloat) {
        FontLoader.loadFontIfNeeded()
        let font = UIFont(name: FAStruct.FontName, size: iconSize)
        assert(font != nil, FAStruct.ErrorAnnounce)
        setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
        title = icon.text
    }
    
    
    /**
     To set an icon, use i.e. `barName.setFAIcon(FAType.FAGithub, iconSize: 35)`
     */
    var FAIcon: FAType? {
        set {
            FontLoader.loadFontIfNeeded()
            let font = UIFont(name: FAStruct.FontName, size: 23)
            assert(font != nil,FAStruct.ErrorAnnounce)
            setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            title = newValue?.text
        }
        get {
            guard let title = title, let index = FAIcons.index(of: title) else { return nil }
            return FAType(rawValue: index)
        }
    }
    
    
    func setFAText(prefixText: String, icon: FAType?, postfixText: String, size: CGFloat) {
        FontLoader.loadFontIfNeeded()
        let font = UIFont(name: FAStruct.FontName, size: size)
        assert(font != nil, FAStruct.ErrorAnnounce)
        setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
        
        var text = prefixText
        if let iconText = icon?.text {
            text += iconText
        }
        text += postfixText
        title = text
    }
}

public extension UIButton {
    
    /**
     To set an icon, use i.e. `buttonName.setFAIcon(FAType.FAGithub, forState: .Normal)`
     */
    func setFAIcon(_ icon: FAType, forState state: UIControlState) {
        FontLoader.loadFontIfNeeded()
        guard let titleLabel = titleLabel else { return }
        setAttributedTitle(nil, for: state)
        let font = UIFont(name: FAStruct.FontName, size: titleLabel.font.pointSize)
        assert(font != nil, FAStruct.ErrorAnnounce)
        titleLabel.font = font!
        setTitle(icon.text, for: state)
    }
    
    
    /**
     To set an icon, use i.e. `buttonName.setFAIcon(FAType.FAGithub, iconSize: 35, forState: .Normal)`
     */
    func setFAIcon(_ icon: FAType, iconSize: CGFloat, forState state: UIControlState) {
        setFAIcon(icon, forState: state)
        guard let fontName = titleLabel?.font.fontName else { return }
        titleLabel?.font = UIFont(name: fontName, size: iconSize)
    }
    
    
    func setFAText(prefixText: String, icon: FAType?, postfixText: String, size: CGFloat?, forState state: UIControlState, iconSize: CGFloat? = nil) {
        setTitle(nil, for: state)
        FontLoader.loadFontIfNeeded()
        guard let titleLabel = titleLabel else { return }
        let attributedText = attributedTitle(for: UIControlState()) ?? NSAttributedString()
        let  startFont =  attributedText.length == 0 ? nil : attributedText.attribute(NSFontAttributeName, at: 0, effectiveRange: nil) as? UIFont
        let endFont = attributedText.length == 0 ? nil : attributedText.attribute(NSFontAttributeName, at: attributedText.length - 1, effectiveRange: nil) as? UIFont
        var textFont = titleLabel.font
        if let f = startFont , f.fontName != FAStruct.FontName  {
            textFont = f
        } else if let f = endFont , f.fontName != FAStruct.FontName  {
            textFont = f
        }
        let textAttribute = [NSFontAttributeName:textFont]
        let prefixTextAttribured = NSMutableAttributedString(string: prefixText, attributes: textAttribute)
        
        if let iconText = icon?.text {
            let iconFont = UIFont(name: FAStruct.FontName, size: iconSize ?? size ?? titleLabel.font.pointSize)!
            let iconAttribute = [NSFontAttributeName:iconFont]
            
            let iconString = NSAttributedString(string: iconText, attributes: iconAttribute)
            prefixTextAttribured.append(iconString)
        }
        let postfixTextAttributed = NSAttributedString(string: postfixText, attributes: textAttribute)
        prefixTextAttribured.append(postfixTextAttributed)
        
        setAttributedTitle(prefixTextAttribured, for: state)
    }
    
    
    func setFATitleColor(_ color: UIColor, forState state: UIControlState = UIControlState()) {
        FontLoader.loadFontIfNeeded()
 
        let attributedString = NSMutableAttributedString(attributedString: attributedTitle(for: state) ?? NSAttributedString())
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, attributedString.length))
       
        setAttributedTitle(attributedString, for: state)
        setTitleColor(color, for: state)
    }
}


public extension UILabel {
    
    /**
     To set an icon, use i.e. `labelName.FAIcon = FAType.FAGithub`
     */
    var FAIcon: FAType? {
        set {
            guard let newValue = newValue else { return }
                FontLoader.loadFontIfNeeded()
                let fontAwesome = UIFont(name: FAStruct.FontName, size: self.font.pointSize)
                assert(font != nil, FAStruct.ErrorAnnounce)
                font = fontAwesome!
                text = newValue.text
        }
        get {
            guard let text = text, let index = FAIcons.index(of: text) else { return nil }
            return FAType(rawValue: index)
        }
    }
    
    /**
     To set an icon, use i.e. `labelName.setFAIcon(FAType.FAGithub, iconSize: 35)`
     */
    func setFAIcon(_ icon: FAType, iconSize: CGFloat) {
        FAIcon = icon
        font = UIFont(name: font.fontName, size: iconSize)
    }

  func setFAColor(_ color: UIColor) {
        FontLoader.loadFontIfNeeded()
        let attributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString())
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, attributedText!.length))
        textColor = color
    }
    
    
    func setFAText(prefixText: String, icon: FAType?, postfixText: String, size: CGFloat?, iconSize: CGFloat? = nil) {
        text = nil
        FontLoader.loadFontIfNeeded()
        
        let attrText = attributedText ?? NSAttributedString()
        let startFont = attrText.length == 0 ? nil : attrText.attribute(NSFontAttributeName, at: 0, effectiveRange: nil) as? UIFont
        let endFont = attrText.length == 0 ? nil : attrText.attribute(NSFontAttributeName, at: attrText.length - 1, effectiveRange: nil) as? UIFont
        var textFont = font
        if let f = startFont , f.fontName != FAStruct.FontName  {
            textFont = f
        } else if let f = endFont , f.fontName != FAStruct.FontName  {
            textFont = f
        }
        let textAttribute = [NSFontAttributeName : textFont]
        let prefixTextAttribured = NSMutableAttributedString(string: prefixText, attributes: textAttribute)
        
        if let iconText = icon?.text {
            let iconFont = UIFont(name: FAStruct.FontName, size: iconSize ?? size ?? font.pointSize)!
            let iconAttribute = [NSFontAttributeName : iconFont]
            
            let iconString = NSAttributedString(string: iconText, attributes: iconAttribute)
            prefixTextAttribured.append(iconString)
        }
        let postfixTextAttributed = NSAttributedString(string: postfixText, attributes: textAttribute)
        prefixTextAttribured.append(postfixTextAttributed)
        
        attributedText = prefixTextAttribured
    }
    
}


// Original idea from https://github.com/thii/FontAwesome.swift/blob/master/FontAwesome/FontAwesome.swift
public extension UIImageView {
    
    /**
     Create UIImage from FAType
     */
    public func setFAIconWithName(_ icon: FAType, textColor: UIColor, backgroundColor: UIColor = UIColor.clear) {
        FontLoader.loadFontIfNeeded()
        self.image = UIImage(icon: icon, size: frame.size, textColor: textColor, backgroundColor: backgroundColor)
    }
}


public extension UITabBarItem {
    
    public func setFAIcon(_ icon: FAType) {
        FontLoader.loadFontIfNeeded()
        image = UIImage(icon: icon, size: CGSize(width: 30, height: 30))
    }
}


public extension UISegmentedControl {
    
    public func setFAIcon(_ icon: FAType, forSegmentAtIndex segment: Int) {
        FontLoader.loadFontIfNeeded()
        let font = UIFont(name: FAStruct.FontName, size: 23)
        assert(font != nil, FAStruct.ErrorAnnounce)
        setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
        setTitle(icon.text, forSegmentAt: segment)
    }
}


public extension UIImage {
    
    public convenience init(icon: FAType, size: CGSize, textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear) {
        FontLoader.loadFontIfNeeded()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center
        
        let fontAspectRatio: CGFloat = 1.28571429
        let fontSize = min(size.width / fontAspectRatio, size.height)
        let font = UIFont(name: FAStruct.FontName, size: fontSize)
        assert(font != nil, FAStruct.ErrorAnnounce)
        let attributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName: textColor, NSBackgroundColorAttributeName: backgroundColor, NSParagraphStyleAttributeName: paragraph]
        
        let attributedString = NSAttributedString(string: icon.text!, attributes: attributes)
        UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
        attributedString.draw(in: CGRect(x: 0, y: (size.height - fontSize) / 2, width: size.width, height: fontSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = image {
            self.init(cgImage: image.cgImage!, scale: image.scale, orientation: image.imageOrientation)
        } else {
            self.init()
        }
    }
}


public extension UISlider {
    
    func setFAMaximumValueImage(_ icon: FAType, customSize: CGSize? = nil) {
        maximumValueImage = UIImage(icon: icon, size: customSize ?? CGSize(width: 25, height: 25))
    }
    
    
    func setFAMinimumValueImage(_ icon: FAType, customSize: CGSize? = nil) {
        minimumValueImage = UIImage(icon: icon, size: customSize ?? CGSize(width: 25, height: 25))
    }
}


public extension UIViewController {
    var FATitle: FAType? {
        set {
            FontLoader.loadFontIfNeeded()
            let font = UIFont(name: FAStruct.FontName, size: 23)
            assert(font != nil,FAStruct.ErrorAnnounce)
            navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font!]
            title = newValue?.text
        }
        get {
            guard let title = title, let index = FAIcons.index(of: title) else { return nil }
            return FAType(rawValue: index)
        }
    }
}


private struct FAStruct {
    
    static let FontName = "FontAwesome"
    static let ErrorAnnounce = "****** FONT AWESOME SWIFT - FontAwesome font not found in the bundle or not associated with Info.plist when manual installation was performed. ******"
}


private class FontLoader {
    
    private static var __once: () = {
                let bundle = Bundle(for: FontLoader.self)
        
        // MAS TODO Swift 3 , ugly 
        var fontURL:URL?
        
                let identifier = bundle.bundleIdentifier
                
                if identifier?.hasPrefix("org.cocoapods") == true {
                    
                    let bURL = bundle.url(forResource: FAStruct.FontName, withExtension: "ttf", subdirectory: "Font-Awesome-Swift.bundle")!
                    fontURL = bURL
                    //fontURL = bundle.url(forResource: FAStruct.FontName, withExtension: "ttf", subdirectory: "Font-Awesome-Swift.bundle")!
                } else {
                    
                    fontURL = bundle.url(forResource: FAStruct.FontName, withExtension: "ttf")!
                }
        
        // MAS Swift 3 ugly
                let data = try! Data(contentsOf: fontURL!)
        
        // MAS Swift 3 ugly
                let provider = CGDataProvider(data: data as CFData)
                let font = CGFont(provider!)
                
                var error: Unmanaged<CFError>?
                if !CTFontManagerRegisterGraphicsFont(font, &error) {
                    
                    let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
                    let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
                    NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
                }
            }()
    
    struct Static {
        static var onceToken : Int = 0
    }
    
    static func loadFontIfNeeded() {
        if (UIFont.fontNames(forFamilyName: FAStruct.FontName).count == 0) {
            
            _ = FontLoader.__once
        }
    }
}


/**
 List of all icons in Font Awesome
 */
public enum FAType: Int {
    
    static var count: Int {
        
        return FAIcons.count
    }
    
    
    var text: String? {
        
        return FAIcons[rawValue]
    }
    
    case fa500Px, faAdjust, faAdn, faAlignCenter, faAlignJustify, faAlignLeft, faAlignRight, faAmazon, faAmbulance, faAnchor, faAndroid, faAngellist, faAngleDoubleDown, faAngleDoubleLeft, faAngleDoubleRight, faAngleDoubleUp, faAngleDown, faAngleLeft, faAngleRight, faAngleUp, faApple, faArchive, faAreaChart, faArrowCircleDown, faArrowCircleLeft, faArrowCircleODown, faArrowCircleOLeft, faArrowCircleORight, faArrowCircleOUp, faArrowCircleRight, faArrowCircleUp, faArrowDown, faArrowLeft, faArrowRight, faArrowUp, faArrows, faArrowsAlt, faArrowsH, faArrowsV, faAsterisk, faAt, faAutomobile, faBackward, faBalanceScale, faBan, faBank, faBarChart, faBarChartO, faBarcode, faBars, faBattery0, faBattery1, faBattery2, faBattery3, faBattery4, faBatteryEmpty, faBatteryFull, faBatteryHalf, faBatteryQuarter, faBatteryThreeQuarters, faBed, faBeer, faBehance, faBehanceSquare, faBell, faBellO, faBellSlash, faBellSlashO, faBicycle, faBinoculars, faBirthdayCake, faBitbucket, faBitbucketSquare, faBitcoin, faBlackTie, faBold, faBolt, faBomb, faBook, faBookmark, faBookmarkO, faBriefcase, faBtc, faBug, faBuilding, faBuildingO, faBullhorn, faBullseye, faBus, faBuysellads, faCab, faCalculator, faCalendar, faCalendarCheckO, faCalendarMinusO, faCalendarO, faCalendarPlusO, faCalendarTimesO, faCamera, faCameraRetro, faCar, faCaretDown, faCaretLeft, faCaretRight, faCaretSquareODown, faCaretSquareOLeft, faCaretSquareORight, faCaretSquareOUp, faCaretUp, faCartArrowDown, faCartPlus, faCc, faCcAmex, faCcDinersClub, faCcDiscover, faCcJcb, faCcMastercard, faCcPaypal, faCcStripe, faCcVisa, faCertificate, faChain, faChainBroken, faCheck, faCheckCircle, faCheckCircleO, faCheckSquare, faCheckSquareO, faChevronCircleDown, faChevronCircleLeft, faChevronCircleRight, faChevronCircleUp, faChevronDown, faChevronLeft, faChevronRight, faChevronUp, faChild, faChrome, faCircle, faCircleO, faCircleONotch, faCircleThin, faClipboard, faClockO, faClone, faClose, faCloud, faCloudDownload, faCloudUpload, faCny, faCode, faCodeFork, faCodepen, faCoffee, faCog, faCogs, faColumns, faComment, faCommentO, faCommenting, faCommentingO, faComments, faCommentsO, faCompass, faCompress, faConnectdevelop, faContao, faCopy, faCopyright, faCreativeCommons, faCreditCard, faCrop, faCrosshairs, faCss3, faCube, faCubes, faCut, faCutlery, faDashboard, faDashcube, faDatabase, faDedent, faDelicious, faDesktop, faDeviantart, faDiamond, faDigg, faDollar, faDotCircleO, faDownload, faDribbble, faDropbox, faDrupal, faEdit, faEject, faEllipsisH, faEllipsisV, faEmpire, faEnvelope, faEnvelopeO, faEnvelopeSquare, faEraser, faEur, faEuro, faExchange, faExclamation, faExclamationCircle, faExclamationTriangle, faExpand, faExpeditedssl, faExternalLink, faExternalLinkSquare, faEye, faEyeSlash, faEyedropper, faFacebook, faFacebookF, faFacebookOfficial, faFacebookSquare, faFastBackward, faFastForward, faFax, faFeed, faFemale, faFighterJet, faFile, faFileArchiveO, faFileAudioO, faFileCodeO, faFileExcelO, faFileImageO, faFileMovieO, faFileO, faFilePdfO, faFilePhotoO, faFilePictureO, faFilePowerpointO, faFileSoundO, faFileText, faFileTextO, faFileVideoO, faFileWordO, faFileZipO, faFilesO, faFilm, faFilter, faFire, faFireExtinguisher, faFirefox, faFlag, faFlagCheckered, faFlagO, faFlash, faFlask, faFlickr, faFloppyO, faFolder, faFolderO, faFolderOpen, faFolderOpenO, faFont, faFonticons, faForumbee, faForward, faFoursquare, faFrownO, faFutbolO, faGamepad, faGavel, faGbp, faGe, faGear, faGears, faGenderless, faGetPocket, faGg, faGgCircle, faGift, faGit, faGitSquare, faGithub, faGithubAlt, faGithubSquare, faGittip, faGlass, faGlobe, faGoogle, faGooglePlus, faGooglePlusSquare, faGoogleWallet, faGraduationCap, faGratipay, faGroup, fahSquare, faHackerNews, faHandGrabO, faHandLizardO, faHandODown, faHandOLeft, faHandORight, faHandOUp, faHandPaperO, faHandPeaceO, faHandPointerO, faHandRockO, faHandScissorsO, faHandSpockO, faHandStopO, faHddO, faHeader, faHeadphones, faHeart, faHeartO, faHeartbeat, faHistory, faHome, faHospitalO, faHotel, faHourglass, faHourglass1, faHourglass2, faHourglass3, faHourglassEnd, faHourglassHalf, faHourglassO, faHourglassStart, faHouzz, faHtml5, faiCursor, faIls, faImage, faInbox, faIndent, faIndustry, faInfo, faInfoCircle, faInr, faInstagram, faInstitution, faInternetExplorer, faIntersex, faIoxhost, faItalic, faJoomla, faJpy, faJsfiddle, faKey, faKeyboardO, faKrw, faLanguage, faLaptop, faLastfm, faLastfmSquare, faLeaf, faLeanpub, faLegal, faLemonO, faLevelDown, faLevelUp, faLifeBouy, faLifeBuoy, faLifeRing, faLifeSaver, faLightbulbO, faLineChart, faLink, faLinkedin, faLinkedinSquare, faLinux, faList, faListAlt, faListOl, faListUl, faLocationArrow, faLock, faLongArrowDown, faLongArrowLeft, faLongArrowRight, faLongArrowUp, faMagic, faMagnet, faMailForward, faMailReply, faMailReplyAll, faMale, faMap, faMapMarker, faMapO, faMapPin, faMapSigns, faMars, faMarsDouble, faMarsStroke, faMarsStrokeH, faMarsStrokeV, faMaxcdn, faMeanpath, faMedium, faMedkit, faMehO, faMercury, faMicrophone, faMicrophoneSlash, faMinus, faMinusCircle, faMinusSquare, faMinusSquareO, faMobile, faMobilePhone, faMoney, faMoonO, faMortarBoard, faMotorcycle, faMousePointer, faMusic, faNavicon, faNeuter, faNewspaperO, faObjectGroup, faObjectUngroup, faOdnoklassniki, faOdnoklassnikiSquare, faOpencart, faOpenid, faOpera, faOptinMonster, faOutdent, faPagelines, faPaintBrush, faPaperPlane, faPaperPlaneO, faPaperclip, faParagraph, faPaste, faPause, faPaw, faPaypal, faPencil, faPencilSquare, faPencilSquareO, faPhone, faPhoneSquare, faPhoto, faPictureO, faPieChart, faPiedPiper, faPiedPiperAlt, faPinterest, faPinterestP, faPinterestSquare, faPlane, faPlay, faPlayCircle, faPlayCircleO, faPlug, faPlus, faPlusCircle, faPlusSquare, faPlusSquareO, faPowerOff, faPrint, faPuzzlePiece, faQq, faQrcode, faQuestion, faQuestionCircle, faQuoteLeft, faQuoteRight, faRa, faRandom, faRebel, faRecycle, faReddit, faRedditSquare, faRefresh, faRegistered, faRemove, faRenren, faReorder, faRepeat, faReply, faReplyAll, faRetweet, faRmb, faRoad, faRocket, faRotateLeft, faRotateRight, faRouble, faRss, faRssSquare, faRub, faRuble, faRupee, faSafari, faSave, faScissors, faSearch, faSearchMinus, faSearchPlus, faSellsy, faSend, faSendO, faServer, faShare, faShareAlt, faShareAltSquare, faShareSquare, faShareSquareO, faShekel, faSheqel, faShield, faShip, faShirtsinbulk, faShoppingCart, faSignIn, faSignOut, faSignal, faSimplybuilt, faSitemap, faSkyatlas, faSkype, faSlack, faSliders, faSlideshare, faSmileO, faSoccerBallO, faSort, faSortAlphaAsc, faSortAlphaDesc, faSortAmountAsc, faSortAmountDesc, faSortAsc, faSortDesc, faSortDown, faSortNumericAsc, faSortNumericDesc, faSortUp, faSoundcloud, faSpaceShuttle, faSpinner, faSpoon, faSpotify, faSquare, faSquareO, faStackExchange, faStackOverflow, faStar, faStarHalf, faStarHalfEmpty, faStarHalfFull, faStarHalfO, faStarO, faSteam, faSteamSquare, faStepBackward, faStepForward, faStethoscope, faStickyNote, faStickyNoteO, faStop, faStreetView, faStrikethrough, faStumbleupon, faStumbleuponCircle, faSubscript, faSubway, faSuitcase, faSunO, faSuperscript, faSupport, faTable, faTablet, faTachometer, faTag, faTags, faTasks, faTaxi, faTelevision, faTencentWeibo, faTerminal, faTextHeight, faTextWidth, faTh, faThLarge, faThList, faThumbTack, faThumbsDown, faThumbsODown, faThumbsOUp, faThumbsUp, faTicket, faTimes, faTimesCircle, faTimesCircleO, faTint, faToggleDown, faToggleLeft, faToggleOff, faToggleOn, faToggleRight, faToggleUp, faTrademark, faTrain, faTransgender, faTransgenderAlt, faTrash, faTrashO, faTree, faTrello, faTripadvisor, faTrophy, faTruck, faTry, faTty, faTumblr, faTumblrSquare, faTurkishLira, faTv, faTwitch, faTwitter, faTwitterSquare, faUmbrella, faUnderline, faUndo, faUniversity, faUnlink, faUnlock, faUnlockAlt, faUnsorted, faUpload, faUsd, faUser, faUserMd, faUserPlus, faUserSecret, faUserTimes, faUsers, faVenus, faVenusDouble, faVenusMars, faViacoin, faVideoCamera, faVimeo, faVimeoSquare, faVine, faVk, faVolumeDown, faVolumeOff, faVolumeUp, faWarning, faWechat, faWeibo, faWeixin, faWhatsapp, faWheelchair, faWifi, faWikipediaW, faWindows, faWon, faWordpress, faWrench, faXing, faXingSquare, fayCombinator, fayCombinatorSquare, faYahoo, faYc, faYcSquare, faYelp, faYen, faYoutube, faYoutubePlay, faYoutubeSquare
    
}

private let FAIcons = ["\u{f26e}", "\u{f042}", "\u{f170}", "\u{f037}", "\u{f039}", "\u{f036}", "\u{f038}", "\u{f270}", "\u{f0f9}", "\u{f13d}", "\u{f17b}", "\u{f209}", "\u{f103}", "\u{f100}", "\u{f101}", "\u{f102}", "\u{f107}", "\u{f104}", "\u{f105}", "\u{f106}", "\u{f179}", "\u{f187}", "\u{f1fe}", "\u{f0ab}", "\u{f0a8}", "\u{f01a}", "\u{f190}", "\u{f18e}", "\u{f01b}", "\u{f0a9}", "\u{f0aa}", "\u{f063}", "\u{f060}", "\u{f061}", "\u{f062}", "\u{f047}", "\u{f0b2}", "\u{f07e}", "\u{f07d}", "\u{f069}", "\u{f1fa}", "\u{f1b9}", "\u{f04a}", "\u{f24e}", "\u{f05e}", "\u{f19c}", "\u{f080}", "\u{f080}", "\u{f02a}", "\u{f0c9}", "\u{f244}", "\u{f243}", "\u{f242}", "\u{f241}", "\u{f240}", "\u{f244}", "\u{f240}", "\u{f242}", "\u{f243}", "\u{f241}", "\u{f236}", "\u{f0fc}", "\u{f1b4}", "\u{f1b5}", "\u{f0f3}", "\u{f0a2}", "\u{f1f6}", "\u{f1f7}", "\u{f206}", "\u{f1e5}", "\u{f1fd}", "\u{f171}", "\u{f172}", "\u{f15a}", "\u{f27e}", "\u{f032}", "\u{f0e7}", "\u{f1e2}", "\u{f02d}", "\u{f02e}", "\u{f097}", "\u{f0b1}", "\u{f15a}", "\u{f188}", "\u{f1ad}", "\u{f0f7}", "\u{f0a1}", "\u{f140}", "\u{f207}", "\u{f20d}", "\u{f1ba}", "\u{f1ec}", "\u{f073}", "\u{f274}", "\u{f272}", "\u{f133}", "\u{f271}", "\u{f273}", "\u{f030}", "\u{f083}", "\u{f1b9}", "\u{f0d7}", "\u{f0d9}", "\u{f0da}", "\u{f150}", "\u{f191}", "\u{f152}", "\u{f151}", "\u{f0d8}", "\u{f218}", "\u{f217}", "\u{f20a}", "\u{f1f3}", "\u{f24c}", "\u{f1f2}", "\u{f24b}", "\u{f1f1}", "\u{f1f4}", "\u{f1f5}", "\u{f1f0}", "\u{f0a3}", "\u{f0c1}", "\u{f127}", "\u{f00c}", "\u{f058}", "\u{f05d}", "\u{f14a}", "\u{f046}", "\u{f13a}", "\u{f137}", "\u{f138}", "\u{f139}", "\u{f078}", "\u{f053}", "\u{f054}", "\u{f077}", "\u{f1ae}", "\u{f268}", "\u{f111}", "\u{f10c}", "\u{f1ce}", "\u{f1db}", "\u{f0ea}", "\u{f017}", "\u{f24d}", "\u{f00d}", "\u{f0c2}", "\u{f0ed}", "\u{f0ee}", "\u{f157}", "\u{f121}", "\u{f126}", "\u{f1cb}", "\u{f0f4}", "\u{f013}", "\u{f085}", "\u{f0db}", "\u{f075}", "\u{f0e5}", "\u{f27a}", "\u{f27b}", "\u{f086}", "\u{f0e6}", "\u{f14e}", "\u{f066}", "\u{f20e}", "\u{f26d}", "\u{f0c5}", "\u{f1f9}", "\u{f25e}", "\u{f09d}", "\u{f125}", "\u{f05b}", "\u{f13c}", "\u{f1b2}", "\u{f1b3}", "\u{f0c4}", "\u{f0f5}", "\u{f0e4}", "\u{f210}", "\u{f1c0}", "\u{f03b}", "\u{f1a5}", "\u{f108}", "\u{f1bd}", "\u{f219}", "\u{f1a6}", "\u{f155}", "\u{f192}", "\u{f019}", "\u{f17d}", "\u{f16b}", "\u{f1a9}", "\u{f044}", "\u{f052}", "\u{f141}", "\u{f142}", "\u{f1d1}", "\u{f0e0}", "\u{f003}", "\u{f199}", "\u{f12d}", "\u{f153}", "\u{f153}", "\u{f0ec}", "\u{f12a}", "\u{f06a}", "\u{f071}", "\u{f065}", "\u{f23e}", "\u{f08e}", "\u{f14c}", "\u{f06e}", "\u{f070}", "\u{f1fb}", "\u{f09a}", "\u{f09a}", "\u{f230}", "\u{f082}", "\u{f049}", "\u{f050}", "\u{f1ac}", "\u{f09e}", "\u{f182}", "\u{f0fb}", "\u{f15b}", "\u{f1c6}", "\u{f1c7}", "\u{f1c9}", "\u{f1c3}", "\u{f1c5}", "\u{f1c8}", "\u{f016}", "\u{f1c1}", "\u{f1c5}", "\u{f1c5}", "\u{f1c4}", "\u{f1c7}", "\u{f15c}", "\u{f0f6}", "\u{f1c8}", "\u{f1c2}", "\u{f1c6}", "\u{f0c5}", "\u{f008}", "\u{f0b0}", "\u{f06d}", "\u{f134}", "\u{f269}", "\u{f024}", "\u{f11e}", "\u{f11d}", "\u{f0e7}", "\u{f0c3}", "\u{f16e}", "\u{f0c7}", "\u{f07b}", "\u{f114}", "\u{f07c}", "\u{f115}", "\u{f031}", "\u{f280}", "\u{f211}", "\u{f04e}", "\u{f180}", "\u{f119}", "\u{f1e3}", "\u{f11b}", "\u{f0e3}", "\u{f154}", "\u{f1d1}", "\u{f013}", "\u{f085}", "\u{f22d}", "\u{f265}", "\u{f260}", "\u{f261}", "\u{f06b}", "\u{f1d3}", "\u{f1d2}", "\u{f09b}", "\u{f113}", "\u{f092}", "\u{f184}", "\u{f000}", "\u{f0ac}", "\u{f1a0}", "\u{f0d5}", "\u{f0d4}", "\u{f1ee}", "\u{f19d}", "\u{f184}", "\u{f0c0}", "\u{f0fd}", "\u{f1d4}", "\u{f255}", "\u{f258}", "\u{f0a7}", "\u{f0a5}", "\u{f0a4}", "\u{f0a6}", "\u{f256}", "\u{f25b}", "\u{f25a}", "\u{f255}", "\u{f257}", "\u{f259}", "\u{f256}", "\u{f0a0}", "\u{f1dc}", "\u{f025}", "\u{f004}", "\u{f08a}", "\u{f21e}", "\u{f1da}", "\u{f015}", "\u{f0f8}", "\u{f236}", "\u{f254}", "\u{f251}", "\u{f252}", "\u{f253}", "\u{f253}", "\u{f252}", "\u{f250}", "\u{f251}", "\u{f27c}", "\u{f13b}", "\u{f246}", "\u{f20b}", "\u{f03e}", "\u{f01c}", "\u{f03c}", "\u{f275}", "\u{f129}", "\u{f05a}", "\u{f156}", "\u{f16d}", "\u{f19c}", "\u{f26b}", "\u{f224}", "\u{f208}", "\u{f033}", "\u{f1aa}", "\u{f157}", "\u{f1cc}", "\u{f084}", "\u{f11c}", "\u{f159}", "\u{f1ab}", "\u{f109}", "\u{f202}", "\u{f203}", "\u{f06c}", "\u{f212}", "\u{f0e3}", "\u{f094}", "\u{f149}", "\u{f148}", "\u{f1cd}", "\u{f1cd}", "\u{f1cd}", "\u{f1cd}", "\u{f0eb}", "\u{f201}", "\u{f0c1}", "\u{f0e1}", "\u{f08c}", "\u{f17c}", "\u{f03a}", "\u{f022}", "\u{f0cb}", "\u{f0ca}", "\u{f124}", "\u{f023}", "\u{f175}", "\u{f177}", "\u{f178}", "\u{f176}", "\u{f0d0}", "\u{f076}", "\u{f064}", "\u{f112}", "\u{f122}", "\u{f183}", "\u{f279}", "\u{f041}", "\u{f278}", "\u{f276}", "\u{f277}", "\u{f222}", "\u{f227}", "\u{f229}", "\u{f22b}", "\u{f22a}", "\u{f136}", "\u{f20c}", "\u{f23a}", "\u{f0fa}", "\u{f11a}", "\u{f223}", "\u{f130}", "\u{f131}", "\u{f068}", "\u{f056}", "\u{f146}", "\u{f147}", "\u{f10b}", "\u{f10b}", "\u{f0d6}", "\u{f186}", "\u{f19d}", "\u{f21c}", "\u{f245}", "\u{f001}", "\u{f0c9}", "\u{f22c}", "\u{f1ea}", "\u{f247}", "\u{f248}", "\u{f263}", "\u{f264}", "\u{f23d}", "\u{f19b}", "\u{f26a}", "\u{f23c}", "\u{f03b}", "\u{f18c}", "\u{f1fc}", "\u{f1d8}", "\u{f1d9}", "\u{f0c6}", "\u{f1dd}", "\u{f0ea}", "\u{f04c}", "\u{f1b0}", "\u{f1ed}", "\u{f040}", "\u{f14b}", "\u{f044}", "\u{f095}", "\u{f098}", "\u{f03e}", "\u{f03e}", "\u{f200}", "\u{f1a7}", "\u{f1a8}", "\u{f0d2}", "\u{f231}", "\u{f0d3}", "\u{f072}", "\u{f04b}", "\u{f144}", "\u{f01d}", "\u{f1e6}", "\u{f067}", "\u{f055}", "\u{f0fe}", "\u{f196}", "\u{f011}", "\u{f02f}", "\u{f12e}", "\u{f1d6}", "\u{f029}", "\u{f128}", "\u{f059}", "\u{f10d}", "\u{f10e}", "\u{f1d0}", "\u{f074}", "\u{f1d0}", "\u{f1b8}", "\u{f1a1}", "\u{f1a2}", "\u{f021}", "\u{f25d}", "\u{f00d}", "\u{f18b}", "\u{f0c9}", "\u{f01e}", "\u{f112}", "\u{f122}", "\u{f079}", "\u{f157}", "\u{f018}", "\u{f135}", "\u{f0e2}", "\u{f01e}", "\u{f158}", "\u{f09e}", "\u{f143}", "\u{f158}", "\u{f158}", "\u{f156}", "\u{f267}", "\u{f0c7}", "\u{f0c4}", "\u{f002}", "\u{f010}", "\u{f00e}", "\u{f213}", "\u{f1d8}", "\u{f1d9}", "\u{f233}", "\u{f064}", "\u{f1e0}", "\u{f1e1}", "\u{f14d}", "\u{f045}", "\u{f20b}", "\u{f20b}", "\u{f132}", "\u{f21a}", "\u{f214}", "\u{f07a}", "\u{f090}", "\u{f08b}", "\u{f012}", "\u{f215}", "\u{f0e8}", "\u{f216}", "\u{f17e}", "\u{f198}", "\u{f1de}", "\u{f1e7}", "\u{f118}", "\u{f1e3}", "\u{f0dc}", "\u{f15d}", "\u{f15e}", "\u{f160}", "\u{f161}", "\u{f0de}", "\u{f0dd}", "\u{f0dd}", "\u{f162}", "\u{f163}", "\u{f0de}", "\u{f1be}", "\u{f197}", "\u{f110}", "\u{f1b1}", "\u{f1bc}", "\u{f0c8}", "\u{f096}", "\u{f18d}", "\u{f16c}", "\u{f005}", "\u{f089}", "\u{f123}", "\u{f123}", "\u{f123}", "\u{f006}", "\u{f1b6}", "\u{f1b7}", "\u{f048}", "\u{f051}", "\u{f0f1}", "\u{f249}", "\u{f24a}", "\u{f04d}", "\u{f21d}", "\u{f0cc}", "\u{f1a4}", "\u{f1a3}", "\u{f12c}", "\u{f239}", "\u{f0f2}", "\u{f185}", "\u{f12b}", "\u{f1cd}", "\u{f0ce}", "\u{f10a}", "\u{f0e4}", "\u{f02b}", "\u{f02c}", "\u{f0ae}", "\u{f1ba}", "\u{f26c}", "\u{f1d5}", "\u{f120}", "\u{f034}", "\u{f035}", "\u{f00a}", "\u{f009}", "\u{f00b}", "\u{f08d}", "\u{f165}", "\u{f088}", "\u{f087}", "\u{f164}", "\u{f145}", "\u{f00d}", "\u{f057}", "\u{f05c}", "\u{f043}", "\u{f150}", "\u{f191}", "\u{f204}", "\u{f205}", "\u{f152}", "\u{f151}", "\u{f25c}", "\u{f238}", "\u{f224}", "\u{f225}", "\u{f1f8}", "\u{f014}", "\u{f1bb}", "\u{f181}", "\u{f262}", "\u{f091}", "\u{f0d1}", "\u{f195}", "\u{f1e4}", "\u{f173}", "\u{f174}", "\u{f195}", "\u{f26c}", "\u{f1e8}", "\u{f099}", "\u{f081}", "\u{f0e9}", "\u{f0cd}", "\u{f0e2}", "\u{f19c}", "\u{f127}", "\u{f09c}", "\u{f13e}", "\u{f0dc}", "\u{f093}", "\u{f155}", "\u{f007}", "\u{f0f0}", "\u{f234}", "\u{f21b}", "\u{f235}", "\u{f0c0}", "\u{f221}", "\u{f226}", "\u{f228}", "\u{f237}", "\u{f03d}", "\u{f27d}", "\u{f194}", "\u{f1ca}", "\u{f189}", "\u{f027}", "\u{f026}", "\u{f028}", "\u{f071}", "\u{f1d7}", "\u{f18a}", "\u{f1d7}", "\u{f232}", "\u{f193}", "\u{f1eb}", "\u{f266}", "\u{f17a}", "\u{f159}", "\u{f19a}", "\u{f0ad}", "\u{f168}", "\u{f169}", "\u{f23b}", "\u{f1d4}", "\u{f19e}", "\u{f23b}", "\u{f1d4}", "\u{f1e9}", "\u{f157}", "\u{f167}", "\u{f16a}", "\u{f166}"]

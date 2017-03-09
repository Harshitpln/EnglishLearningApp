import AVFoundation
import MediaPlayer

public protocol LetsPlayerViewDelegate {
    func playerDidPause()
    func playerDidResume()
    func playerDidEndPlaying()
    func playerWillEnterFullscreen()
    func playerDidEnterFullscreen()
    func playerWillLeaveFullscreen()
    func playerDidLeaveFullscreen()
    func playerFailedToPlayToEnd()
    func playerStalled()
}
open class LetsSlider : UISlider {
    open var progressView = UIProgressView()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        self.maximumTrackTintColor = UIColor.clear
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 1.0
        progressView.tintColor = UIColor.darkGray
        self.addSubview(progressView)
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[PV]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["PV": progressView])
        addConstraints(constraints)
        constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(20)-[PV]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["PV": progressView])
        self.addConstraints(constraints)
    }
    
    open func setSecondaryValue(_ value: Float) {
        progressView.progress = value
    }
    
    open func setSecondaryTintColor(_ tintColor: UIColor) {
        progressView.tintColor = tintColor
    }
}

open class LetsPlayerView : UIView {
    
    open var asset: AVAsset?
    open var playerItem: AVPlayerItem?
    open var controllersView = UIView()
    open var controllersTimer : Timer?
    open var progressTimer : Timer?
    open var controllersTimeoutPeriod : Int = 3
    open var activityIndicator = UIActivityIndicatorView()
    
    open var playButton = UIButton(type: .custom)
    open var fullscreenButton = UIButton(type: .custom)
    open var volumeView = MPVolumeView()
    open var progressIndicator = LetsSlider()
    open var currentTimeLabel = UILabel()
    open var remainingTimeLabel = UILabel()
    open var liveLabel = UILabel()
    open var spacerView = UIView()
    open var airPlayLabel = UILabel()
    open var seeking: Bool = false
    open var fullscreen: Bool = false
    open var defaultFrame: CGRect = CGRect.zero
    
    open var videoURL : URL?
    open var delegate : LetsPlayerViewDelegate?
    
    open var player : AVPlayer?
    open var playerLayer : AVPlayerLayer?
    open var currentItem : AVPlayerItem?
    
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        defaultFrame = frame
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    open func setup() {
        // Set up notification observers
        NotificationCenter.default.addObserver(self, selector: "playerDidFinishPlaying:", name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: "playerFailedToPlayToEnd:", name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: "playerStalled:", name: NSNotification.Name.AVPlayerItemPlaybackStalled, object: nil)
        NotificationCenter.default.addObserver(self, selector: "airPlayAvailabilityChanged:", name: NSNotification.Name.MPVolumeViewWirelessRoutesAvailableDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: "airPlayActivityChanged:", name: NSNotification.Name.MPVolumeViewWirelessRouteActiveDidChange, object: nil)
        self.backgroundColor = UIColor.black
        
        /** Container View **************************************************************************************************/
        controllersView = UIView()
        controllersView.translatesAutoresizingMaskIntoConstraints = false
        controllersView.backgroundColor = UIColor(white: 0.0, alpha: 0.45)
        self.addSubview(controllersView)
        var horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[CV]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["CV": controllersView])
        var verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[CV(40)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["CV": controllersView])
        self.addConstraints(horizontalConstraints)
        self.addConstraints(verticalConstraints)
        /** AirPlay View ****************************************************************************************************/
        
        airPlayLabel.translatesAutoresizingMaskIntoConstraints = false
        airPlayLabel.text = "AirPlay is enabled"
        airPlayLabel.textColor = UIColor.lightGray
        airPlayLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13.0)
        airPlayLabel.textAlignment = .center
        airPlayLabel.numberOfLines = 0
        airPlayLabel.isHidden = true
        self.addSubview(airPlayLabel)
        horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[AP]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["AP": airPlayLabel])
        verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[AP]-40-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["AP": airPlayLabel])
        self.addConstraints(horizontalConstraints)
        self.addConstraints(verticalConstraints)
        /** UI Controllers **************************************************************************************************/
        
        let bundle : Bundle = Bundle(for: LetsPlayerView.self)
        let url: URL = (bundle.url(forResource: "LetsPod", withExtension: "bundle")! as NSURL) as URL
        let imageBundle: Bundle = Bundle(url: url as URL)!
        let playImage: UIImage = UIImage(contentsOfFile: imageBundle.path(forResource: "play", ofType: "png")!)!
        let pauseImage: UIImage = UIImage(contentsOfFile: imageBundle.path(forResource: "pause", ofType: "png")!)!
        let expandImage: UIImage = UIImage(contentsOfFile: imageBundle.path(forResource: "expand", ofType: "png")!)!
        let shrinkImage: UIImage = UIImage(contentsOfFile: imageBundle.path(forResource: "shrink", ofType: "png")!)!
        
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setImage(playImage, for: .normal)
        playButton.setImage(pauseImage, for: .selected)
        
        volumeView.translatesAutoresizingMaskIntoConstraints = false
        volumeView.showsRouteButton = true
        volumeView.showsVolumeSlider = false
        volumeView.autoresizingMask = .flexibleWidth
        
        fullscreenButton.translatesAutoresizingMaskIntoConstraints = false
        fullscreenButton.setImage(expandImage, for: .normal)
        fullscreenButton.setImage(shrinkImage, for: .selected)
        
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13.0)
        currentTimeLabel.textAlignment = .center
        currentTimeLabel.textColor = UIColor.white
        
        remainingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingTimeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13.0)
        remainingTimeLabel.textAlignment = .center
        remainingTimeLabel.textColor = UIColor.white
        
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.isContinuous = true
        
        liveLabel.translatesAutoresizingMaskIntoConstraints = false
        liveLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13.0)
        liveLabel.textAlignment = .center
        liveLabel.textColor = UIColor.white
        liveLabel.text = "Live"
        liveLabel.isHidden = true
        
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        controllersView.addSubview(playButton)
        controllersView.addSubview(fullscreenButton)
        controllersView.addSubview(volumeView)
        controllersView.addSubview(currentTimeLabel)
        controllersView.addSubview(progressIndicator)
        controllersView.addSubview(remainingTimeLabel)
        controllersView.addSubview(liveLabel)
        controllersView.addSubview(spacerView)
        horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[P(40)][S(10)][C]-5-[I]-5-[R][F(40)][V(40)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["P": playButton, "S": spacerView, "C": currentTimeLabel, "I": progressIndicator, "R": remainingTimeLabel, "V": volumeView, "F": fullscreenButton])
        controllersView.addConstraints(horizontalConstraints)
        volumeView.hideByWidth(true)
        spacerView.hideByWidth(true)
        horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[L]-5-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["L": liveLabel])
        controllersView.addConstraints(horizontalConstraints)
        for view: UIView in controllersView.subviews {
            verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[V(40)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: ["V": view])
            controllersView.addConstraints(verticalConstraints)
        }
        /** Loading Indicator ***********************************************************************************************/
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.stopAnimating()
        var frame: CGRect = self.frame
        frame.origin = CGPoint.zero
        activityIndicator.frame = frame
        self.addSubview(activityIndicator)
        /** Actions Setup ***************************************************************************************************/
        playButton.addTarget(self, action: #selector(LetsPlayerView.togglePlay(_:)), for: .touchUpInside)
        fullscreenButton.addTarget(self, action: #selector(LetsPlayerView.toggleFullscreen(_:)), for: .touchUpInside)
        progressIndicator.addTarget(self, action: #selector(LetsPlayerView.seek(_:)), for: .valueChanged)
        progressIndicator.addTarget(self, action: #selector(LetsPlayerView.pauseRefreshing), for: .touchDown)
        progressIndicator.addTarget(self, action: #selector(LetsPlayerView.resumeRefreshing), for: [.touchUpInside, .touchUpOutside])
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LetsPlayerView.showControllers)))
        self.showControllers()
        controllersTimeoutPeriod = 3
    }
    override open var tintColor: UIColor! {
        didSet {
            progressIndicator.tintColor = self.tintColor
        }
    }
    
    open func setBufferTintColor(_ tintColor: UIColor) {
        progressIndicator.setSecondaryTintColor(tintColor)
    }
    
    open func setLiveStreamText(_ text: String) {
        liveLabel.text = text
    }
    
    open func setAirPlayText(_ text: String) {
        airPlayLabel.text = text
    }
    
    open func togglePlay(_ button: UIButton) {
        if button.isSelected {
            button.isSelected = false
            player?.pause()
            delegate?.playerDidPause()
        }
        else {
            button.isSelected = true
            self.play()
            delegate?.playerDidResume()
        }
        self.showControllers()
    }
    open func toggleFullscreen(_ button: UIButton) {
        if fullscreen {
            delegate?.playerWillLeaveFullscreen()
            UIApplication.shared.setStatusBarHidden(false, with: .fade)
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                self.transform = CGAffineTransform(rotationAngle: 0)
                self.frame = self.defaultFrame
                var frame: CGRect = self.defaultFrame
                frame.origin = CGPoint.zero
                self.playerLayer?.frame = frame
                self.activityIndicator.frame = frame
                }, completion: {(finished: Bool) -> Void in
                    self.fullscreen = false
                    self.delegate?.playerDidLeaveFullscreen()
                    self.layoutIfNeeded()
            })
            button.isSelected = false
        }
        else {
            let orientation = UIApplication.shared.statusBarOrientation
            var width: CGFloat = UIScreen.main.bounds.size.width
            var height: CGFloat = UIScreen.main.bounds.size.height
            var frame: CGRect
            if orientation == .portrait {
                let aux = width
                width = height
                height = aux
                frame = CGRect(x: (height - width) / 2,y: (width - height) / 2,width: width,height: height);
            }
            else {
                frame = CGRect(x: 0,y: 0,width: width,height: height)
            }
            
            delegate?.playerWillEnterFullscreen()
            UIApplication.shared.setStatusBarHidden(true, with: .fade)
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                self.frame = frame
                self.playerLayer!.frame = CGRect(x: 0,y: 0,width: width,height: height)
                self.activityIndicator.frame = CGRect(x: 0,y: 0,width: width,height: height)
                if orientation == .portrait {
                    self.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
                    self.activityIndicator.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
                }
                }, completion: {(finished: Bool) -> Void in
                    self.fullscreen = true
                    self.delegate?.playerDidEnterFullscreen()
                    self.layoutIfNeeded()
            })
            button.isSelected = true
        }
        self.showControllers()
    }
    
    open func seek(_ slider: UISlider) {
        let timescale: Int = Int(currentItem!.asset.duration.timescale)
        let time: Float = slider.value * (Float(currentItem!.asset.duration.value) / Float(timescale))
        player!.seek(to: CMTimeMakeWithSeconds(Double(time), Int32(timescale)))
        self.showControllers()
    }
    
    open func pauseRefreshing() {
        seeking = true
    }
    
    open func resumeRefreshing() {
        seeking = false
    }
    
    open func availableDuration() -> TimeInterval {
        var result: TimeInterval = 0
        var loadedTimeRanges: [AnyObject] = player!.currentItem!.loadedTimeRanges
        if loadedTimeRanges.count > 0 {
            let timeRange: CMTimeRange = loadedTimeRanges[0].timeRangeValue
            let startSeconds: Float64 = CMTimeGetSeconds(timeRange.start)
            let durationSeconds: Float64 = CMTimeGetSeconds(timeRange.duration)
            result = startSeconds + durationSeconds
        }
        return result
    }
    
    open func refreshProgressIndicator() {
        let duration : Float = Float(CMTimeGetSeconds(currentItem!.asset.duration)) ?? 0
        if duration == 0 {
            // Video is a live stream
            currentTimeLabel.text = nil
            remainingTimeLabel.text = nil
            progressIndicator.isHidden = true
            liveLabel.isHidden = false
        }
        else {
            let current = seeking ? Float(progressIndicator.value) * Float(duration) : Float(CMTimeGetSeconds(player!.currentTime()))
            // Otherwise, use the actual video position
            progressIndicator.value = Float(current) / Float(duration)
            progressIndicator.setSecondaryValue((Float(self.availableDuration()) / duration))
            // Set time labels
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = (duration >= 3600 ? "hh:mm:ss" : "mm:ss")
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            let currentTime: Date = Date(timeIntervalSince1970: Double(current))
            let remainingTime: Date = Date(timeIntervalSince1970: Double(duration - current))
            currentTimeLabel.text = formatter.string(from: currentTime as Date)
            remainingTimeLabel.text = "-\(formatter.string(from: remainingTime as Date))"
            progressIndicator.isHidden = false
            liveLabel.isHidden = true
        }
    }
    
    open func showControllers() {
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.controllersView.alpha = 1.0
            }, completion: {(finished: Bool) -> Void in
                self.controllersTimer?.invalidate()
                if self.controllersTimeoutPeriod > 0 {
                    self.controllersTimer = Timer.scheduledTimer(timeInterval: Double(self.controllersTimeoutPeriod), target: self, selector: #selector(LetsPlayerView.hideControllers), userInfo: nil, repeats: false)
                }
        })
    }
    
    open func hideControllers() {
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.controllersView.alpha = 0.0
        })
    }
    
    open func prepareAndPlayAutomatically(_ playAutomatically: Bool) {
        if player != nil {
            self.stop()
        }
        layoutIfNeeded()
        player = AVPlayer()
        let asset: AVURLAsset = AVURLAsset(url: videoURL! as URL, options: nil)
        let keys = ["playable"]
        weak var weakSelf = self
        asset.loadValuesAsynchronously(forKeys: keys, completionHandler: {() -> Void in
            weakSelf!.currentItem = AVPlayerItem(asset: asset)
            weakSelf!.player!.replaceCurrentItem(with: weakSelf!.currentItem)
            if playAutomatically {
                DispatchQueue.main.sync(execute: {() -> Void in
                    weakSelf?.play()
                })
            }
        })
        player?.allowsExternalPlayback = true
        playerLayer = AVPlayerLayer(player: player)
        self.layer.addSublayer(playerLayer!)
        defaultFrame = self.frame
        var frame: CGRect = self.frame
        frame.origin = CGPoint.zero
        playerLayer?.frame = frame
        self.bringSubview(toFront: controllersView)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
        }
        catch {
            
        }
        
        player?.addObserver(self, forKeyPath: "rate", options: [], context: nil)
        currentItem?.addObserver(self, forKeyPath: "status", options: [], context: nil)
        player?.seek(to: kCMTimeZero)
        player?.rate = 0.0
        playButton.isSelected = true
        if playAutomatically {
            activityIndicator.startAnimating()
        }
    }
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        defaultFrame = self.frame
//        var frame: CGRect = self.frame
//        frame.origin = CGPoint.zero
//        playerLayer?.frame = frame
//        activityIndicator.frame = frame
//    }
    open func clean() {
        progressTimer?.invalidate()
        progressTimer = nil
        controllersTimer?.invalidate()
        controllersTimer = nil
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemPlaybackStalled, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.MPVolumeViewWirelessRoutesAvailableDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.MPVolumeViewWirelessRouteActiveDidChange, object: nil)
        player?.allowsExternalPlayback = false
        self.stop()
        player?.removeObserver(self, forKeyPath: "rate")
        self.player = nil
        self.playerLayer?.removeFromSuperlayer()
        self.playerLayer = nil
        self.removeFromSuperview()
    }
    
    public func play() {
        player?.play()
        playButton.isSelected = true
        progressTimer = Timer.scheduledTimer(timeInterval: Double(0.1), target: self, selector: #selector(LetsPlayerView.refreshProgressIndicator), userInfo: nil, repeats: true)
    }
    
    public func pause() {
        player?.pause()
        playButton.isSelected = false
        delegate?.playerDidPause()
    }
    
    public func stop() {
        if player != nil {
            player?.pause()
            player?.seek(to: kCMTimeZero)
            playButton.isSelected = false
        }
    }
    
    public func isPlaying() -> Bool {
        return player?.rate ?? 0 > Float(0.0)
    }
    
    public func playerDidFinishPlaying(notification: NSNotification) {
        self.stop()
        if fullscreen {
            self.toggleFullscreen(fullscreenButton)
        }
        delegate?.playerDidEndPlaying()
    }
    
    public func playerFailedToPlayToEnd(notification: NSNotification) {
        self.stop()
        delegate?.playerFailedToPlayToEnd()
    }
    
    public func playerStalled(notification: NSNotification) {
        self.togglePlay(playButton)
        delegate?.playerStalled()
    }
    
    public func airPlayAvailabilityChanged(notification: NSNotification) {
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            if self.volumeView.areWirelessRoutesAvailable {
                self.volumeView.hideByWidth(false)
            }
            else if !self.volumeView.isWirelessRouteActive {
               self.volumeView.hideByWidth(true)
            }
            
            self.layoutIfNeeded()
        })
    }
    
    public func airPlayActivityChanged(notification: NSNotification) {
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            if self.volumeView.isWirelessRouteActive {
                if self.fullscreen {
                    self.toggleFullscreen(self.fullscreenButton)
                }
                self.playButton.hideByWidth(true)
                self.fullscreenButton.hideByWidth(true)
                self.spacerView.hideByWidth(false)
                self.airPlayLabel.isHidden = false
                self.controllersTimeoutPeriod = 0
                self.showControllers()
            }
            else {
                self.playButton.hideByWidth(false)
                self.fullscreenButton.hideByWidth(false)
                self.spacerView.hideByWidth(true)
                self.airPlayLabel.isHidden = true
                self.controllersTimeoutPeriod = 3
                self.showControllers()
            }
            self.layoutIfNeeded()
        })
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "status") {
            if currentItem!.status == .failed {
                delegate?.playerFailedToPlayToEnd()
            }
        }
        if (keyPath == "rate") {
            let rate: Float = player!.rate
            if rate > 0 {
                activityIndicator.stopAnimating()
            }
        }
    }
}

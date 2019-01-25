import UIKit

class ZoomableImageView: UIScrollView {
    
    private struct Constants {
        static let minimumZoomScale: CGFloat = 0.5;
        static let maximumZoomScale: CGFloat = 6.0;
        
        // the ratio of the content (e..g face) taken inside the entire view
        static let contentSpanRatio: CGFloat = 0.8
    }
    
    
    // public so that delegate can access
    public let imageView = UIImageView()
    
    
    // zoom to rect with specified ratio
    public func zoom(to rect: CGRect, with ratio: CGFloat, animated: Bool) {
        
        let oldWidth = rect.width
        let oldHeight = rect.height
        
        let oldCenter = rect.origin.applying(CGAffineTransform(translationX: oldWidth / 2.0, y: oldHeight / 2.0))
        
        
        // gw: note, the ratio is percentation of content span that should show up in frame, so if ratio is 0.8, your newRect should be larger ( * 1/0.8) to zoom to
        
        let newWidth = rect.width / ratio
        let newHeight = rect.height / ratio
        
        
        
        let newOrigin = CGPoint(x: oldCenter.x - newWidth / 2.0,
                                y: oldCenter.y - newHeight / 2.0)
        
        let newRect = CGRect(x: newOrigin.x, y: newOrigin.y, width: newWidth, height: newHeight)
        
        
        zoom(to: newRect, animated: animated)
    }
    
   // fit image to frame
    public func fitImage() {
        guard let image = self.imageView.image else {return}
        let scaleFitZoomScale: CGFloat = min(
            self.frame.width / image.size.width ,
            self.frame.height / image.size.height
        )
        
        
        // reset scale and offset on each resetting of image
        self.zoomScale = scaleFitZoomScale
    }
    
     // gw: must be called to complete a setting
    public func setImage(image: UIImage) {
        imageView.image = image
        
        // gw: don't use bounds here.
        // TODO: think about why
        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        self.contentSize = image.size
        
        
        fitImage()

        
    }
    
    
    // MARK - constructor
    init() {
        // gw: there is no super.init(), you have to use this constructor as hack
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) // gw: relies on autolayout constraint later
        
        minimumZoomScale = Constants.minimumZoomScale
        maximumZoomScale = Constants.maximumZoomScale
        
        
        addSubview(imageView)
        
        // use auto layout
        
        //setupLayout()
        
        self.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    func setupLayoutConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false


        let img_lead = imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        img_lead.identifier = "img_lead"

        let img_trail = imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        img_trail.identifier = "img_trail"

        let img_top = imageView.topAnchor.constraint(equalTo: self.topAnchor)
        img_top.identifier = "img_top"


        let img_bot = imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        img_bot.identifier = "img_bot"

        for constraint in [
            img_lead, img_trail, img_top, img_bot
            ] {
                constraint.isActive = true
        }

        self.addConstraints([
            img_lead, img_trail, img_top, img_bot
            ])

    }
    
}



extension ZoomableImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // print("scale factor is: \(scrollView.zoomScale)")
        return imageView
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("scale factor is: \(scrollView.zoomScale)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("content offset is: \(scrollView.contentOffset)")
    }
}

import UIKit

class ZoomableImageView: UIScrollView {
    
    public struct Constants {
        
        // 0.5 is not enough for several photos
        // TODO: find a better way to set it
        // do not use constants, instead, calculate at image setting time
        //static let minimumZoomScale: CGFloat = 0.005;
        //static let maximumZoomScale: CGFloat = 6.0;
        
        // the ratio of the content (e..g face) taken inside the entire view
        static let contentSpanRatio: CGFloat = 0.8
    }
    
    
    // public so that delegate can access
    public let imageView: UIImageView = {
        
        let _imageView = UIImageView()
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return _imageView
        
    } ()
    
    
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
        
        let ratioWidth = self.frame.width / image.size.width
        let ratioHeight = self.frame.height / image.size.height
        
        var isVertical = false
        var scale: CGFloat = 0.0
        var offset: CGPoint = .zero
        
        if ratioHeight < ratioWidth {
            isVertical = true
            scale = ratioHeight
            
            offset = CGPoint(x: 0, y: (self.contentSize.height - self.bounds.height) / 2 )
            
        } else {
            isVertical = false
            scale = ratioWidth
            
            offset = CGPoint(x: (self.contentSize.width - self.bounds.width) / 2, y: 0 )
        }
        
      


        // reset scale and offset on each resetting of image
        self.zoomScale = scale
        
        // gw: TODO: tricky for offset
        //self.contentOffset = offset
        
        let imageViewSize = imageView.frame.size
        let scrollViewSize = self.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        self.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
        
        
    }
    
    
    
     // gw: must be called to complete a setting
    // note: this imageVIew is responsible for setting the image content, but its VC must setNeedsLayout
    public func setImage(image: UIImage) {
        imageView.image = image

        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        self.contentSize = image.size
        
        // gw: note, need to be placed at VC level , not here at imageView
        // https://stackoverflow.com/a/15141367/8328365
        //setNeedsLayout()
        //layoutIfNeeded()
        //setZoomScale()
        
    }
    
    func setZoomScale() {
        
        
        let imageViewSize = imageView.bounds.size
        
        let scrollViewSize = self.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        print("gw: imageViewSize: \(imageViewSize), scrollViewSize: \(scrollViewSize)")
        
        self.minimumZoomScale = min(widthScale, heightScale)
        //self.maximumZoomScale = 1.2 // allow maxmum 120% of original image size
        
        self.maximumZoomScale = 6 // allow zoom to face box
        
        // set initial zoom to fit the longer side (longer side ==> smaller scale)
        zoomScale = minimumZoomScale
        

    }
    
    
    // MARK - constructor
    init() {
        // gw: there is no super.init(), you have to use this constructor as hack
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) // gw: relies on autolayout constraint later
        
        
        
        addSubview(imageView)
        
        // use auto layout
        setupLayoutConstraints()
        
        
        // the delegate instance assignment should happen at a place where
        // If one object has the responsibility for several classes's delegate (e.g. here canvas is delegate for peopleCollectionVIew, and ZoomabableImageView, because canvas is in charge of updating annotatino when either one scrolls),
        // 1. you can let the object class (canvas) subclass all these delegate protocol if these protocal has no collition (different delegate protocol), or
        // 2. if these delegate protocols collides, (e.g. here both people coll View and Zoomable Image View requires scroll view delegates), make two custom classes (so that you can implement different scroll view delegate functions within each class), and at the cavas object, instance one class each as canvas's property, and assign them as delegate each for peopleCollectionVIew, and ZoomabableImageView
        
        // moved to ViewController
        //self.delegate = self
        
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


// moved to ZoomableImageViewDelegate
//extension ZoomableImageView: UIScrollViewDelegate {
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        // print("scale factor is: \(scrollView.zoomScale)")
//        return imageView
//    }
//    
//    
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        print("scale factor is: \(scrollView.zoomScale)")
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("content offset is: \(scrollView.contentOffset)")
//    }
//}

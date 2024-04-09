import UIKit

class view_reportVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView! 
    @IBOutlet weak var viewreportImageView: UIImageView!
    
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Medical Records"
        loadImage()
        setupZoom()
    }
    
    func loadImage() {
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async { [weak self] in
                self?.viewreportImageView.image = UIImage(data: data)
                self?.viewreportImageView.layer.borderColor = UIColor.black.cgColor
                self?.viewreportImageView.layer.borderWidth = 2.0
                self?.viewreportImageView.layer.cornerRadius = 8.0
                self?.viewreportImageView.clipsToBounds = true
            }
        }.resume()
    }
    
    func setupZoom() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
    }
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        let center = scrollView.convert(center, from: viewreportImageView)
        var zoomRect = CGRect.zero
        zoomRect.size.height = scrollView.frame.size.height / scale
        zoomRect.size.width = scrollView.frame.size.width / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return viewreportImageView
    }
}

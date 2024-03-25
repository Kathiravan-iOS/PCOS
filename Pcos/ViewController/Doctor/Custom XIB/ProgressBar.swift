
import UIKit

class ProgressBar: UITableViewCell {

    @IBOutlet weak var carbView: UIView!
    @IBOutlet weak var proView: UIView!
    @IBOutlet weak var fatView: UIView!

    private let shapeLayer = CAShapeLayer()
    var name24 : String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let progressBarView1 = PercentageProgressBarView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        let yellowColor = UIColor(hex: "#FEC635") // UIColor(red: 254/255, green: 198/255, blue: 53/255, alpha: 1.0)
        progressBarView1.progressBarColor = yellowColor
        addCenteredView(to: fatView, viewToAdd: progressBarView1, width: 80, height: 80)
        progressBarView1.setPercentage(50, customText: "Fat")
        
        let progressBarView2 = PercentageProgressBarView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        let blueColor = UIColor(hex: "#3585FE") //UIColor(red: 53/255, green: 133/255, blue: 254/255, alpha: 1.0)
        progressBarView2.progressBarColor = blueColor
        addCenteredView(to: proView, viewToAdd: progressBarView2, width: 80, height: 80)
        progressBarView2.setPercentage(70, customText: "Pro")
        
        let progressBarView3 = PercentageProgressBarView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
//        progressBarView3.progressBarColor = UIColor.black
        let voiletColor = UIColor(hex: "#8076F5") //UIColor(red: 128/255, green: 118/255, blue: 245/255, alpha: 1.0)
        progressBarView3.progressBarColor = voiletColor
        addCenteredView(to: carbView, viewToAdd: progressBarView3, width: 80, height: 80)
        progressBarView3.setPercentage(30, customText: "Carb")
    }

    // ... (other methods)

    func addCenteredView(to parentView: UIView, viewToAdd: UIView, width: CGFloat?, height: CGFloat?) {
        viewToAdd.translatesAutoresizingMaskIntoConstraints = false

        // Center horizontally
        let horizontalConstraint = NSLayoutConstraint(item: viewToAdd, attribute: .centerX, relatedBy: .equal, toItem: parentView, attribute: .centerX, multiplier: 1, constant: 0)

        // Center vertically
        let verticalConstraint = NSLayoutConstraint(item: viewToAdd, attribute: .centerY, relatedBy: .equal, toItem: parentView, attribute: .centerY, multiplier: 1, constant: 0)

        // Add constraints to the parent view
        parentView.addSubview(viewToAdd)
        parentView.addConstraints([horizontalConstraint, verticalConstraint])

        // Set viewToAdd's width and height if provided
        if let width = width {
            viewToAdd.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            viewToAdd.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

class PercentageProgressBarView: UIView {

    private let progressLayer = CAShapeLayer()
    private let percentageLabel = UILabel()
    private let shadowView = UIView()
    private let customLabel = UILabel()

    var progressBarColor: UIColor = .blue {
        didSet {
            progressLayer.strokeColor = progressBarColor.cgColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        let lineWidth: CGFloat = 10
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                        radius: (min(bounds.width, bounds.height) - lineWidth) / 2,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 2 * CGFloat.pi - CGFloat.pi / 2,
                                        clockwise: true)
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = progressBarColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)

        shadowView.frame = bounds
        shadowView.layer.shadowColor = UIColor.red.cgColor
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowRadius = 8
        addSubview(shadowView)

        percentageLabel.frame = bounds
        percentageLabel.textAlignment = .center
        percentageLabel.font = UIFont.systemFont(ofSize: 24)
        addSubview(percentageLabel)

        customLabel.frame = CGRect(x: 0, y: bounds.maxY + 5, width: bounds.width, height: 20)
        customLabel.textAlignment = .center
        customLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(customLabel)
    }

    func setPercentage(_ percentage: CGFloat, customText: String) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.0
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = percentage / 100
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        progressLayer.strokeEnd = percentage / 100
        progressLayer.add(animation, forKey: "percentageAnimation")

        percentageLabel.text = "\(Int(percentage))%"
        customLabel.text = customText
    }
}

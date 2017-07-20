import UIKit
import PlaygroundSupport

private final class ProgressLayer: CALayer {
	@NSManaged var progress: CGFloat

	private let fillColor = UIColor.blue.cgColor

	override class func needsDisplay(forKey key: String) -> Bool {
		if key == "progress" {
			return true
		}

		return super.needsDisplay(forKey: key)
	}

	override func action(forKey key: String) -> CAAction? {
		if key == "progress" {
			let animation = CABasicAnimation(keyPath: key)
			animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
			animation.fromValue = presentation()?.value(forKey: key)
			return animation
		}

		return super.action(forKey: key)
	}

	override init() {
		super.init()
	}

	override init(layer: Any) {
		super.init(layer: layer)

		guard let progressLayer = layer as? ProgressLayer else { return }

		progress = progressLayer.progress
	}

	override func draw(in context: CGContext) {
		context.setFillColor(fillColor)

		let progress = presentation()?.progress ?? 0

		var rect = bounds
		rect.size.width *= progress
		context.fill(rect)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
}

final class ProgressView: UIView {
	var progress: CGFloat {
		get {
			return progressLayer?.progress ?? 0
		}

		set {
			progressLayer?.progress = newValue
		}
	}

	override class var layerClass: AnyClass {
		return ProgressLayer.self
	}

	private var progressLayer: ProgressLayer? {
		return layer as? ProgressLayer
	}
}


final class ViewController: UIViewController {
	let progressView = ProgressView()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .white

		progressView.progress = 0.31
		progressView.backgroundColor = .clear

		progressView.frame = view.bounds
		progressView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.addSubview(progressView)

		let tap = UITapGestureRecognizer(target: self, action: #selector(increment))
		view.addGestureRecognizer(tap)
	}

	@objc private func increment() {
		progressView.progress += 0.1
	}
}

PlaygroundPage.current.liveView = ViewController()

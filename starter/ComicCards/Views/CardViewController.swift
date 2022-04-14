import Foundation
import UIKit
import Kingfisher
import Moya

class CardViewController: UIViewController {
  // - MARK: - Dependencies
  private var comic: Comic?

  // - MARK: - Outlets
  @IBOutlet weak private var lblTitle: UILabel!
  @IBOutlet weak private var lblDesc: UILabel!
  @IBOutlet weak private var lblChars: UILabel!
  @IBOutlet weak private var lblDate: UILabel!
  @IBOutlet weak private var image: UIImageView!
  @IBOutlet weak private var card: UIView!
  @IBOutlet weak private var progressBar: UIProgressView!
  @IBOutlet weak private var viewUpload: UIView!

  @IBOutlet weak private var btnShare: UIButton!
  @IBOutlet weak private var btnDelete: UIButton!

  private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "MMM dd, yyyy"

    return df
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    guard let comic = comic else { fatalError("Please pass in a valid Comic object") }

    layoutCard(comic: comic)
  }
}

// MARK: - Imgur handling
extension CardViewController {
  private func layoutCard(comic: Comic) {

  }

  @IBAction private func uploadCard() {
    UIView.animate(withDuration: 0.15) {
      self.viewUpload.alpha = 1.0
      self.btnShare.alpha = 0.0
      self.btnDelete.alpha = 0.0
    }

    progressBar.progress = 0.0
  }

  @IBAction private func deleteCard() {

  }
}

// MARK: - Helpers
extension CardViewController {
  static func instantiate(comic: Comic) -> CardViewController {
    guard let vc = UIStoryboard(name: "Main", bundle: nil)
      .instantiateViewController(withIdentifier: "ComicViewController") as? CardViewController else { fatalError("Unexpectedly failed getting ComicViewController from Storyboard") }

    vc.comic = comic

    return vc
  }

  private func presentShare(image: UIImage, url: URL) {
    let alert = UIAlertController(title: "Your card is ready!", message: nil, preferredStyle: .actionSheet)

    let openAction = UIAlertAction(title: "Open in Imgur", style: .default) { _ in
      UIApplication.shared.open(url)
    }

    let shareAction = UIAlertAction(title: "Share", style: .default) { [weak self] _ in
      let share = UIActivityViewController(activityItems: ["Check out my iMarvel card!", url, image],
                                           applicationActivities: nil)
      share.excludedActivityTypes = [.airDrop, .addToReadingList]
      self?.present(share, animated: true, completion: nil)
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    alert.addAction(openAction)
    alert.addAction(shareAction)
    alert.addAction(cancelAction)

    present(alert, animated: true, completion: nil)
  }

  private func presentError() {
    let alert = UIAlertController(title: "Uh oh", message: "Something went wrong. Try again later.",
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

    present(alert, animated: true, completion: nil)
  }

  private func snapCard() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(card.bounds.size, true, UIScreen.main.scale)
    card.layer.render(in: UIGraphicsGetCurrentContext()!)
    guard let image = UIGraphicsGetImageFromCurrentImageContext() else { fatalError("Failed snapping card") }
    UIGraphicsEndImageContext()

    return image
  }
}

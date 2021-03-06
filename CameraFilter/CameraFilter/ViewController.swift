//
//  ViewController.swift
//  CameraFilter
//
//  Created by Ignatio Julian on 17/04/21.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    let disposedBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController  = segue.destination as? UINavigationController,
              let photosCVC = navigationController.viewControllers.first as? PhotosCollectionVC else {
            fatalError("Segue Destination is not found")
        }
        
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
            
        }).disposed(by: disposedBag)
    }
    
    @IBAction func applyFilterButtonPressed(_ sender: Any) {
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
        FilterService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filterImage in
                DispatchQueue.main.async {
                    self.photoImageView.image = filterImage
                }
            })
    }
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.filterButton.isHidden = false
    }
    
}


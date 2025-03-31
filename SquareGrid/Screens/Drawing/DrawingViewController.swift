//
//  DrawingViewController.swift
//  SquareGrid
//

import UIKit
import ShapeDrawingKit
import Combine

class DrawingViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadImageButton: UIButton!
    @IBOutlet weak var applyFiltersButton: UIButton!
    
    private let canvasView = UIView()
    private let viewModel = DrawingViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCanvas()
        setupBindings()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        loadImageButton.isEnabled = false
        applyFiltersButton.isEnabled = false
    }
    
    private func setupCanvas() {
        canvasView.backgroundColor = .lightGray
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(canvasView)
        
        NSLayoutConstraint.activate([
            canvasView.widthAnchor.constraint(equalToConstant: Constants.Canvas.width),
            canvasView.heightAnchor.constraint(equalToConstant: Constants.Canvas.height),
            canvasView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            canvasView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            canvasView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
        
        scrollView.contentSize = Constants.Canvas.size
        
        // Center the canvas in the scroll view
        let centerContentHorizontally = scrollView.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor)
        centerContentHorizontally.priority = .defaultLow
        let centerContentVertically = scrollView.centerYAnchor.constraint(equalTo: canvasView.centerYAnchor)
        centerContentVertically.priority = .defaultLow
        
        NSLayoutConstraint.activate([centerContentHorizontally, centerContentVertically])
    }
    
    private func setupBindings() {
        viewModel.$loadImageButtonEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: loadImageButton)
            .store(in: &cancellables)
        
        viewModel.$applyFiltersButtonEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: applyFiltersButton)
            .store(in: &cancellables)
        
        viewModel.$applyFiltersButtonTitle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.applyFiltersButton.setTitle(title, for: .normal)
            }
            .store(in: &cancellables)
        
        viewModel.$isProcessingImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isProcessing in
                if isProcessing {
                    self?.showActivityIndicator()
                } else {
                    self?.hideActivityIndicator()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator?.color = .gray
        
        if let frame = viewModel.firstShapeFrame {
            activityIndicator?.center = CGPoint(x: frame.midX, y: frame.midY)
        } else {
            activityIndicator?.center = CGPoint(x: canvasView.bounds.midX, y: canvasView.bounds.midY)
        }
        
        activityIndicator?.startAnimating()
        if let indicator = activityIndicator {
            canvasView.addSubview(indicator)
        }
    }
    
    private func hideActivityIndicator() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
    }
    
    @IBAction func draw2x2GridAction(_ sender: Any) {
        canvasView.subviews.forEach { $0.removeFromSuperview() }
        canvasView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let shapes = viewModel.draw2x2Grid()
        shapes.forEach { shape in
            shape.draw(in: canvasView)
        }
    }
    
    @IBAction func draw3x3GridAction(_ sender: Any) {
        canvasView.subviews.forEach { $0.removeFromSuperview() }
        canvasView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let shapes = viewModel.draw3x3Grid()
        shapes.forEach { shape in
            shape.draw(in: canvasView)
        }
    }
    
    @IBAction func loadImageAction(_ sender: Any) {
        viewModel.loadImage()
    }
    
    @IBAction func applyFilterAction(_ sender: Any) {
        Task {
            await viewModel.applyFilters()
        }
    }
}

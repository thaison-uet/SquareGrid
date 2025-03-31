import UIKit
import Foundation
import Combine
import ShapeDrawingKit

@MainActor
final class DrawingViewModel {
    
    @Published private(set) var isImageLoaded = false
    @Published private(set) var isProcessingImage = false
    @Published private(set) var areFiltersApplied = false
    @Published private(set) var loadImageButtonEnabled = false
    @Published private(set) var applyFiltersButtonEnabled = false
    @Published private(set) var applyFiltersButtonTitle = "Apply Filters"
    
    private var drawingManager: ShapeDrawingManager?
    private var shapes: [ShapeProtocol] = []
    private var processingTask: Task<Void, Never>?
    
    var firstShapeFrame: CGRect? {
        shapes.first?.frame
    }
    
    func draw2x2Grid() -> [ShapeProtocol] {
        clearCanvas()
        
        let config = CanvasConfiguration(
            canvasSize: Constants.Canvas.size,
            rows: 2,
            columns: 2,
            spacing: Constants.Canvas.gridSpacing,
            padding: UIEdgeInsets(top: Constants.Canvas.gridSpacing,
                                  left: Constants.Canvas.gridSpacing,
                                  bottom: Constants.Canvas.gridSpacing,
                                  right: Constants.Canvas.gridSpacing),
            shapeType: .square
        )
        
        drawingManager = ShapeDrawingManager(canvasConfiguration: config)
        if let manager = drawingManager {
            shapes = manager.drawShapes(in: UIView())
            loadImageButtonEnabled = true
            applyFiltersButtonEnabled = false
            isImageLoaded = false
        }
        
        return shapes
    }
    
    func draw3x3Grid() -> [ShapeProtocol] {
        clearCanvas()
        
        let config = CanvasConfiguration(
            canvasSize: Constants.Canvas.size,
            rows: 3,
            columns: 3,
            spacing: Constants.Canvas.gridSpacing,
            padding: UIEdgeInsets(top: Constants.Canvas.gridSpacing,
                                  left: Constants.Canvas.gridSpacing,
                                  bottom: Constants.Canvas.gridSpacing,
                                  right: Constants.Canvas.gridSpacing),
            shapeType: .square
        )
        
        drawingManager = ShapeDrawingManager(canvasConfiguration: config)
        if let manager = drawingManager {
            shapes = manager.drawShapes(in: UIView())
            loadImageButtonEnabled = true
            applyFiltersButtonEnabled = false
            isImageLoaded = false
        }
        
        return shapes
    }
    
    func loadImage() {
        guard !shapes.isEmpty,
              let shape = shapes.first,
              let image = UIImage(named: Constants.Images.defaultImage) else {
            return
        }
        
        shape.loadImage(image)
        loadImageButtonEnabled = false
        applyFiltersButtonTitle = "Apply Filters"
        applyFiltersButtonEnabled = true
        isImageLoaded = true
        areFiltersApplied = false
    }
    
    func applyFilters() async {
        guard isImageLoaded, !isProcessingImage,
              let shape = shapes.first, shape.image != nil else {
            return
        }
        
        if areFiltersApplied {
            cancelProcessingTaskIfNeeded()
            
            if let image = UIImage(named: Constants.Images.defaultImage) {
                // First load the new image
                shape.loadImage(image)
                
                // Then update the state
                areFiltersApplied = false
                applyFiltersButtonTitle = "Apply Filters"
                processingTask = nil
                
                return
            }
        }
        
        isProcessingImage = true
        applyFiltersButtonEnabled = false
        
        processingTask = Task(priority: .userInitiated) {
            if Task.isCancelled { return }
            
            await shape.processImage(vibranceValue: -0.3, claheValue: 0.2)
            
            if Task.isCancelled { return }
            
            await MainActor.run {
                if !Task.isCancelled {
                    isProcessingImage = false
                    areFiltersApplied = true
                    applyFiltersButtonTitle = "Restore Original"
                    applyFiltersButtonEnabled = true
                }
            }
        }
    }
    
    private func clearCanvas() {
        cancelProcessingTaskIfNeeded()
        
        shapes = []
        loadImageButtonEnabled = false
        applyFiltersButtonEnabled = false
        isImageLoaded = false
        areFiltersApplied = false
        applyFiltersButtonTitle = "Apply Filters"
    }
    
    private func cancelProcessingTaskIfNeeded() {
        guard let processingTask = processingTask else {
            return
        }
        
        processingTask.cancel()
        self.processingTask = nil
        isProcessingImage = false
        applyFiltersButtonEnabled = true
    }
}

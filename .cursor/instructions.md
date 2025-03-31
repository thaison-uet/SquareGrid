# Project Overview:
You are an expert in coding with Swift, UIKit. Now you are building an iOS project about drawing shapes (specifically squares in a grid), loading images into those shapes, and performing image processing using MetalPetal. The goal is to demonstrate your skills in:
- Setting up an iOS application from scratch with Swift (universal build).
- Drawing shapes with CoreAnimation.
- Loading images into shapes.
- Applying filters (Vibrance, CLAHE) to images with MetalPetal, ensuring the UI remains responsive.

# Functionalities:
1. **Universal iOS Application**  
   - The app should run on both iPhone and iPad.
2. **Draw Shapes Using CoreAnimation**  
   - Given a canvas of size 400x400, implement an algorithm to draw squares in a 2x2 or 3x3 layout without hardcoding the positions.
   - The squares should not overlap each other.
   - Include preset buttons to trigger the drawing of the shapes (no touch interaction required).
3. **Load an Image into a Shape**  
   - Provide a preset button to load an image into any drawn shape (no need for a UIImagePicker).
4. **Image Processing with MetalPetal**  
   - After loading the image into a shape, apply the following filters in sequence:
     - **Vibrance filter** (adjust value/weight as needed)
     - **CLAHE filter** (adjust value/weight as needed)
   - Ensure that the filtering does not block the main UI thread (i.e., keep the UI responsive).

# Requirements:
1. **Performance & Architecture**  
   - The app must perform smoothly and utilize the hardware capabilities efficiently (especially for image processing).
   - A well-designed architecture is required to make the code maintainable and extensible.
2. **Submission Criteria**  
   - You must submit the entire codebase (apart from running `pod install` if you use CocoaPods).
   - The project must build and run on the iOS Simulator without additional setup.
   - You can share the code via GitHub, Bitbucket, Dropbox, or Google Drive.
3. **Evaluation**  
   - You will be evaluated on how you implement iOS and external libraries.
   - You will be evaluated on the drawing algorithm and how quickly you deliver the solution.
   - You will be evaluated on hardware utilization (e.g., performance considerations for filters).
   - Bonus points for designing/architecting the app to share modules across different mobile platforms.
4. **Modularization**  
   - It is required to modularize the functionality of the application so that all features are implemented as a package used within the main app.

# Current Project Structure:
This is the project structure before step 1:
Main app:
SquareGrid
└─ SquareGrid
   ├─ App
   │  ├─ AppDelegate.swift
   │  └─ Info.plist
   ├─ Common
   │  ├─ Extensions
   │  └─ Models
   ├─ Resources
   │  ├─ Assets.xcassets
   │  └─ LaunchScreen.storyboard
   ├─ Screens
   │  └─ Drawing
   │     ├─ DrawingViewController.swift
   │     └─ DrawingViewController.swift
   └─ Utils
Package:
ShapeDrawingKit
├─ README.md
├─ Package.swift
└─ Sources
   └─ ShapeDrawingKit
      ├─ Core
      │  ├─ ShapeProtocol.swift
      │  └─ ShapeType.swift
      └─ Shapes
         └─ Square
            └─ Square.swift

# Note:
- The information above summarizes the overall requirements for the project.  
- To avoid confusion or large-scale errors, the implementation will be broken down into smaller steps.  
- Below is **Step 1** only; subsequent steps will be updated later.

## Step 1:
- In your **ShapeDrawingKit** package (likely within `ShapeProtocol.swift` or in a dedicated file), define the parameters that the main app can use to configure the shape drawing:
  + **Canvas Size** (e.g., `CGSize`)
  + **Number of Rows & Columns** (e.g., `Int` for rows, `Int` for columns)
  + **Spacing Between Shapes** (e.g., `CGFloat`)
  + **Padding** (distance from the edge of the canvas, e.g., `UIEdgeInsets` or separate `CGFloat` values)
  + **Shape Style** (use the existing enum for shape type)
- Initialize a sample square on the main screen of the main app.

## Step 2:
- Load an image into any of the shapes (currently always display it on the first shape)
  + You can preset the button to load an image. The imagepicker is not required
  + I already add the local image into assets to display on shape. It is "coffee.jpg"

## Step 3:
- Take the same image from the shape and perform image processing(filter) by preset button using MetalPetal (https://github.com/MetalPetal/MetalPetal) in the following order:
  + Vibrance filter:  Adjust the value/weight accordingly
  + CLAHE filter:  Adjust the value/weight accordingly
- Please ensure the image processing doesn’t block the main UI thread.

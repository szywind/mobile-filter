import Foundation

import UIKit

public class MyInstaFilter{
    var image: UIImage
    
    // initializer
    public init(inputImgName: String){
        self.image = UIImage(imageLiteralResourceName: inputImgName)
    }
    
    public init(inputImg: UIImage){
        self.image = inputImg
    }
    
    // get the original image
    public func getImage()->UIImage{
        return self.image
    }
    
    // 1. apply mean filter, the kernel size is configured by the radius (with default value 1)
    public func meanFilter(image: UIImage, radius: Int = 1)->UIImage{
        let myRGBA = RGBAImage(image: self.image)!
        let N = (2 * radius + 1) * (2 * radius + 1 )
        for y in radius..<myRGBA.height-radius{
            for x in radius..<myRGBA.width-radius{
                let index = y * myRGBA.width + x
                var red = 0
                var blue = 0
                var green = 0
                for i in y-radius...y+radius{
                    for j in x-radius...x+radius{
                        var ptemp = myRGBA.pixels[i * myRGBA.width + j]
                        red += Int(ptemp.red)
                        green += Int(ptemp.green)
                        blue += Int(ptemp.blue)
                    }
                }
                myRGBA.pixels[index].red = UInt8(red/N)
                myRGBA.pixels[index].blue = UInt8(blue/N)
                myRGBA.pixels[index].green = UInt8(green/N)
            }
        }
        return myRGBA.toUIImage()!
    }
    
    
    // 2. apply gaussian filter, the kernel size is configured by the radius (with default value 1), the distribution of the Gaussian is configured by the sigma (with default value 0.8)

    public func gaussianFilter(image: UIImage, sigma: Double = 0.8, radius:Int = 1)-> UIImage{
        let sigma = max(sigma, 0.1)
        var kernel = Array<Array<Double>>();
        var sumWeight = 0.0
        
        // compute the kernel
        for i in -radius...radius{
            var row = Array<Double>()
            for j in -radius...radius{
                let val = 1.0/(2*Double.pi*sigma*sigma)*exp(-Double(i*i+j*j)/(2*sigma*sigma))
                row.append(val)
                sumWeight += val
            }
            kernel.append(row)
        }
        
        let myRGBA = RGBAImage(image: image)!

//        for y in radius..<myRGBA.height-radius{
//            for x in radius..<myRGBA.width-radius{
        for y in 0..<myRGBA.height {
            for x in 0..<myRGBA.width {
                let index = y * myRGBA.width + x
                var red = 0.0
                var blue = 0.0
                var green = 0.0
                let minY = max(0, y-radius)
                let maxY = min(y+radius, myRGBA.height-1)
                let minX = max(0, x-radius)
                let maxX = min(x+radius, myRGBA.width-1)
                
                //var sumWeight1 = 0.0
                
                for i in minY...maxY {
                    for j in minX...maxX{
                        var ptemp = myRGBA.pixels[i * myRGBA.width + j]
                        let weight = kernel[i-(y-radius)][j-(x-radius)]
                        //sumWeight1 += weight
                        red   += Double(ptemp.red)*weight
                        green += Double(ptemp.green)*weight
                        blue  += Double(ptemp.blue)*weight
                    }
                }
                myRGBA.pixels[index].red = UInt8(red/sumWeight)
                myRGBA.pixels[index].blue = UInt8(blue/sumWeight)
                myRGBA.pixels[index].green = UInt8(green/sumWeight)
            }
        }
        //self.image = myRGBA.toUIImage()!
        let ciImage = CIImage(image: myRGBA.toUIImage()!)
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(ciImage!, from: ciImage!.extent)
        let newImage = UIImage(cgImage: cgImage!, scale: 1.0, orientation:image.imageOrientation)
        return newImage
    }

    
    /*
    public func gaussianFilter(image: UIImage, intensity: Double = 0.8)-> UIImage{
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter!.setValue(image, forKey: kCIInputImageKey)
        blurFilter!.setValue(intensity, forKey: kCIInputRadiusKey)
        let ciImage = blurFilter!.outputImage!
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(ciImage, fromRect: ciImage.extent)
        let newImage = UIImage(CGImage: cgImage, scale: 1.0, orientation:image.imageOrientation)
        return newImage
    }
    */
    
    
    // 3. convert color image to gray image
    public func convertToGrayScale(image:UIImage) -> UIImage {
        
        let imageRect:CGRect = CGRect(0, 0, image.size.width, image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.draw(image.cgImage!, in: imageRect)

        let imageRef = context!.makeImage()
        let newImage = UIImage(cgImage: imageRef!, scale: 1.0, orientation: image.imageOrientation)
        return newImage

/*
        let redCoefs = [0.2126, 0.2126, 0.2126]
        let greenCoefs = [0.7152, 0.7152, 0.7152]
        let blueCoefs = [0.0722, 0.0722, 0.0722]
        let alphaCoef = 1.0
        
        let myRGBA = RGBAImage(image: image)!
        print("Before")
        print(myRGBA.height)
        print(myRGBA.width)
        
        for y in 0..<myRGBA.height {
            for x in 0..<myRGBA.width {
                let index = y * myRGBA.width + x
                var pixel = myRGBA.pixels[index]
                let red = Double(pixel.red)
                let green = Double(pixel.green)
                let blue = Double(pixel.blue)
                let newRed = red * redCoefs[0] + green * greenCoefs[0] + blue * blueCoefs[0]
                let newGreen = red * redCoefs[1] + green * greenCoefs[1] + blue * blueCoefs[1]
                let newBlue = red * redCoefs[2] + green * greenCoefs[2] + blue * blueCoefs[2]
                pixel.red = UInt8(max(0, min(255, newRed)))
                pixel.green = UInt8(max(0, min(255, newGreen)))
                pixel.blue = UInt8(max(0, min(255, newBlue)))
                pixel.alpha = UInt8(max(0, min(255, alphaCoef * Double(pixel.alpha))))
                myRGBA.pixels[index] = pixel
            }
        }
        print("Transform to Gray Image")
        print(myRGBA.height)
        print(myRGBA.width)
        return myRGBA.toUIImage()!
*/
    }
    
    // 4. adjust contrast
    public func contrastFilter(image:UIImage, intensity:Double) -> UIImage {
        
        let myRGBA = RGBAImage(image: image)!
        
        let level = intensity * 128 / 100.0
        let factorNumerator = Double(259 * (level + 255))
        let factorDenumerator = Double(255 * (259 - level))
        let factor = factorNumerator / factorDenumerator
        
        for y in 0..<myRGBA.height {
            for x in 0..<myRGBA.width {
                let index = y * myRGBA.width + x
                var pixel = myRGBA.pixels[index]
                let red = Double(pixel.red)
                let green = Double(pixel.green)
                let blue = Double(pixel.blue)
                let newRed = factor * (red - 128) + 128
                let newGreen = factor * (green - 128) + 128
                let newBlue = factor * (blue - 128) + 128
                pixel.red = UInt8(max(0, min(255, newRed)))
                pixel.green = UInt8(max(0, min(255, newGreen)))
                pixel.blue = UInt8(max(0, min(255, newBlue)))
                myRGBA.pixels[index] = pixel
            }
        }
        //return myRGBA.toUIImage()!
        let ciImage = CIImage(image: myRGBA.toUIImage()!)
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(ciImage!, from: ciImage!.extent)
        let newImage = UIImage(cgImage: cgImage!, scale: 1.0, orientation:image.imageOrientation)
        return newImage
    }
    
    // 5. adjust brightness
    public func brightnessFilter(image:UIImage, intensity:Double) -> UIImage{
        
        let myRGBA = RGBAImage(image: image)!
        
        
        for y in 0..<myRGBA.height {
            for x in 0..<myRGBA.width {
                let index = y * myRGBA.width + x
                var pixel = myRGBA.pixels[index]
                let red = Double(pixel.red)
                let green = Double(pixel.green)
                let blue = Double(pixel.blue)
                let newRed = red * intensity
                let newGreen = green * intensity
                let newBlue = blue * intensity
                pixel.red = UInt8(max(0, min(255, newRed)))
                pixel.green = UInt8(max(0, min(255, newGreen)))
                pixel.blue = UInt8(max(0, min(255, newBlue)))
                myRGBA.pixels[index] = pixel
            }
        }
        return myRGBA.toUIImage()!
//        let ciImage = CIImage(image: myRGBA.toUIImage()!)
//        let context = CIContext(options: nil)
//        let cgImage = context.createCGImage(ciImage!, from: ciImage!.extent)
//        let newImage = UIImage(CGImage: cgImage, scale: 1.0, orientation:image.imageOrientation)
//        return newImage
    }
    
    
    // default filter formular
    public func imgFilter(mode: String, intensity: Double = 0.5) -> UIImage{
        switch(mode){
        case "rgb2gray":
            return self.convertToGrayScale(image: self.image)

        case "meanFilter":
            return self.meanFilter(image: self.image)

        case "gaussianFilter":
            return self.gaussianFilter(image: self.image, sigma: intensity)

        case "meanFilteredGray":
            return self.convertToGrayScale(image: self.meanFilter(image: self.image))
            
        case "gaussianFilteredGray":
            return self.convertToGrayScale(image: self.gaussianFilter(image: self.image))
           
        case "contrastAdjust":
            return self.contrastFilter(image: self.image, intensity: intensity)
            
        case "brightnessAdjust":
            return self.brightnessFilter(image: self.image, intensity: intensity)
            
        default:
            return self.getImage()
        }
    }
    
    func correctlyOrientedImage(image:UIImage) -> UIImage {
        if image.imageOrientation == UIImageOrientation.up {
            return image
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(0, 0, image.size.width, image.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return normalizedImage;
    }
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}

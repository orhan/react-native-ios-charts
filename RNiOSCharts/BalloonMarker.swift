//
//  BalloonMarker.swift
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 19/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//  https://github.com/danielgindi/Charts/blob/1788e53f22eb3de79eb4f08574d8ea4b54b5e417/ChartsDemo/Classes/Components/BalloonMarker.swift
//  Edit: Added textColor

import Foundation;
import Charts;

public class BalloonMarker: MarkerView
{
    public var color: UIColor?
    public var arrowSize = CGSize(width: 15, height: 11)
    public var font: UIFont?
    public var textColor: UIColor?
    public var insets = UIEdgeInsets()
    public var minimumSize = CGSize()
    
    private var labelns: NSString?
    private var _labelSize: CGSize = CGSize()
    private var _size: CGSize = CGSize()
    private var _paragraphStyle: NSMutableParagraphStyle?
    private var _drawAttributes = [String : AnyObject]()
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
          
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets
      
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
    }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
    public override func draw(context: CGContext, point: CGPoint)
    {
        if (labelns == nil)
        {
            return
        }
        
        var rect = CGRect(origin: point, size: _size)
        rect.origin.x -= _size.width / 2.0
        rect.origin.y -= _size.height
        
        context.saveGState()
        
        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height - arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0, y: rect.origin.y + rect.size.height - arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width / 2.0, y: rect.origin.y + rect.size.height))
        context.addLine(to: CGPoint(x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0, y: rect.origin.y + rect.size.height - arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height - arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        context.fillPath()
        
        rect.origin.y += self.insets.top
        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)
      
        labelns?.draw(in: rect, withAttributes: _drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        labelns = entry.description as NSString;
      
        _drawAttributes.removeAll()
        _drawAttributes[NSFontAttributeName] = self.font
        _drawAttributes[NSParagraphStyleAttributeName] = _paragraphStyle
        _drawAttributes[NSForegroundColorAttributeName] = self.textColor
        
        _labelSize = labelns?.size(attributes: _drawAttributes) ?? CGSize.zero
        _size.width = _labelSize.width + self.insets.left + self.insets.right
        _size.height = _labelSize.height + self.insets.top + self.insets.bottom
        _size.width = max(minimumSize.width, _size.width)
        _size.height = max(minimumSize.height, _size.height)
    }
}

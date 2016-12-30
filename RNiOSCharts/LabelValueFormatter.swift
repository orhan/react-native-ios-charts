//
//  DefaultValueFormatter.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import Charts
import SwiftyJSON

@objc(ChartLabelValueFormatter)
open class LabelValueFormatter: NSObject, IAxisValueFormatter
{
  public typealias Block = (
    _ value: Double,
    _ axis: AxisBase?) -> String

  open var block: Block?

  open var hasAutoDecimals: Bool = false

  fileprivate var _formatter: NumberFormatter?
  open var formatter: NumberFormatter?
    {
    get { return _formatter }
    set
    {
      hasAutoDecimals = false
      _formatter = newValue
    }
  }

  fileprivate var _decimals: Int?
  open var decimals: Int?
    {
    get { return _decimals }
    set
    {
      _decimals = newValue

      if let digits = newValue
      {
        self.formatter?.minimumFractionDigits = digits
        self.formatter?.maximumFractionDigits = digits
        self.formatter?.usesGroupingSeparator = true
      }
    }
  }

  fileprivate var _labelsForValues: [String] = []
  open var labelsForValues: [String]
    {
    get { return _labelsForValues }
    set
    {
      _labelsForValues = newValue
    }
  }

  public override init()
  {
    super.init()

    self.formatter = NumberFormatter()
    hasAutoDecimals = true
  }

  public init(formatter: NumberFormatter)
  {
    super.init()

    self.formatter = formatter
  }

  public init(formatter: NumberFormatter, labelsForValues: [String])
  {
    super.init()

    self.formatter = formatter
    self.labelsForValues = labelsForValues
  }

  public init(decimals: Int)
  {
    super.init()

    self.formatter = NumberFormatter()
    self.formatter?.usesGroupingSeparator = true
    self.decimals = decimals
    hasAutoDecimals = true
  }

  public init(block: @escaping Block)
  {
    super.init()

    self.block = block
  }

  public static func with(block: @escaping Block) -> LabelValueFormatter?
  {
    return LabelValueFormatter(block: block)
  }

  open func stringForValue(_ value: Double,
                           axis: AxisBase?) -> String
  {
    if block != nil
    {
      return block!(value, axis)
    }
    else
    {
      if (labelsForValues.count > 0 && labelsForValues.indices.contains(Int(value))) {
        return labelsForValues[Int(value)];
      } else {
        return formatter?.string(from: NSNumber(floatLiteral: value)) ?? ""
      }
    }
  }
}

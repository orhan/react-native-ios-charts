//
//  chartDataHelpers.swift
//  ChartsExplorer
//
//  Created by Jose Padilla on 3/18/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

import Foundation
import Charts
import SwiftyJSON


var maximumDecimalPlaces: Int = 0;
var minimumDecimalPlaces: Int = 0;

func getLineData(_ labels: [String], json: JSON!) -> LineChartData {
    if !json["dataSets"].exists() {
        return LineChartData();
    }
  
    let dataSets = json["dataSets"].arrayObject;
    var sets: [LineChartDataSet] = [];

    for set in dataSets! {
        let tmp = JSON(set);
        if tmp["values"].exists() {
            let values = tmp["values"].arrayValue.map({$0.doubleValue});
            let label = tmp["label"].exists() ? tmp["label"].stringValue : "";
            var dataEntries: [ChartDataEntry] = [];

            for i in 0..<values.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: values[i]);
                dataEntries.append(dataEntry);
            }

            let dataSet = LineChartDataSet(values: dataEntries, label: label);

            if tmp["colors"].exists() {
                let arrColors = tmp["colors"].arrayValue.map({$0.intValue});
                dataSet.colors = arrColors.map({return RCTConvert.uiColor($0)});
            }

            if tmp["drawCircles"].exists() {
                dataSet.drawCirclesEnabled = tmp["drawCircles"].boolValue;
            }

            if tmp["lineWidth"].exists() {
                dataSet.lineWidth = CGFloat(tmp["lineWidth"].floatValue);
            }

            if tmp["circleColors"].exists() {
                let arrColors = tmp["circleColors"].arrayValue.map({$0.intValue});
                dataSet.circleColors = arrColors.map({return RCTConvert.uiColor($0)});
            }

            if tmp["circleHoleColor"].exists() {
                dataSet.circleHoleColor = RCTConvert.uiColor(tmp["circleHoleColor"].intValue);
            }

            if tmp["circleRadius"].exists() {
                dataSet.circleRadius = CGFloat(tmp["circleRadius"].floatValue);
            }

            if tmp["cubicIntensity"].exists() {
                dataSet.cubicIntensity = CGFloat(tmp["cubicIntensity"].floatValue);
            }

            if tmp["drawCircleHole"].exists() {
                dataSet.drawCircleHoleEnabled = tmp["drawCircleHole"].boolValue;
            }

            if tmp["drawCubic"].exists() {
                dataSet.drawCubicEnabled = tmp["drawCubic"].boolValue;
            }

            if tmp["drawFilled"].exists() {
                dataSet.drawFilledEnabled = tmp["drawFilled"].boolValue;
            }

            if tmp["drawHorizontalHighlightIndicator"].exists() {
                dataSet.drawHorizontalHighlightIndicatorEnabled = tmp["drawHorizontalHighlightIndicator"].boolValue;
            }

            if tmp["drawVerticalHighlightIndicator"].exists() {
                dataSet.drawVerticalHighlightIndicatorEnabled = tmp["drawVerticalHighlightIndicator"].boolValue;
            }

            if tmp["drawValues"].exists() {
                dataSet.drawValuesEnabled = tmp["drawValues"].boolValue;
            }

            if tmp["fillAlpha"].exists() {
                dataSet.fillAlpha = CGFloat(tmp["fillAlpha"].floatValue);
            }

            if tmp["fillColor"].exists() {
                dataSet.fillColor = RCTConvert.uiColor(tmp["fillColor"].intValue);
            }

            if tmp["highlightColor"].exists() {
                dataSet.highlightColor = RCTConvert.uiColor(tmp["highlightColor"].intValue);
            }

            if tmp["highlightEnabled"].exists() {
                dataSet.highlightEnabled = tmp["highlightEnabled"].boolValue;
            }

            if tmp["highlightLineDashLengths"].exists() {
                dataSet.highlightLineDashLengths = [CGFloat(tmp["highlightLineDashLengths"].floatValue)];
            }

            if tmp["highlightLineDashPhase"].exists() {
                dataSet.highlightLineDashPhase = CGFloat(tmp["highlightLineDashPhase"].floatValue);
            }

            if tmp["highlightLineWidth"].exists() {
                dataSet.highlightLineWidth = CGFloat(tmp["highlightLineWidth"].floatValue);
            }

            if tmp["lineDashLengths"].exists() {
                dataSet.lineDashLengths = [CGFloat(tmp["lineDashLengths"].floatValue)];
            }

            if tmp["lineDashPhase"].exists() {
                dataSet.lineDashPhase = CGFloat(tmp["lineDashPhase"].floatValue);
            }

            if tmp["lineWidth"].exists() {
                dataSet.lineWidth = CGFloat(tmp["lineWidth"].floatValue);
            }

            if tmp["axisDependency"].exists() {
                let value = tmp["axisDependency"].stringValue;
                if value == "left" {
                    dataSet.axisDependency = .left;
                } else if value == "right" {
                    dataSet.axisDependency = .right;
                }
            }

            if tmp["valueTextFontName"].exists() {
                dataSet.valueFont = UIFont(
                    name: tmp["valueTextFontName"].stringValue,
                    size: dataSet.valueFont.pointSize
                    )!;
            }

            if tmp["valueTextFontSize"].exists() {
                dataSet.valueFont = dataSet.valueFont.withSize(CGFloat(tmp["valueTextFontSize"].floatValue));
            }

            if tmp["valueTextColor"].exists() {
                dataSet.valueTextColor = RCTConvert.uiColor(tmp["valueTextColor"].intValue);
            }

            if json["valueFormatter"].exists() {
                if json["valueFormatter"]["minimumDecimalPlaces"].exists() {
                    minimumDecimalPlaces = json["valueFormatter"]["minimumDecimalPlaces"].intValue;
                }
                if json["valueFormatter"]["maximumDecimalPlaces"].exists() {
                    maximumDecimalPlaces = json["valueFormatter"]["maximumDecimalPlaces"].intValue;
                }

                if json["valueFormatter"]["type"].exists() {
                    switch(json["valueFormatter"]["type"]) {
                    case "regular":
                        dataSet.valueFormatter = DefaultValueFormatter(formatter: NumberFormatter());
                        break;
                    case "abbreviated":
                        dataSet.valueFormatter = DefaultValueFormatter(formatter: ABNumberFormatter(minimumDecimalPlaces: minimumDecimalPlaces, maximumDecimalPlaces: maximumDecimalPlaces));
                        break;
                    default:
                        dataSet.valueFormatter = DefaultValueFormatter(formatter: NumberFormatter());
                    }
                }

                if json["valueFormatter"]["numberStyle"].exists() {
                    switch(json["valueFormatter"]["numberStyle"]) {
                    case "CurrencyAccountingStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currencyAccounting;
                        }
                        break;
                    case "CurrencyISOCodeStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currencyISOCode;
                        }
                        break;
                    case "CurrencyPluralStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currencyPlural;
                        }
                        break;
                    case "CurrencyStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currency;
                        break;
                    case "DecimalStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .decimal;
                        break;
                    case "NoStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .none;
                        break;
                    case "OrdinalStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .ordinal;
                        }
                        break;
                    case "PercentStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .percent;
                        break;
                    case "ScientificStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .scientific;
                        break;
                    case "SpellOutStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .spellOut;
                        break;
                    default:
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .none;
                    }
                }

                (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.minimumFractionDigits = minimumDecimalPlaces;
                (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.maximumFractionDigits = maximumDecimalPlaces;
            }

            sets.append(dataSet);
        }
    }
    return LineChartData(dataSets: sets);
}


func getBarData(_ labels: [String], json: JSON!) -> BarChartData {
    if !json["dataSets"].exists() {
        return BarChartData();
    }

    let dataSets = json["dataSets"].arrayObject;
    var sets: [BarChartDataSet] = [];

    for set in dataSets! {
        let tmp = JSON(set);
        if tmp["values"].exists() {
            let values = tmp["values"].arrayValue.map({$0.doubleValue});
            let label = tmp["label"].exists() ? tmp["label"].stringValue : "";
            var dataEntries: [BarChartDataEntry] = [];

            for i in 0..<values.count {
                let dataEntry = BarChartDataEntry(x: values[i], y: Double(i));
                dataEntries.append(dataEntry);
            }

            let dataSet = BarChartDataSet(values: dataEntries, label: label);

            if tmp["barShadowColor"].exists() {
                dataSet.barShadowColor = RCTConvert.uiColor(tmp["barShadowColor"].intValue);
            }


            if tmp["highlightAlpha"].exists() {
                dataSet.highlightAlpha = CGFloat(tmp["highlightAlpha"].floatValue);
            }

            if tmp["highlightColor"].exists() {
                dataSet.highlightColor = RCTConvert.uiColor(tmp["highlightColor"].intValue);
            }

            if tmp["highlightLineDashLengths"].exists() {
                dataSet.highlightLineDashLengths = [CGFloat(tmp["highlightLineDashLengths"].floatValue)];
            }

            if tmp["highlightLineDashPhase"].exists() {
                dataSet.highlightLineDashPhase = CGFloat(tmp["highlightLineDashPhase"].floatValue);
            }

            if tmp["highlightLineWidth"].exists() {
                dataSet.highlightLineWidth = CGFloat(tmp["highlightLineWidth"].floatValue);
            }

            if tmp["stackLabels"].exists() {
                dataSet.stackLabels = tmp["stackLabels"].arrayValue.map({$0.stringValue});
            }

            if tmp["colors"].exists() {
                let arrColors = tmp["colors"].arrayValue.map({$0.intValue});
                dataSet.colors = arrColors.map({return RCTConvert.uiColor($0)});
            }

            if tmp["drawValues"].exists() {
                dataSet.drawValuesEnabled = tmp["drawValues"].boolValue;
            }

            if tmp["highlightEnabled"].exists() {
                dataSet.highlightEnabled = tmp["highlightEnabled"].boolValue;
            }

            if tmp["valueTextFontName"].exists() {
                dataSet.valueFont = UIFont(
                    name: tmp["valueTextFontName"].stringValue,
                    size: dataSet.valueFont.pointSize
                    )!;
            }

            if tmp["valueTextFontSize"].exists() {
                dataSet.valueFont = dataSet.valueFont.withSize(CGFloat(tmp["valueTextFontSize"].floatValue))
            }

            if tmp["valueTextColor"].exists() {
                dataSet.valueTextColor = RCTConvert.uiColor(tmp["valueTextColor"].intValue);
            }

            if tmp["axisDependency"].exists() {
                let value = tmp["axisDependency"].stringValue;
                if value == "left" {
                    dataSet.axisDependency = .left;
                } else if value == "right" {
                    dataSet.axisDependency = .right;
                }
            }

            if json["valueFormatter"].exists() {
                if json["valueFormatter"]["minimumDecimalPlaces"].exists() {
                    minimumDecimalPlaces = json["valueFormatter"]["minimumDecimalPlaces"].intValue;
                }
                if json["valueFormatter"]["maximumDecimalPlaces"].exists() {
                    maximumDecimalPlaces = json["valueFormatter"]["maximumDecimalPlaces"].intValue;
                }

                if json["valueFormatter"]["type"].exists() {
                    switch(json["valueFormatter"]["type"]) {
                    case "regular":
                        dataSet.valueFormatter = DefaultValueFormatter(formatter: NumberFormatter());
                        break;
                    case "abbreviated":
                        dataSet.valueFormatter = DefaultValueFormatter(formatter: ABNumberFormatter(minimumDecimalPlaces: minimumDecimalPlaces, maximumDecimalPlaces: maximumDecimalPlaces));
                        break;
                    default:
                        dataSet.valueFormatter = DefaultValueFormatter(formatter: NumberFormatter());
                    }
                }

                if json["valueFormatter"]["numberStyle"].exists() {
                    switch(json["valueFormatter"]["numberStyle"]) {
                    case "CurrencyAccountingStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currencyAccounting;
                        }
                        break;
                    case "CurrencyISOCodeStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currencyISOCode;
                        }
                        break;
                    case "CurrencyPluralStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currencyPlural;
                        }
                        break;
                    case "CurrencyStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currency;
                        break;
                    case "DecimalStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .decimal;
                        break;
                    case "NoStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .none;
                        break;
                    case "OrdinalStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .ordinal;
                        }
                        break;
                    case "PercentStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .percent;
                        break;
                    case "ScientificStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .scientific;
                        break;
                    case "SpellOutStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .spellOut;
                        break;
                    default:
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .none;
                    }
                }

                (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.minimumFractionDigits = minimumDecimalPlaces;
                (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.maximumFractionDigits = maximumDecimalPlaces;
            }

            sets.append(dataSet);
        }
    }
    return BarChartData(dataSets: sets);
}


func getBubbleData(_ labels: [String], json: JSON!) -> BubbleChartData {
    if !json["dataSets"].exists() {
        return BubbleChartData();
    }

    let dataSets = json["dataSets"].arrayObject;

    var sets: [BubbleChartDataSet] = [];

    for set in dataSets! {
        let tmp = JSON(set);
        if tmp["values"].exists() {
            let values = tmp["values"].arrayObject!;
            let label = tmp["label"].exists() ? tmp["label"].stringValue : "";
            var dataEntries: [BubbleChartDataEntry] = [];

            for i in 0..<values.count {
                let object = JSON(values[i]);
                let dataEntry = BubbleChartDataEntry(
                    x: object["value"].doubleValue,
                    y: Double(i),
                    size: CGFloat(object["size"].floatValue)
                );
                dataEntries.append(dataEntry);
            }

            let dataSet = BubbleChartDataSet(values: dataEntries, label: label);

            if tmp["colors"].exists() {
                let arrColors = tmp["colors"].arrayValue.map({$0.intValue});
                dataSet.colors = arrColors.map({return RCTConvert.uiColor($0)});
            }

            if tmp["drawValues"].exists() {
                dataSet.drawValuesEnabled = tmp["drawValues"].boolValue;
            }

            if tmp["highlightEnabled"].exists() {
                dataSet.highlightEnabled = tmp["highlightEnabled"].boolValue;
            }

            if tmp["highlightCircleWidth"].exists() {
                dataSet.highlightCircleWidth = CGFloat(tmp["highlightCircleWidth"].floatValue);
            }

            if tmp["valueTextFontName"].exists() {
                dataSet.valueFont = UIFont(
                    name: tmp["valueTextFontName"].stringValue,
                    size: dataSet.valueFont.pointSize
                    )!;
            }

            if tmp["axisDependency"].exists() {
                let value = tmp["axisDependency"].stringValue;
                if value == "left" {
                    dataSet.axisDependency = .left;
                } else if value == "right" {
                    dataSet.axisDependency = .right;
                }
            }

            if tmp["valueTextFontSize"].exists() {
                dataSet.valueFont = dataSet.valueFont.withSize(CGFloat(tmp["valueTextFontSize"].floatValue))
            }

            if tmp["valueTextColor"].exists() {
                dataSet.valueTextColor = RCTConvert.uiColor(tmp["valueTextColor"].intValue);
            }

            if json["valueFormatter"].exists() {
                if json["valueFormatter"]["minimumDecimalPlaces"].exists() {
                    minimumDecimalPlaces = json["valueFormatter"]["minimumDecimalPlaces"].intValue;
                }
                if json["valueFormatter"]["maximumDecimalPlaces"].exists() {
                    maximumDecimalPlaces = json["valueFormatter"]["maximumDecimalPlaces"].intValue;
                }

                if json["valueFormatter"]["type"].exists() {
                    switch(json["valueFormatter"]["type"]) {
                    case "regular":
                      dataSet.valueFormatter = DefaultValueFormatter(formatter: NumberFormatter());
                      break;
                    case "abbreviated":
                      dataSet.valueFormatter = DefaultValueFormatter(formatter: ABNumberFormatter(minimumDecimalPlaces: minimumDecimalPlaces, maximumDecimalPlaces: maximumDecimalPlaces));
                      break;
                    default:
                      dataSet.valueFormatter = DefaultValueFormatter(formatter: NumberFormatter());
                  }
                }

                if json["valueFormatter"]["numberStyle"].exists() {
                    switch(json["valueFormatter"]["numberStyle"]) {
                    case "CurrencyAccountingStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currencyAccounting;
                        }
                        break;
                    case "CurrencyISOCodeStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currencyISOCode;
                        }
                        break;
                    case "CurrencyPluralStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currencyPlural;
                        }
                        break;
                    case "CurrencyStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currency;
                        break;
                    case "DecimalStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .decimal;
                        break;
                    case "NoStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .none;
                        break;
                    case "OrdinalStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .ordinal;
                        }
                        break;
                    case "PercentStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .percent;
                        break;
                    case "ScientificStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .scientific;
                        break;
                    case "SpellOutStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .spellOut;
                        break;
                    default:
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .none;
                    }
                }

                (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.minimumFractionDigits = minimumDecimalPlaces;
                (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.maximumFractionDigits = maximumDecimalPlaces;
            }

            sets.append(dataSet);
        }
    }
    return BubbleChartData(dataSets: sets);
}

func getScatterData(_ labels: [String], json: JSON!) -> ScatterChartData {
    if !json["dataSets"].exists() {
        return ScatterChartData();
    }

    let dataSets = json["dataSets"].arrayObject;

    var sets: [ScatterChartDataSet] = [];

    for set in dataSets! {
        let tmp = JSON(set);
        if tmp["values"].exists() {
            let values = tmp["values"].arrayValue.map({$0.doubleValue});
            let label = tmp["label"].exists() ? tmp["label"].stringValue : "";
            var dataEntries: [ChartDataEntry] = [];

            for i in 0..<values.count {
                let dataEntry = ChartDataEntry(x: values[i], y: Double(i));
                dataEntries.append(dataEntry);
            }

            let dataSet = ScatterChartDataSet(values: dataEntries, label: label);

            if tmp["colors"].exists() {
                let arrColors = tmp["colors"].arrayValue.map({$0.intValue});
                dataSet.colors = arrColors.map({return RCTConvert.uiColor($0)});
            }

            if tmp["drawValues"].exists() {
                dataSet.drawValuesEnabled = tmp["drawValues"].boolValue;
            }

            if tmp["highlightEnabled"].exists() {
                dataSet.highlightEnabled = tmp["highlightEnabled"].boolValue;
            }

            if tmp["scatterShapeSize"].exists() {
                dataSet.scatterShapeSize = CGFloat(tmp["scatterShapeSize"].floatValue);
            }

            if tmp["scatterShapeHoleRadius"].exists() {
                dataSet.scatterShapeHoleRadius = CGFloat(tmp["scatterShapeHoleRadius"].floatValue);
            }

            if tmp["scatterShapeHoleColor"].exists() {
                dataSet.scatterShapeHoleColor = RCTConvert.uiColor(tmp["scatterShapeHoleColor"].intValue);
            }

            if tmp["scatterShape"].exists() {
                switch(tmp["scatterShape"]) {
                case "Square":
                    dataSet.setScatterShape(.square);
                    break;
                case "Circle":
                    dataSet.setScatterShape(.circle);
                    break;
                case "Triangle":
                    dataSet.setScatterShape(.triangle);
                    break;
                case "Cross":
                    dataSet.setScatterShape(.cross);
                    break;
                case "X":
                    dataSet.setScatterShape(.x);
                    break;
                default:
                    dataSet.setScatterShape(.square);
                    break;
                }
            }

            if tmp["valueTextFontName"].exists() {
                dataSet.valueFont = UIFont(
                    name: tmp["valueTextFontName"].stringValue,
                    size: dataSet.valueFont.pointSize
                    )!;
            }

            if tmp["valueTextFontSize"].exists() {
                dataSet.valueFont = dataSet.valueFont.withSize(CGFloat(tmp["valueTextFontSize"].floatValue))
            }

            if tmp["valueTextColor"].exists() {
                dataSet.valueTextColor = RCTConvert.uiColor(tmp["valueTextColor"].intValue);
            }

            if tmp["axisDependency"].exists() {
                let value = tmp["axisDependency"].stringValue;
                if value == "left" {
                    dataSet.axisDependency = .left;
                } else if value == "right" {
                    dataSet.axisDependency = .right;
                }
            }

            if json["valueFormatter"].exists() {
                if json["valueFormatter"]["minimumDecimalPlaces"].exists() {
                    minimumDecimalPlaces = json["valueFormatter"]["minimumDecimalPlaces"].intValue;
                }
                if json["valueFormatter"]["maximumDecimalPlaces"].exists() {
                    maximumDecimalPlaces = json["valueFormatter"]["maximumDecimalPlaces"].intValue;
                }

                if json["valueFormatter"]["type"].exists() {
                  switch(json["valueFormatter"]["type"]) {
                  case "regular":
                    dataSet.valueFormatter = DefaultValueFormatter(formatter: NumberFormatter());
                    break;
                  case "abbreviated":
                    dataSet.valueFormatter = DefaultValueFormatter(formatter: ABNumberFormatter(minimumDecimalPlaces: minimumDecimalPlaces, maximumDecimalPlaces: maximumDecimalPlaces));
                    break;
                  default:
                    dataSet.valueFormatter = DefaultValueFormatter(formatter: NumberFormatter());
                  }
                }

                if json["valueFormatter"]["numberStyle"].exists() {
                    switch(json["valueFormatter"]["numberStyle"]) {
                    case "CurrencyAccountingStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currencyAccounting;
                        }
                        break;
                    case "CurrencyISOCodeStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currencyISOCode;
                        }
                        break;
                    case "CurrencyPluralStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currencyPlural;
                        }
                        break;
                    case "CurrencyStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currency;
                        break;
                    case "DecimalStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .decimal;
                        break;
                    case "NoStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .none;
                        break;
                    case "OrdinalStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .ordinal;
                        }
                        break;
                    case "PercentStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .percent;
                        break;
                    case "ScientificStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .scientific;
                        break;
                    case "SpellOutStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .spellOut;
                        break;
                    default:
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .none;
                    }
                }

                (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.minimumFractionDigits = minimumDecimalPlaces;
                (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.maximumFractionDigits = maximumDecimalPlaces;
            }

            sets.append(dataSet);
        }
    }
    return ScatterChartData(dataSets: sets);
}

func getCandleStickData(_ labels: [String], json: JSON!) -> CandleChartData {
    if !json["dataSets"].exists() {
        return CandleChartData();
    }

    let dataSets = json["dataSets"].arrayObject;

    var sets: [CandleChartDataSet] = [];

    for set in dataSets! {
        let tmp = JSON(set);
        if tmp["values"].exists() {
            let values = tmp["values"].arrayObject!;
            let label = tmp["label"].exists() ? tmp["label"].stringValue : "";
            var dataEntries: [CandleChartDataEntry] = [];

            for i in 0..<values.count {
                let object = JSON(values[i]);
                let dataEntry = CandleChartDataEntry(
                    x: Double(i),
                    shadowH: object["shadowH"].doubleValue,
                    shadowL: object["shadowL"].doubleValue,
                    open: object["open"].doubleValue,
                    close: object["close"].doubleValue
                );
                dataEntries.append(dataEntry);
            }

            let dataSet = CandleChartDataSet(values: dataEntries, label: label);

            if tmp["colors"].exists() {
                let arrColors = tmp["colors"].arrayValue.map({$0.intValue});
                dataSet.colors = arrColors.map({return RCTConvert.uiColor($0)});
            }

            if tmp["drawValues"].exists() {
                dataSet.drawValuesEnabled = tmp["drawValues"].boolValue;
            }

            if tmp["highlightEnabled"].exists() {
                dataSet.highlightEnabled = tmp["highlightEnabled"].boolValue;
            }

            if tmp["valueTextFontName"].exists() {
                dataSet.valueFont = UIFont(
                    name: tmp["valueTextFontName"].stringValue,
                    size: dataSet.valueFont.pointSize
                    )!;
            }

            if tmp["valueTextFontSize"].exists() {
                dataSet.valueFont = dataSet.valueFont.withSize(CGFloat(tmp["valueTextFontSize"].floatValue))
            }

            if tmp["valueTextColor"].exists() {
                dataSet.valueTextColor = RCTConvert.uiColor(tmp["valueTextColor"].intValue);
            }

            if tmp["axisDependency"].exists() {
                let value = tmp["axisDependency"].stringValue;
                if value == "left" {
                    dataSet.axisDependency = .left;
                } else if value == "right" {
                    dataSet.axisDependency = .right;
                }
            }

            if tmp["barSpace"].exists() {
                dataSet.barSpace = CGFloat(tmp["barSpace"].floatValue);
            }

            if tmp["showCandleBar"].exists() {
                dataSet.showCandleBar = tmp["showCandleBar"].boolValue;
            }

            if tmp["shadowWidth"].exists() {
                dataSet.shadowWidth = CGFloat(tmp["shadowWidth"].floatValue);
            }

            if tmp["shadowColor"].exists() {
                dataSet.shadowColor = RCTConvert.uiColor(tmp["shadowColor"].intValue);
            }

            if tmp["shadowColorSameAsCandle"].exists() {
                dataSet.shadowColorSameAsCandle = tmp["shadowColorSameAsCandle"].boolValue;
            }

            if tmp["neutralColor"].exists() {
                dataSet.neutralColor = RCTConvert.uiColor(tmp["neutralColor"].intValue);
            }

            if tmp["increasingColor"].exists() {
                dataSet.increasingColor = RCTConvert.uiColor(tmp["increasingColor"].intValue);
            }

            if tmp["decreasingColor"].exists() {
                dataSet.decreasingColor = RCTConvert.uiColor(tmp["decreasingColor"].intValue);
            }

            if tmp["increasingFilled"].exists() {
                dataSet.increasingFilled = tmp["increasingFilled"].boolValue;
            }

            if tmp["decreasingFilled"].exists() {
                dataSet.decreasingFilled = tmp["decreasingFilled"].boolValue;
            }

            if json["valueFormatter"].exists() {
                if json["valueFormatter"]["minimumDecimalPlaces"].exists() {
                    minimumDecimalPlaces = json["valueFormatter"]["minimumDecimalPlaces"].intValue;
                }
                if json["valueFormatter"]["maximumDecimalPlaces"].exists() {
                    maximumDecimalPlaces = json["valueFormatter"]["maximumDecimalPlaces"].intValue;
                }

                if json["valueFormatter"]["type"].exists() {
                  switch(json["valueFormatter"]["type"]) {
                  case "regular":
                    dataSet.valueFormatter = DefaultValueFormatter(formatter: NumberFormatter());
                    break;
                  case "abbreviated":
                    dataSet.valueFormatter = DefaultValueFormatter(formatter: ABNumberFormatter(minimumDecimalPlaces: minimumDecimalPlaces, maximumDecimalPlaces: maximumDecimalPlaces));
                    break;
                  default:
                    dataSet.valueFormatter = DefaultValueFormatter(formatter: NumberFormatter());
                  }
                }

                if json["valueFormatter"]["numberStyle"].exists() {
                    switch(json["valueFormatter"]["numberStyle"]) {
                    case "CurrencyAccountingStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currencyAccounting;
                        }
                        break;
                    case "CurrencyISOCodeStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currencyISOCode;
                        }
                        break;
                    case "CurrencyPluralStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currencyPlural;
                        }
                        break;
                    case "CurrencyStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .currency;
                        break;
                    case "DecimalStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .decimal;
                        break;
                    case "NoStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .none;
                        break;
                    case "OrdinalStyle":
                        if #available(iOS 9.0, *) {
                            (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .ordinal;
                        }
                        break;
                    case "PercentStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .percent;
                        break;
                    case "ScientificStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .scientific;
                        break;
                    case "SpellOutStyle":
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .spellOut;
                        break;
                    default:
                        (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.numberStyle = .none;
                    }
                }

                (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.minimumFractionDigits = minimumDecimalPlaces;
                (dataSet.valueFormatter as! DefaultValueFormatter).formatter?.maximumFractionDigits = maximumDecimalPlaces;
            }

            sets.append(dataSet);
        }
    }
    return CandleChartData(dataSets: sets);
}

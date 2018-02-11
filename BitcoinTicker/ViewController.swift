
//  ViewController.swift
//  BitcoinTicker


import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    
    let currencyArray:[[String]] = [
        ["BCH", "BTC", "ETH", "LTC", "XMR", "XRP", "ZEC"], ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    ]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var currencySelected = ""
    var finalURL = ""
    var cryptoCurrency : String = ""
    var actualCurrency : String = ""
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var cryptoPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    //how many columns we want from picker (single spinner)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return currencyArray[component][row]
    }

    //delgate method
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        print("component " + "\(component)")
        print("row " + "\(row)")
        
        switch (component) {
        case 0:
            cryptoCurrency = currencyArray[component][row]
            print("CryptoCurrency is " + cryptoCurrency)
            finalURL = baseURL + cryptoCurrency
            print(finalURL)
        case 1:
            actualCurrency = currencyArray[component][row]
            print("actual Currency is " + actualCurrency)
        default:break
    }
        finalURL = baseURL + cryptoCurrency + actualCurrency
        print(finalURL)
        currencySelected = currencySymbolArray[row]
        getBitCoinData(url: finalURL)
    }

    //MARK: - Networking
    /***************************************************************/
    
    func getBitCoinData(url: String) {

        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the bitcoin data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitCoinData(json: bitcoinJSON)

                } else {
                    //print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }
    }

    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitCoinData(json : JSON) {

        if let bitcoinResult = json["ask"].double
        {
            bitcoinPriceLabel.text = currencySelected + String(bitcoinResult)
        }
        else
        {
            bitcoinPriceLabel.text = "Price Unavilable"
        }
    }
}

